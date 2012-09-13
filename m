Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DFTEiR175451 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 10:29:14 -0500
Message-ID: <5051FBFF.5080507@sgi.com>
Date: Thu, 13 Sep 2012 10:30:07 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] libxcmd: link against readline
References: <1345936050-15139-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1345936050-15139-1-git-send-email-vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs@oss.sgi.com

On 08/25/12 18:07, Mike Frysinger wrote:
> This library uses readline funcs (the input.c file), so we need to link
> this shared library against it.
>
> URL: https://bugs.gentoo.org/432644
> Reported-by: David Badia<dbadia@gmail.com>
> Signed-off-by: Mike Frysinger<vapier@gentoo.org>
> ---
>   libxcmd/Makefile |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/libxcmd/Makefile b/libxcmd/Makefile
> index b3544f4..ce082a5 100644
> --- a/libxcmd/Makefile
> +++ b/libxcmd/Makefile
> @@ -22,10 +22,12 @@ endif
>
>   ifeq ($(ENABLE_READLINE),yes)
>   LCFLAGS += -DENABLE_READLINE
> +LTLIBS += $(LIBREADLINE) $(LIBTERMCAP)
>   endif
>
>   ifeq ($(ENABLE_EDITLINE),yes)
>   LCFLAGS += -DENABLE_EDITLINE
> +LTLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
>   endif
>
>   default: ltdepend $(LTLIBRARY)

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
