Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41005 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbcLJTmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Dec 2016 14:42:21 -0500
Date: Sat, 10 Dec 2016 11:42:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Message-ID: <20161210194214.GL8436@birch.djwong.org>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Sat, Dec 10, 2016 at 10:04:39AM +0200, Amir Goldstein wrote:
> Dave,
> 
> I would like to have some system's storage pre-formatted
> with rmapbt and reflink support without allowing reflink until
> the day comes where the feature is declared stable.

Heh heh heh.... ;)

> I realize that rmapbt/reflink features are declared unstable and
> bugs could certainly be lurking without doing any reflinks at all.
> However, I estimate the the class of bugs introduces by heavily
> reflinked file systems is going to take more time to tame.

Yes, probably.  It seems reasonably stable on a young FS, though we'll
see how gracefully it ages.  There's probably mistakes in the ENOSPC
handling since that seems to be everyone's Achilles heel.

> Considering these options for said systems:
> 1. kernel v4.8.y or v4.9.y and mkfs.xfs -m rmapbt=1
> 2. kernel v4.9.y and mkfs.xfs -m rmapbt=1
> 3. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflink=1
>     and new mount option -onoreflink
> 4. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflinkbt=1
>     (separate rocomapt features reflinkbt from reflink)
> 
> Options 1-2 would require adding support in xfs_admin to
> enable reflink on an existing fs (by cloning the bmbt).

Not sure why you'd clone the bmbt...?

You'd simply use the rmap information to calculate a new refcountbt,
just like the offline repair already knows how to do.

Now obviously if you don't have rmap information then you have to walk
all the inode data forks in the system to get rmap information... we
don't share non-data blocks and never will, particularly since we've
stamped owner information into all the metadata headers.

(More on this later)

> Option 3 would require adding a simple noreflink
> mount option to disable reflink related ops.
> 
> Option 4 requires changing mkfs.xfs before 4.9 release
> and possibly setting recompat feature reflink on first file
> reflink. There are several precedents to this sort of  "set
> on first use" feature in ext4, not sure if there are any in xfs.

There are several of these in XFS, but I don't want to burn another
feature bit if I can avoid it.  Dave might have a different opinion
though?

> The benefit of having this functionality is that others,
> like me, could provide more testing for the refcount<=1
> use case. I myself intend to test refcount>1 as well, but
> the goal of getting recount<=1 ready for production is
> higher priority.

If you're building your own kernels, you could just tweak
xfs_reflink_remap_range with something like:

if (!capable(CAP_SYS_ADMIN))
	return -EOPNOTSUPP;

so that only you (well, root) can make files share blocks.

> Another benefit from option #4 is that you may be able
> to declare rmapbt=1,reflinkbt=1 stable and/or default
> mkfs options prior to declaring reflink=1 stable.

Ew, more mkfs options to test. :(

(I'd call it refcountbt anyway.)

In any case there is no point to having a separate refcountbt option
because if nobody ever shares any blocks, each AG will have a single
refcountbt block with zero records that never gets touched.

> Which, if any, of the options above would you be willing
> to endorse?

Well, to paraphrase the ext4 manual,

"The recommended method for upgrading an [old] filesystem to [a new one]
is to back up the entire volume, reformat the storage device with [the
new mkfs options], and restore the entire volume onto the fresh
filesystem."

https://ext4.wiki.kernel.org/index.php/UpgradeToExt4

But I'd also say read on...

> Darrick,
> 
> I seem to recall you taking about enabling reflink on existing
> fs sometime before, but I could not find that reference.
> I suppose you had an idea of how this should be done?

Christoph posted the first patchset to enable at runtime:
http://oss.sgi.com/archives/xfs/2016-06/msg00053.html

ISTR Dave didn't really like the idea of a mount option.  I think it's
a little awkward to toggle fs features that way and would rather just
implement a SET_GEOMETRY ioctl that the administrator can call to flip
on certain features.

As for dynamically constructing a new rmapbt or a new refcountbt --
there's a few tricky bits that have to be dealt with before we start
turning on features.  The first is ensuring that the log size is
sufficient to handle the new options being turned on, the second is to
teach xfs_repair not to freak out if its precalculated notions of where
the root inode should be don't square with where it actually is
(provided the root inode looks ok), and the third is making sure there's
enough space in each AG to build the relevant data structures.  There
might be more; I haven't had time to investigate this.

xfs_repair already knows how to construct fresh rmap and refcount
btrees; it does this any time you run xfs_repair without -n.  I've done
evil things like manually flip on the two feature bits via xfs_db and
run xfs_repair to build the btrees.  It works, more or less, though
messing with your filesystem with the debugger is sketchy. ;)

As far as doing things online, we actually now have the raw pieces you'd
need to enable (some) features.  The upcoming online repair code can
(via questionable VFS interactions) freeze incoming IO so that we can
scan the whole FS to construct a new rmap btree.  It also can use
existing rmap information to construct a new refcount btree.

In theory we could allow people to turn things on dynamically provided
the FS meets all the requirements (log space, rootino doesn't move, free
AG space).  It'd be pretty easy to do this for reflink since the space
requirements are minimal, and much more risky to let people do that for
rmap.  We'd need thorough testing, too.

--D

PS: I resurrected spaceman and ported it to GETFSMAP.

> 
> Amir.
> 
> 
> * D-Day of course stands for Darrick's-day ;-)
