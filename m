Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C17EE7F8B
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 09:17:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B7D5AC003
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 07:17:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZabUkDVC298XNtQw for
	<xfs@oss.sgi.com>; Thu, 10 Oct 2013 07:17:15 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9AEHEds019638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:17:15 -0400
Received: from orion.maiolino.org (ovpn-113-149.phx2.redhat.com [10.3.113.149])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r9AEHBTB032386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 10:17:14 -0400
Date: Thu, 10 Oct 2013 11:17:11 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfsdump: avoid segfault in partial_reg() in error case
Message-ID: <20131010141710.GB2052@orion.maiolino.org>
References: <525480A6.3000202@redhat.com>
 <525481C2.6040100@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525481C2.6040100@sandeen.net>
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
To: xfs@oss.sgi.com

Looks good to me

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Tue, Oct 08, 2013 at 05:05:54PM -0500, Eric Sandeen wrote:
> If we go down the "/* Should never get here. */" path
> in partial_reg(), we issue a warning but then continue
> with the function.  This calls pi_unlock() twice,
> but worse, uses a null isptr:
> 
>         if ( ! isptr ) {
> ... isptr is never set if we get to ...
>                 /* Should never get here. */
>                 pi_unlock();
> ...
>         }
> ...
>         /* Update this drive's entry */
>         bsptr = &isptr->is_bs[d_index];
>         if (bsptr->endoffset == 0) {
> 
> From all appearances, because we unlock on that "never get
> here" path, it should just be returning after printing the
> warning.  So add that, and we avoid the segfault.
> 
> The previous fix to partial_reg() should prevent us from
> hitting this in the first place.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/restore/content.c b/restore/content.c
> index 54d933c..cc49336 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -9007,6 +9007,7 @@ partial_reg( ix_t d_index,
>  #ifdef DEBUGPARTIALS
>  		dump_partials();
>  #endif
> +		return;
>  	}
>  
>  found:
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
