Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 01:21:44 -0800 (PST)
Received: from spike.grumly.eu.org (spike.grumly.eu.org [195.5.253.226])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA69LXZZ003355
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 01:21:37 -0800
Date: Tue, 6 Nov 2007 10:21:57 +0100
From: Cedric - Equinoxe Media <cedric@e-m.fr>
Subject: Re: xfs crash
Message-ID: <20071106092157.GB16694@e-m.fr>
References: <20071105215135.GA12238@e-m.fr> <20071106082632.GU995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071106082632.GU995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On 06/11/2007 19:26, David Chinner wrote:
> On Mon, Nov 05, 2007 at 10:51:35PM +0100, Cedric - Equinoxe Media wrote:
> > XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
> > fs/xfs/xfs_alloc.c.  Caller 0xffffffff88113b35
> > 
> > Call Trace:
> >  [<ffffffff88111fcb>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
> >  [<ffffffff88113b35>] :xfs:xfs_free_extent+0xa9/0xc9
> >  [<ffffffff8811cf77>] :xfs:xfs_bmap_finish+0xee/0x167
> >  [<ffffffff8813c843>] :xfs:xfs_itruncate_finish+0x19b/0x2e0
> >  [<ffffffff881543c1>] :xfs:xfs_setattr+0x841/0xe57
> 
> Corrupted free space btree, by the look of it. Can you run
> xfs_check on the filesystem and report the output. You can recover
> from this by running xfs_repair.

xfs_check /dev/sda4 :
bad format 2 for inode 2961770479 type 0
bad format 2 for inode 3229517262 type 0
block 20/621714 type unknown not expected
link count mismatch for inode 2961770479 (name ?), nlink 0, counted 1
link count mismatch for inode 3229517262 (name ?), nlink 0, counted 1

the xfs_repair worked perfectly.

Do you have an idea why this corruption happened ?

Thanks.
Cédric
