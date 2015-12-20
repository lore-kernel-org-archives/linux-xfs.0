Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6E6C7F62
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 09:36:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86D5A8F8035
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:36:51 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id kR2kt1ljapVhSeLW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:36:49 -0800 (PST)
Date: Sun, 20 Dec 2015 07:36:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/4] xfsprogs: mkfs: fix unintentional integer overflow
Message-ID: <20151220153649.GE20135@infradead.org>
References: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
	<1449832143-26356-4-git-send-email-t.vivek@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449832143-26356-4-git-send-email-t.vivek@samsung.com>
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
To: Vivek Trivedi <t.vivek@samsung.com>
Cc: a.sahrawat@samsung.com, pankaj.m@samsung.com, xfs@oss.sgi.com

> +++ b/mkfs/xfs_mkfs.c
> @@ -2022,7 +2022,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  		 * and the underlying volume is striped, then set rtextblocks
>  		 * to the stripe width.
>  		 */
> -		int		rswidth;
> +		__uint64_t	rswidth;
>  		__uint64_t	rtextbytes;

This looks odd.  We initiallize assigned ft.rtswidth (which is an int)
or 0 to it.  I think you want a separate variable for the result of
the  DTOBT(rswidth) statement to make this clear.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
