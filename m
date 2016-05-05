Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B60BE7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:55:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C9F0AC003
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:55:20 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id Uw6nW4Q1iGPB5jx3 (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 10:55:17 -0700 (PDT)
Date: Thu, 5 May 2016 13:55:14 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1826465730.2008964.1462470914901.JavaMail.zimbra@redhat.com>
In-Reply-To: <1462310947-16132-6-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
	<1462310947-16132-6-git-send-email-hch@lst.de>
Subject: Re: [PATCH 05/14] xfs: implement iomap based buffered write path
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

----- Original Message -----
> Convert XFS to use the new iomap based multipage write path. This involves
> implementing the ->iomap_begin and ->iomap_end methods, and switching the
> buffered file write, page_mkwrite and xfs_iozero paths to the new iomap
> helpers.
> 
> With this change __xfs_get_blocks will never be used for buffered writes,
> and the code handling them can be removed.
> 
> Based on earlier code from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Kconfig     |   1 +
>  fs/xfs/xfs_aops.c  | 212
>  -----------------------------------------------------
>  fs/xfs/xfs_file.c  |  71 ++++++++----------
>  fs/xfs/xfs_iomap.c | 144 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.h |   5 +-
>  fs/xfs/xfs_iops.c  |   9 ++-
>  fs/xfs/xfs_trace.h |   3 +
>  7 files changed, 187 insertions(+), 258 deletions(-)
> 

Reviewed-by: Bob Peterson <rpeterso@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
