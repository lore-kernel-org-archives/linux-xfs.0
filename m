Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34706 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbeHBLR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 07:17:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id c13-v6so1408958wrt.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Aug 2018 02:27:09 -0700 (PDT)
Date: Thu, 2 Aug 2018 11:27:06 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] misc: add handy tarball targets
Message-ID: <20180802092706.o63gjctw26i4jzjt@odin.usersys.redhat.com>
References: <89353d1e-b141-e8e6-e039-fb8340a45df0@redhat.com>
 <3aeaf299-136f-b6ea-bde8-63086bdedf92@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aeaf299-136f-b6ea-bde8-63086bdedf92@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 01, 2018 at 04:37:01PM -0500, Eric Sandeen wrote:
> It's a pain to need to know which version we're on to be able
> to create a tarball, just make a couple of simple "tarball"
> and "tarxz" targets that just DTRT and make a tarball with the
> current version.

I believe the V2 description should also be updated to - simple "targz" and
"tarxz" - ?  :)

After fixing the description:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: give Darrick names he likes ;) and mark these and a bunch of other
> targets as .PHONY
> 
> diff --git a/Makefile b/Makefile
> index 6774825..ad35114 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -178,6 +178,11 @@ $(SRCTARXZ) : default $(SRCTARINC) .gitcensus
>  	   `cat .gitcensus` $(SRCTARINC)
>  	echo Wrote: $@
>  
> +targz: $(SRCTAR)
> +tarxz: $(SRCTARXZ)
> +
> +.PHONY: install install-dev dist clean distclean realclean targz tarxz
> +
>  .gitcensus: $(_FORCE)
>  	$(Q)if test -d .git; then \
>  	  git ls-files > .gitcensus && echo "new .gitcensus"; \
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
