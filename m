Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC2D429DF5
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 03:01:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BC8BAC006
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 01:01:52 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DAH3pft7qeYwV4DW (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 01:01:51 -0700 (PDT)
Date: Sun, 9 Aug 2015 01:01:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] xfs: don't leave EFIs on AIL on mount failure
Message-ID: <20150809080150.GA4253@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-7-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-7-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

>  STATIC int
>  xlog_recover_process_efis(
> -	struct xlog	*log)
> +	struct xlog		*log,
> +	bool			cancel)

There is almost no code shared between cancelation and processing,
so please add a new xlog_cancel_efis helper instead.

> +		efip = (struct xfs_efi_log_item *) lip;

Please use container_of to get to a containing structure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
