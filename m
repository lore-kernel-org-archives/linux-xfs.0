Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C79C7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:34:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8408BAC003
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:34:55 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id vsVZzyDaLsl7mEzT (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 10:34:53 -0700 (PDT)
Date: Thu, 5 May 2016 13:34:50 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <378179150.1999179.1462469690382.JavaMail.zimbra@redhat.com>
In-Reply-To: <1462310947-16132-5-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
	<1462310947-16132-5-git-send-email-hch@lst.de>
Subject: Re: [PATCH 04/14] xfs: reorder zeroing and flushing sequence in
	truncate
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
> Currently zeroing out blocks and waiting for writeout is a bit of a mess in
> truncate.  This patch gives it a clear order in preparation for the iomap
> path:
> 
>  (1) we first wait for any direct I/O to complete to prevent any races
>      for it
>  (2) we then perform the actual zeroing, and only use the truncate_page
>      helpers for truncating down.  The truncate up case already is
>      handled by the separate call to xfs_zero_eof.
>  (3) only then we write back dirty data, as zeroing block may cause
>      dirty pages when using either xfs_zero_eof or the new iomap
>      infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> +	 * Start with zeroing any data beyond EOF that we may expose on file
> +	 & extension, or zeroing out the rest of the block on a downward

This "&" should be "*".

Reviewed-by: Bob Peterson <rpeterso@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
