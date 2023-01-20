Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AB6C25B4E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Jan 2023 14:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjATORc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Jan 2023 09:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjATORb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2023 09:17:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7C7CB52F
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 06:16:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85C3861F87
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 14:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5231DC433EF;
        Fri, 20 Jan 2023 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674224149;
        bh=C4XXWdrQM70M0Xs4vPgrYfbhlgqJeB8ueJgObJR4W/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C5KYAl6QBDjNPt7/Kx3H6Fb3eSLMsq2MeSQeYxmhwsJjHD5HN5EyDXTKzMuXJfFG5
         zzBkxkS4iSVHPpBQoHW8WIjFSHkQpGap/4+xNZlo2SdZn1sVZZvMxYD1RCkpmHVhHs
         UhgUVpDflU64yFyJi3Q+bmz409O1hUCbf3fepM/Hs1fJKEpTYRRRJY+6Y1a4nU6PZy
         upQZkhVSbb3AKbhzKVTmqigK5sRGBnzLZ344eKrqhXtiG1SaGAyrI5xAA2cThjhz3o
         b5fPQVtKHvxPQXyWXVGNFsjEBFDoN5AuikhXFjN7Y8fIeKbJzEt0vcek07Qy6mNGDm
         Vexujwyou9q1Q==
Date:   Fri, 20 Jan 2023 15:15:45 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] progs: autoconf fails during debian package builds
Message-ID: <20230120141545.em3nehpjhqqsk3bd@andromeda>
References: <20230119233906.2055062-1-david@fromorbit.com>
 <LVD7WtY1GVYX0dwRvdlzsiMpldYgxpHaiXJFOgsB7aR-E4DbzG7ixxuDRx_mkMZM1FWaqhuYRNnBG5K2dvCo4Q==@protonmail.internalid>
 <20230119233906.2055062-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119233906.2055062-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 20, 2023 at 10:39:05AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For some reason, a current debian testing build system will fail to
> build debian packages because the build environment is not correctly
> detecting that libtoolize needs the "-i" parameter to copy in the
> files needed by autoconf.
> 
> My build scripts run "make -j 16 realclean; make -j 16 deb", and the
> second step is failing immediately with:
> 
> libtoolize -c `libtoolize -n -i >/dev/null 2>/dev/null && echo -i` -f
> libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, '.'.
> libtoolize: copying file './ltmain.sh'
> libtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'm4'.
> libtoolize: copying file 'm4/libtool.m4'
> libtoolize: copying file 'm4/ltoptions.m4'
> libtoolize: copying file 'm4/ltsugar.m4'
> libtoolize: copying file 'm4/ltversion.m4'
> libtoolize: copying file 'm4/lt~obsolete.m4'
> libtoolize: Consider adding '-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
> cp include/install-sh .
> aclocal -I m4
> autoconf
> ./configure $LOCAL_CONFIGURE_OPTIONS
> configure: error: cannot find required auxiliary files: config.guess config.sub
> make: *** [Makefile:131: include/builddefs] Error 1
> 
> If I run 'make realclean; make deb' from the command line, the
> package build runs to completion.  I have not been able to work out
> why the initial build fails, but then succeeds after a 'make
> realclean' has been run, and I don't feel like spending hours
> running down this rabbit hole.
> 
> This conditional "-i" flag detection was added back in *2009* when
> default libtoolize behaviour was changed to not copy the config
> files into the build area, and the "-i" flag was added to provide
> that behaviour. It is detecting that the "-i" flag is needed that is
> now failing, but it is most definitely still needed.
> 
> Rather than ispending lots of time trying to understand this and
> then making the detection more complex, just use the "-i" flag
> unconditionally and require any userspace that this now breaks on to
> upgrade their 15+ year old version of libtoolize something a little
> more modern.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems fair enough.
It's still working on debian 11 stable, I'm curious to understand what breaks
the detection of -i argument for libtoolize, I'm gonna give it a try on testing.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  Makefile | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 0edc2700933d..c8455a9e665f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -115,14 +115,8 @@ else
>  clean:	# if configure hasn't run, nothing to clean
>  endif
> 
> -
> -# Recent versions of libtool require the -i option for copying auxiliary
> -# files (config.sub, config.guess, install-sh, ltmain.sh), while older
> -# versions will copy those files anyway, and don't understand -i.
> -LIBTOOLIZE_INSTALL = `$(LIBTOOLIZE_BIN) -n -i >/dev/null 2>/dev/null && echo -i`
> -
>  configure: configure.ac
> -	$(LIBTOOLIZE_BIN) -c $(LIBTOOLIZE_INSTALL) -f
> +	$(LIBTOOLIZE_BIN) -c -i -f
>  	cp include/install-sh .
>  	aclocal -I m4
>  	autoconf
> --
> 2.39.0
> 

-- 
Carlos Maiolino
