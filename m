Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB7997F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 07:37:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E8A4AC003
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 05:37:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DgSMUa1wKfe6Ymeg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 05:37:55 -0700 (PDT)
Date: Mon, 10 Aug 2015 08:37:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/11] xfs: use EFI refcount consistently in log recovery
Message-ID: <20150810123753.GB18933@bfoster.bfoster>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-6-git-send-email-bfoster@redhat.com>
	<20150809075640.GE3163@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150809075640.GE3163@infradead.org>
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

On Sun, Aug 09, 2015 at 12:56:40AM -0700, Christoph Hellwig wrote:
> > +	error = xfs_efi_copy_format(&(item->ri_buf[0]), &(efip->efi_format));
> > +	if (error) {
> >  		xfs_efi_item_free(efip);
> 
> Shou;dn't we switch all users of xfs_item_free except for
> xfs_efi_release to xfs_efi_release now for consistency?
> 

I don't think that's necessarily correct, at least as a one-to-one
conversion. We'd have to release two references here as well as in the
unlock handler if the transaction is aborted.

E.g., the reference count is only relevant once the EFI enters the
transaction subsystem.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
