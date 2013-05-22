Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8A8D7CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 17:16:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A99048F804C
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 15:16:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Pdn294l6RapHlt88 for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 15:16:27 -0700 (PDT)
Date: Thu, 23 May 2013 08:16:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: libhandle/Makefile - fix make install
Message-ID: <20130522221602.GW24543@dastard>
References: <20130522205819.586978467@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522205819.586978467@gulag1.americas.sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On Wed, May 22, 2013 at 03:58:19PM -0500, rjohnston@sgi.com wrote:
> In the default section of libhandle/Makefile, ltdepend prevented
> libhandle.so from being installed properly so remove it.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> --
> diff --git a/libhandle/Makefile b/libhandle/Makefile
> index 865ca22..2f39173 100644
> --- a/libhandle/Makefile
> +++ b/libhandle/Makefile
> @@ -15,7 +15,7 @@ LTLDFLAGS += -Wl,--version-script,libhandle.sym
>  CFILES = handle.c jdm.c
>  LSRCFILES = libhandle.sym
>  
> -default: ltdepend $(LTLIBRARY)
> +default: $(LTLIBRARY)

PLease explain how removing the makefile build dependency generation
fixes a library install problem. This, AFAICT, will just break
rebuild detection of the library when we modify srouce files.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
