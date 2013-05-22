Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C4E917CBF
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 16:22:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A28378F804B
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 14:22:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FSQ23AFBdZknqeQm for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 14:22:31 -0700 (PDT)
Message-ID: <519D3716.8080502@sandeen.net>
Date: Wed, 22 May 2013 16:22:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: libhandle/Makefile - fix make install
References: <20130522205819.586978467@gulag1.americas.sgi.com>
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

On 5/22/13 3:58 PM, rjohnston@sgi.com wrote:
> In the default section of libhandle/Makefile, ltdepend prevented
> libhandle.so from being installed properly so remove it.

Can you explain how it prevented it?

[sandeen@sandeen xfsprogs]$ grep ltdepend */Makefile
libdisk/Makefile:default: ltdepend $(LTLIBRARY)
libhandle/Makefile:default: ltdepend $(LTLIBRARY)
libxcmd/Makefile:default: ltdepend $(LTLIBRARY)
libxfs/Makefile:default: crc32selftest ltdepend $(LTLIBRARY)
libxlog/Makefile:default: ltdepend $(LTLIBRARY)

seems to exist in every subdir, why is this one causing trouble?

/me goes off to dig around in makefiles


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
>  
>  include $(BUILDRULES)
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
