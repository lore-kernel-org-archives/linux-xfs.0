Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 02:43:17 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l919hCHV014146
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 02:43:13 -0700
Subject: Re: Creation time in XFS
References: <200709302124.38164.Martin@lichtvoll.de>
	<470042DC.2040009@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Oct 2007 11:30:01 +0200
In-Reply-To: <470042DC.2040009@sgi.com>
Message-ID: <p73ve9r6v3a.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, xfs@oss.sgi.com

Timothy Shimmin <tes@sgi.com> writes:

> No XFS does not support creation time. It just has the regular
> atime,mtime and ctime.
> There are no plans that I've heard to support it.
> Not much involved to support it AFAICT but it would either involve
> changing the ondisk format of the inode or storing it in an EA.

If you ever change the on disk format adding a file type similar to ext3
to directories could also greatly speed up find in many cases.

> I wonder how this creation time is being exported currently?

I don't think it is at all currently:

% gid i_crtime
fs/udf/udf_i.h:21:#define UDF_I_CRTIME(X)               ( UDF_I(X)->i_crtime )
include/linux/ext4_fs.h:344:    __le32  i_crtime;       /* File Creation time */
include/linux/ext4_fs_i.h:160:  struct timespec i_crtime;
include/linux/udf_fs_i.h:20:    struct timespec         i_crtime;
fs/ext4/ialloc.c:566:   inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
fs/ext4/inode.c:2705:   EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
fs/ext4/inode.c:2792:   EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);

-Andi
