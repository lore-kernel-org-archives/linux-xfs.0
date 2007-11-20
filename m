Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Nov 2007 06:51:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAKEpbpo031360
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2007 06:51:41 -0800
Message-ID: <4742F47E.9090909@sandeen.net>
Date: Tue, 20 Nov 2007 08:51:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS:  Replace deprecated "TOPDIR" with newer "src"
References: <alpine.LFD.0.9999.0711200431590.21514@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711200431590.21514@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: xfs@oss.sgi.com

Robert P. J. Day wrote:
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   given that TOPDIR is explicitly deprecated in favour of src, this
> would seem to be an obvious change.
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 49e3e7e..e1b08b7 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -1 +1 @@
> -include $(TOPDIR)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
> +include $(src)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)

There are already a couple changes in cvs which obsolete this:

http://oss.sgi.com/archives/xfs/2007-07/msg00295.html
and
http://oss.sgi.com/archives/xfs/2007-09/msg00361.html

Thanks,
-Eric
