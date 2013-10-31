Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29B947F5D
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 07:13:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB87CAC003
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 05:13:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jONdykYMMTOAiBSl for
	<xfs@oss.sgi.com>; Thu, 31 Oct 2013 05:13:26 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9VCDQ8c021663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:13:26 -0400
Received: from orion.maiolino.org (ovpn-113-27.phx2.redhat.com [10.3.113.27])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id r9VCDMQQ007558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:13:25 -0400
Date: Thu, 31 Oct 2013 10:13:21 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests: fix mkfs filter on xfs/096
Message-ID: <20131031121321.GC14337@orion.maiolino.org>
References: <1383105535-28686-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383105535-28686-1-git-send-email-david@fromorbit.com>
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

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
On Wed, Oct 30, 2013 at 02:58:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Needs to filter out the new ftype field.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  tests/xfs/096 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/096 b/tests/xfs/096
> index 44b19b0..b2719bc 100755
> --- a/tests/xfs/096
> +++ b/tests/xfs/096
> @@ -87,6 +87,7 @@ _mkfs_filter()
>  	-e 's/\(realtime[ 	]*=\).*extsz/\1REALTIME               extsz/' \
>  	-e '/.*crc=/d' \
>  	-e 's/ *$//' \
> +	-e 's/ ftype=[01]//' \
>     | grep -v parent
>  }
>  
> -- 
> 1.8.4.rc3
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
