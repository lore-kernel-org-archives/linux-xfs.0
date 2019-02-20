Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50162 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfBTR0T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Feb 2019 12:26:19 -0500
Date: Wed, 20 Feb 2019 09:26:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] libhandle: zero terminate fspath string
Message-ID: <20190220172614.GO32253@magnolia>
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
 <bce2b57b-50c8-0b56-b42d-9ff357c26eb6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bce2b57b-50c8-0b56-b42d-9ff357c26eb6@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 19, 2019 at 05:33:46PM -0600, Eric Sandeen wrote:
> I had a heck of a time chasing through whether we were null terminated
> by now or not, so just be safe and do it explicitly.
> 
> Addresses-Coverity-ID: 1297520 ("Buffer not null terminated")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/libhandle/handle.c b/libhandle/handle.c
> index eb099f4..d3927a3 100644
> --- a/libhandle/handle.c
> +++ b/libhandle/handle.c
> @@ -108,6 +108,7 @@ path_to_fshandle(
>  
>  		fdhp->fsfd = fd;
>  		strncpy(fdhp->fspath, fspath, sizeof(fdhp->fspath));
> +		fdhp->fspath[sizeof(fdhp->fspath) - 1] = '\0';
>  		memcpy(fdhp->fsh, *fshanp, FSIDSIZE);
>  
>  		fdhp->fnxt = fdhash_head;
> 
