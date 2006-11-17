Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 22:59:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAH6x1aG019794
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 22:59:03 -0800
Date: Fri, 17 Nov 2006 17:58:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <20061117065810.GU11034@melbourne.sgi.com>
References: <455CB54F.8080901@sandeen.net> <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local> <20061117023946.GN11034@melbourne.sgi.com> <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local> <20061117055521.GS11034@melbourne.sgi.com> <52841.10.0.0.2.1163745285.squirrel@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52841.10.0.0.2.1163745285.squirrel@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Fri, Nov 17, 2006 at 12:34:45AM -0600, sandeen@sandeen.net wrote:
> > On Fri, Nov 17, 2006 at 02:11:12PM +1000, Timothy Shimmin wrote:
> 
> > Whenever you add to the table, you now need to modify both the new
> > entry and the terminator to get it right.
> >
> > Nor (IMO) is it obvious that it is a terminator or why it is
> > different to all the other entries in the structure. A field such as
> > sb_dummy or sb_pad before the terminator is fairly obvious, and it
> > means that you don't need to modify the table terminator every time
> > the superblock gets extended.
> >
> > That way the code stays more consistent over time, diffs are smaller
> > and neater, and you can see at a simple diff just how the features
> > have been added over time (like I did this morning).....
> 
> nothing in the code is terribly obvious.. please add comments however you
> decide to fix it :)

*nod*

> and really, now that this is out in the wild, maybe sb_features3 instead
> of padding is appropriate, and check both for the attr2 bit...? :(

I'm not sure that this is a good idea, especially as past history of
introducing new feature bits is anything to go by (I think this makes bug #6
that the features2 field has been responsible for). I'd much prefer to
fix the bug, blacklist the bad 4 bytes in the superblock, and then either:

	- modify xfs_admin/repair to detect a busted superblock and have them
	  fix it; or
	- put code in the mount path that detects this and corrects it
	  automatically (which we do for some other superblock fields).

> i'm trying to figure out what the kernel upgrade path is for fc6 users who
> have an extra-padded-flipped features2/attr2 filesystem.  :(

Depends on what we do to fix it, right? Do you have any preferences?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
