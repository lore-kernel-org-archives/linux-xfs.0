Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbcLFGha (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Dec 2016 01:37:30 -0500
Date: Tue, 6 Dec 2016 14:37:28 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161206063728.GV29149@eguan.usersys.redhat.com>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161205143906.GA16352@infradead.org>
 <20161205153625.GA20032@infradead.org>
 <20161205182802.GB8436@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161205182802.GB8436@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 10:28:02AM -0800, Darrick J. Wong wrote:
> Does it happen if rmapbt=0 ?  Since xfs/109 isn't doing any CoW, it's

FYI, I looped xfs/109 for 150 times with rmapbt=0, and didn't hit any
problem.

[root@ibm-x3550m3-05 xfstests]# xfs_info /mnt/xfs
meta-data=/dev/mapper/testvg-testlv2 isize=512    agcount=4, agsize=20480 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=2048   blocks=81920, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=2048   blocks=1445, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Thanks,
Eryu
