Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbeAJWyn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 17:54:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0AMqfZA155806
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 22:54:43 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2fdtjurcjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 22:54:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0AMsg5b011151
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 22:54:42 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0AMsfP6030131
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 22:54:42 GMT
Date: Wed, 10 Jan 2018 14:54:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Parent pointer design bugs
Message-ID: <20180110225440.GV5602@magnolia>
References: <adf6f96f-fc4b-e2eb-a204-db8a39007fa7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adf6f96f-fc4b-e2eb-a204-db8a39007fa7@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 10, 2018 at 12:46:16PM -0700, Allison Henderson wrote:
> Hi all,
> 
> I've been working on a new xfstest for parent pointers, and discovered
> that parent pointers are not getting created for protofiles.

xfsprogs, IOWs.

> I'm exploring the idea of adding the parent pointer in
> xfs_dir_createname (instead of xfs-create/xfs_link/xfs_rename).  But I
> think that means that I'd have to change xfs_dir_createname to take
> the new xfs_inode instead of just the xfs_ino_t.

Yes, you'd probably want to pass the inode to xfs_dir_createname (and I
suppose xfs_dir_removename) if you decide to move the point at which you
queue the pptr defer op into the _dir_ functions.

However, consider the repair case where we either (a) have a dir entry
and no pptr or (b) have a pptr but no dir entry.  It's easy to repair
the directory links in either scenario if directory updates and parent
pointer updates are kept as separate libxfs calls.

There's also mkfs/proto.c which want to be able to create an arbitrary
directory tree in exactly the same way as a regular creation would.  It
seems to me that the orphanage management functions in repair/phase6.c
are doing basically the same sort of things -- creating the lost+found
directory, linking orphaned inodes into said lost+found directory,
re-stuffing collected directory entries into a directory, etc.  Perhaps
it makes more sense to hoist some of the fs/xfs/xfs_inode.c functions
into libxfs, add the pptr calls to those functions, port that to
xfsprogs, and then refactor mkfs/repair to use the new libxfs functions?

FWIW xfs_inode.c is already ~3600 lines long and contains routines for
handling inodes and for various directory manipulations involving
inodes, so I think it's fine to break that file up.

> Which I'm not sure is going to work out in all cases where it is used.
> Before I end up chasing it too long and changing the design too much,
> I wanted to get some feed back to see what folks thoughts were.
> Thanks!

tldr: I'm leaning towards refactor and port some of the xfs_inode
routines to xfsprogs... :)

--D

> 
> Allison Henderson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
