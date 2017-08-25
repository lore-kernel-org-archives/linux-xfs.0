Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37478 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdHYE4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 00:56:00 -0400
Date: Thu, 24 Aug 2017 21:54:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170825045443.GD4800@magnolia>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
 <87a82ok45i.fsf@notabene.neil.brown.name>
 <20170824233453.eqxxlckkelp334yi@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824233453.eqxxlckkelp334yi@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: NeilBrown <neilb@suse.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, Dmitri Pal <dpal@redhat.com>

On Thu, Aug 24, 2017 at 07:34:53PM -0400, Theodore Ts'o wrote:
> On Fri, Aug 25, 2017 at 08:11:05AM +1000, NeilBrown wrote:
> > 
> > Just to provide contrast, NFS has a config file which can provide
> > certain defaults for mounted filesystems.  However it doesn't require a
> > udev event to achieve this.
> 
> I think we're mixing multiple things, and that may be confusing the
> discussion.  A config file parser is a technology.  *How* you use the
> config file parser can be quite different even if it is using the same
> config file parser or config file format.

<shrug> Well, they /are/ interlinked, at least -- if XFS were to adopt
a program to inject config file values into the kernel and a config file
for mkfs, I think it makes sense at least to think about sharing the
same parser for both, though we needn't do that in /this/ particular
thread.  OTOH it's something to keep in the back of one's head while we
hash out what, if anything, to put in a mount uevent.

> From what I've seen in this e-mail thread, there are at least three
> different use cases:
> 
> 1)  How mkfs uses to create the file system
> 2)  How the file system should be configured when/while it is mounted
> 3)  Message marshalling and unmarshalling when communicating with the
>     kernel via uevents

I wasn't suggesting we try to make uevent formats so fancy that they
require parsing; the current environment variable mechanism is just
fine.

> > Instead, it provides "/sbin/mount.nfs" which imposes the defaults at
> > mount time, rather than just after mount time.
> > 
> > There could, conceivably, be an "/sbin/mount.xfs" which read the config
> > file and set all the defaults concurrently with the mount operation.
> 
> For nfs there are a large number of knobs that are of interest at
> mount time, such that specifying them all as mount options on the
> command line, or in /etc/fstab, gets spectacularly painful.  Which is
> why /etc/nfsmount.conf makes sense.
> 
> For ext4 and nfs we have many more knobs that come into play when the
> file system is created, and so for ext4 that's why I have
> /etc/mke2fs.conf, where I might have some complex stanzas such as:
> 
>     hugefile = {
>         features = extent,huge_file,bigalloc,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,sparse_super2
>         cluster_size = 32768
>         hash_alg = half_md4
>         reserved_ratio = 0.0
>         num_backup_sb = 0
>         packed_meta_blocks = 1
>         make_hugefiles = 1
>         inode_ratio = 4194304
>         hugefiles_dir = /huge-dir
>         hugefiles_name = huge-data
>         hugefiles_digits = 0
>         hugefiles_size = 0
>         hugefiles_align = 256M
>         hugefiles_align_disk = true
>         num_hugefiles = 1
>         zero_hugefiles = false
> 	flex_bg_size = 262144
>     }
> 
> ...and then the sysadmin only has to type "mke2fs -T hugefile
> /dev/sdc3" (for example).

(FWIW I'm interested in pursuing usage types in a mkfs.xfs config but
I'll hold on to that until we start that discussion.)

> The question of using the same parser for uevents is yet another can
> of worms.  And there, I think we need to be careful about what the
> requirements are for these uevents.  Uevents is just the technology.
> There are many use cases for that technology; are you using them to
> signal mounts/unmounts?  And at the file system level or at the mount
> namespace level?
> 
> Are you using them to single file system corruption problems?  And if
> so, are you trying to trying to send a single bit of information ---
> "the file system is corrupted"?  Or are you trying to send much more
> information --- for example, sending each inode that file system found
> that was corrupted, and each block number where the SCSI device found
> a media error?  (We have a solution that does this inside Google, and
> it uses a netlink socket to do the delievery.  I'm pretty sure that if
> you used uevents, udev could melt down if there are a large number of
> errors reported.)

For now I'd only send along the fact that the fs shut down.  If XFS ever
grows the ability to receive notifications that a range of blocks has
gone bad we could (ratelimited) push that up too.

> And then the final question here is how much does standardization
> help?  Are there use cases where progams really want to use the same
> format when updating /etc/mke2fs.conf versus /etc/nfsmount.conf versus
> /etc/mkfs.xfs.conf?  Or is this more of, "let's try to make life
> slightly easier for the user by keeping things mostly the same as we
> can"?  Or is this just a matter of file system developers sharing
> their experiences of various different designs, just so that they are
> aware of what libaries or code bases are available for them to use?

/I/ was looking for sharing experiences and trying to make life somewhat
easier for administrators by keeping the syntax roughly the same, even
if the particular keys and values aren't exactly the same from one fs to
the other.  Ultimately, we can (and probably will) do whatever we think
is a good fit for XFS, but seeing as there are some things that other
filesystems have done that we haven't, we could at least benefit from
whatever people learned from plumbing support into those filesystms.

I thought about the "mount.nfs mounts the filesystem and then plugs in
the config as desired" but then realized that it's a suid executable and
yeeech. :)

--D

> 
> Cheers,
> 
> 						- Ted
