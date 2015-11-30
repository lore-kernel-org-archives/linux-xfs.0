Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 592C97F37
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 07:25:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48E908F8035
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 05:25:40 -0800 (PST)
Received: from mailapp01.imgtec.com (mailapp01.imgtec.com [195.59.15.196]) by
	cuda.sgi.com with ESMTP id ZzJkRj2sxlx7FkjA for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 05:25:37 -0800 (PST)
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Websense Email Security Gateway with ESMTPS id 7F1904579DFE0
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 13:25:34 +0000 (GMT)
Subject: Re: [PATCH xfsprogs] mdrestore: do not do dynamic linking of libtool
	libraries
References: <1448449838-47261-1-git-send-email-Vincent.Riera@imgtec.com>
From: Vicente Olivert Riera <Vincent.Riera@imgtec.com>
Message-ID: <565C4E4F.4060303@imgtec.com>
Date: Mon, 30 Nov 2015 13:25:35 +0000
MIME-Version: 1.0
In-Reply-To: <1448449838-47261-1-git-send-email-Vincent.Riera@imgtec.com>
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

ping

On 25/11/15 11:10, Vicente Olivert Riera wrote:
> As explained in commit ece49daeff1a3cad765e106d678c608925c9d768, use
> -static-libtool-libs instead of -static to allow fallback to the dynamic
> linking for libuuid only. Otherwise the build will fail like this:
> 
> ld: attempted static link of dynamic object `/usr/lib/libuuid.so'
> 
> Signed-off-by: Vicente Olivert Riera <Vincent.Riera@imgtec.com>
> ---
>  mdrestore/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mdrestore/Makefile b/mdrestore/Makefile
> index 5171306..1b34a0e 100644
> --- a/mdrestore/Makefile
> +++ b/mdrestore/Makefile
> @@ -10,7 +10,7 @@ CFILES = xfs_mdrestore.c
>  
>  LLDLIBS = $(LIBXFS) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
>  LTDEPENDENCIES = $(LIBXFS)
> -LLDFLAGS = -static
> +LLDFLAGS = -static-libtool-libs
>  
>  default: depend $(LTCOMMAND)
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
