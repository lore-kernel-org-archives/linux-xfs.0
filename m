Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D99A67F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 07:37:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B52AA8F8039
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 05:37:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DX3EtJs46uLD1MkA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 05:37:28 -0700 (PDT)
Date: Mon, 10 Aug 2015 08:37:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/11] xfs: disentagle EFI release from the extent count
Message-ID: <20150810123726.GA18933@bfoster.bfoster>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-2-git-send-email-bfoster@redhat.com>
	<20150809073641.GA3163@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150809073641.GA3163@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Aug 09, 2015 at 12:36:41AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 06, 2015 at 01:44:22PM -0400, Brian Foster wrote:
> 
> -       __xfs_efi_release(efip);
> +	xfs_efi_release(efip);
> 
> Can you explain in the changelog why this is safe?
> 

I thought it did. I'll try to elaborate.

> 
> > -xfs_efi_release(xfs_efi_log_item_t	*efip,
> > -		uint			nextents)
> > +xfs_efi_release(struct xfs_efi_log_item	*efip)
> 
> Can you use normal XFS function formatting here? e.g.
> 
> xfs_efi_release(
> 	struct xfs_efi_log_item		*efip)
> 

Ok.

> 
> As a follow on we should be able to remove atomic_inc_return and
> replace it with a local iterator in xfs_bmap_finish().
> 

I'm not sure what you mean here...

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
