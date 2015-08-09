Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5BF329DF5
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 02:56:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2741304043
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 00:56:42 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HqJVngExFCyGjHCE (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 00:56:41 -0700 (PDT)
Date: Sun, 9 Aug 2015 00:56:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfs: use EFI refcount consistently in log recovery
Message-ID: <20150809075640.GE3163@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-6-git-send-email-bfoster@redhat.com>
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

> +	error = xfs_efi_copy_format(&(item->ri_buf[0]), &(efip->efi_format));
> +	if (error) {
>  		xfs_efi_item_free(efip);

Shou;dn't we switch all users of xfs_item_free except for
xfs_efi_release to xfs_efi_release now for consistency?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
