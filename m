Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33854 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752726AbdGLU4G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 16:56:06 -0400
Subject: Re: [PATCH] xfsdump: fix race condition between lseek() and
 read()/write()
References: <1461244016-7373-1-git-send-email-eguan@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a63c9311-8b97-ad31-63cb-35bdea02b6a3@sandeen.net>
Date: Wed, 12 Jul 2017 15:56:00 -0500
MIME-Version: 1.0
In-Reply-To: <1461244016-7373-1-git-send-email-eguan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

Hm, but isn't this a problem?

On 04/21/2016 08:06 AM, Eryu Guan wrote:
> diff --git a/inventory/inv_core.c b/inventory/inv_core.c
> index a17c2c9..42d0ac4 100644
> --- a/inventory/inv_core.c
> +++ b/inventory/inv_core.c
> @@ -121,19 +121,10 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
>  	if ( dolock ) 
>  		INVLOCK( fd, LOCK_SH );
>  
> -	if ( lseek( fd, (off_t)off, whence ) < 0 ) {

whence can be _SET or _CUR depending on the caller, but with this
patch whence is no longer used, and -

> -		INV_PERROR( _("Error in reading inventory record "
> -			      "(lseek failed): ") );
> -		if ( dolock ) 
> -			INVLOCK( fd, LOCK_UN );
> -		return -1;
> -	}
> -	
> -	nread = read( fd, buf, bufsz );
> -
> +	nread = pread(fd, buf, bufsz, (off_t)off);

This is only equivalent to SET, no?  With the other changes, perhaps we're
no longer called via GET_REC_SEEKCUR - but in that case, the whence arg should
be removed?  Except for that pesky test code which explicitly passes SEEK_CUR ...


-Eric

>  	if (  nread != (int) bufsz ) {
>  		INV_PERROR( _("Error in reading inventory record :") );
> -		if ( dolock ) 
> +		if ( dolock )
>  			INVLOCK( fd, LOCK_UN );
>  		return -1;
>  	}
