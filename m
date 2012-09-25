Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8P9ZC0b037752 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 04:35:12 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BRx0xy3rK4NeJ0mq (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 02:36:28 -0700 (PDT)
Date: Tue, 25 Sep 2012 05:36:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: reduce code duplication handling inode32/64
	options
Message-ID: <20120925093627.GE9189@infradead.org>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-4-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348147961-7520-4-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 20, 2012 at 10:32:38AM -0300, Carlos Maiolino wrote:
> Add xfs_set_inode32() to be used to enable inode32 allocation mode. this will
> reduce the amount of duplicated code needed to mount/remount a filesystem with
> inode32 option.
> This patch also changes xfs_set_inode64() to return the maximum AG number that
> inodes can be allocated instead of set mp->m_maxagi by itself, so that the
> behaviour is the same as xfs_set_inode32().
> This simplifies code that calls these functions and needs to know the maximum
> AG that inodes can be allocated in.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
