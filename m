Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 19:47:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O2lio2014186
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 19:47:46 -0700
Message-ID: <4860604C.4090109@sgi.com>
Date: Tue, 24 Jun 2008 12:47:40 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] check for invalid flags in xfs_attrlist_by_handle
References: <20080531075829.GA5424@lst.de> <485B431F.2070905@sgi.com> <20080623113946.GA32665@lst.de>
In-Reply-To: <20080623113946.GA32665@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Jun 20, 2008 at 03:41:51PM +1000, Timothy Shimmin wrote:
>> Fair enough.
>> Actually, I think we only use ATTR_ROOT and ATTR_SECURE for the
>> namespace flags.
>> So you could probably use: XFS_ATTR_NSP_ARGS
>> xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS_MASK	 (ATTR_ROOT | ATTR_SECURE)
>> xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS(flags) ((flags) & XFS_ATTR_NSP_ARGS_MASK)
>> and something like:
>>
>> if (!XFS_ATTR_NSP_ARGS(al_hreq.flags))
>>          return -XFS_ERROR(EINVAL);
> 
> Actually a zero flags is of course valid too.
> 
Ah, that would be why I used the phrase "something like" ;-))
Good pt.

> So the check should be & ~(ATTR_ROOT | ATTR_SECURE).  I could use
> XFS_ATTR_NSP_ARGS_MASK but that would pull in not just xfs_attr_leaf.h
> but also xfs_da_btree.h and that needs even more headers..
> 
> So I propose this simple version:
> 
Cool.
I was just thinking about centralising stuff in case we extend the
namespaces. But that's fine.
I'll check it in...

--Tim

> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-20 08:17:13.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-06-23 13:38:17.000000000 +0200
> @@ -470,6 +470,12 @@ xfs_attrlist_by_handle(
>  	if (al_hreq.buflen > XATTR_LIST_MAX)
>  		return -XFS_ERROR(EINVAL);
>  
> +	/*
> +	 * Reject flags, only allow namespaces.
> +	 */
> +	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
> +		return -XFS_ERROR(EINVAL);
> +
>  	error = xfs_vget_fsop_handlereq(mp, parinode, &al_hreq.hreq, &inode);
>  	if (error)
>  		goto out;
> 
