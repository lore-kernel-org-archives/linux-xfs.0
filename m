Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966373AbcIYO6T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Sep 2016 10:58:19 -0400
Date: Sun, 25 Sep 2016 22:58:16 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] libxcmd: fix counting of xfs entries in fs_table_insert
Message-ID: <20160925145816.GD27776@eguan.usersys.redhat.com>
References: <1474798162-25960-1-git-send-email-eguan@redhat.com>
 <20160925143155.GB29268@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160925143155.GB29268@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, billodo@redhat.com, xfs@oss.sgi.com

On Sun, Sep 25, 2016 at 07:31:55AM -0700, Christoph Hellwig wrote:
> On Sun, Sep 25, 2016 at 06:09:22PM +0800, Eryu Guan wrote:
> > Commit bb80e3d6cd04 ("libxcmd: populate fs table with xfs entries
> > first, foreign entries last") adds a new counter "xfs_fs_count" and
> > increases the counter when inserting an XFS entry.
> > 
> > But it missed a counter when fs_count is zero (inserting the first
> > path) and the entry has no FS_FOREIGN bit set, i.e. the first XFS
> > entry doesn't increase xfs_fs_count.
> > 
> > This results in args_command() mess and infinite loop in xfs/244
> > when testing v4 XFS (xfs/244 notrun on v5 XFS, but this bug still
> > reproduces on v5 XFS). e.g.
> > 
> >   mkfs -t xfs -f /dev/sda5
> >   mount -o pquota /dev/sda5 /mnt/xfs
> >   mkdir /mnt/xfs/project
> >   touch /mnt/xfs/project/testfile
> >   xfs_quota -x -c "project -s -p /mnt/xfs/project/testfile 1" /dev/sda5
> > 
> > Fix it by increasing xfs_fs_count when flags has no FS_FOREIGN bit.
> 
> Looks ifne,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can I assume you'll add the above test to xfstests?

It's already part of xfs/244, I noticed this bug because xfs/244 kept
running. I just put the minimum steps in commit log. So I think we're
good :)

Thanks,
Eryu
