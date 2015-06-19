Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD0747F86
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 06:10:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE0E5304039
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 04:10:24 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id k5IlOj7hcB4FJaIO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 04:10:22 -0700 (PDT)
Date: Fri, 19 Jun 2015 04:10:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/17] xfsprogs: use common code for multi-disk detection
Message-ID: <20150619111022.GA5212@infradead.org>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-2-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434711726-13092-2-git-send-email-jtulak@redhat.com>
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
To: Jan ??ul??k <jtulak@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

> index 70e43a0..3269ec3 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -26,9 +26,15 @@ QAHFILES = libxfs.h libxlog.h \
>  	xfs_inode.h \
>  	xfs_log_recover.h \
>  	xfs_metadump.h \
> +	xfs_mkfs.h \
>  	xfs_mount.h \
> +	xfs_quota_defs.h \
> +	xfs_sb.h \
> +	xfs_shared.h \
>  	xfs_trace.h \
> -	xfs_trans.h
> +	xfs_trans.h \
> +	xfs_trans_resv.h \
> +	xfs_trans_space.h

These shouldn't be added to the headers installed by make install-qa.

(which I'm going to send a patch to remove once Dave applied the
build fix, btw)

Also I'm not sure xfs_mkfs.h really is a good name for a global header.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
