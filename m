Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6ABF7F47
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 02:36:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61C22AC004
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2015 00:36:44 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wvZXp6M8DVBHtoCv (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2015 00:36:43 -0700 (PDT)
Date: Sun, 9 Aug 2015 00:36:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] xfs: disentagle EFI release from the extent count
Message-ID: <20150809073641.GA3163@infradead.org>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-2-git-send-email-bfoster@redhat.com>
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

On Thu, Aug 06, 2015 at 01:44:22PM -0400, Brian Foster wrote:

-       __xfs_efi_release(efip);
+	xfs_efi_release(efip);

Can you explain in the changelog why this is safe?


> -xfs_efi_release(xfs_efi_log_item_t	*efip,
> -		uint			nextents)
> +xfs_efi_release(struct xfs_efi_log_item	*efip)

Can you use normal XFS function formatting here? e.g.

xfs_efi_release(
	struct xfs_efi_log_item		*efip)


As a follow on we should be able to remove atomic_inc_return and
replace it with a local iterator in xfs_bmap_finish().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
