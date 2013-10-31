Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C00677F56
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 07:13:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE400304071
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 05:13:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HHpBReTKrHnXZFk1 for
	<xfs@oss.sgi.com>; Thu, 31 Oct 2013 05:13:00 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9VCCxkW018004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:12:59 -0400
Received: from orion.maiolino.org (ovpn-113-27.phx2.redhat.com [10.3.113.27])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id r9VCCtUm002643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:12:58 -0400
Date: Thu, 31 Oct 2013 10:12:54 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests: fix compile error of src/fssum.c on bigendian
	host
Message-ID: <20131031121254.GB14337@orion.maiolino.org>
References: <1383105343-15348-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383105343-15348-1-git-send-email-eguan@redhat.com>
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
On Wed, Oct 30, 2013 at 11:55:43AM +0800, Eryu Guan wrote:
> Definition of htonll() is needed on bigendian host too, otherwise
> src/fssum.c won't compile on ppc64/s390x hosts.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  src/fssum.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/fssum.c b/src/fssum.c
> index c75ff8b..c26d32b 100644
> --- a/src/fssum.c
> +++ b/src/fssum.c
> @@ -50,6 +50,8 @@
>  
>  #if __BYTE_ORDER == __LITTLE_ENDIAN
>  #define htonll(x)     __bswap_64 (x)
> +#else
> +#define htonll(x)     (x)
>  #endif
>  #endif
>  
> -- 
> 1.8.3.1
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
