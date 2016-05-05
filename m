Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C85D17CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:28:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F501AC004
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:28:01 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id b0bRCTbMFiLMtjzA (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 10:27:59 -0700 (PDT)
Date: Thu, 5 May 2016 13:27:55 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <367672176.1997654.1462469275533.JavaMail.zimbra@redhat.com>
In-Reply-To: <1462310947-16132-2-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
	<1462310947-16132-2-git-send-email-hch@lst.de>
Subject: Re: [PATCH 01/14] fs: move struct iomap from exportfs.h to a
	separate	header
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
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/nfsd/blocklayout.c    |  1 +
>  fs/nfsd/blocklayoutxdr.c |  1 +
>  fs/xfs/xfs_pnfs.c        |  1 +
>  include/linux/exportfs.h | 16 +---------------
>  include/linux/iomap.h    | 21 +++++++++++++++++++++
>  5 files changed, 25 insertions(+), 15 deletions(-)
>  create mode 100644 include/linux/iomap.h

Reviewed-off-by: Bob Peterson <rpeterso@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
