Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3DEC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CC164F01
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Feb 2021 04:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBUEMY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 23:12:24 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:54773 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229996AbhBUEMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 23:12:23 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 262711AD999;
        Sun, 21 Feb 2021 15:11:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lDg5r-00EZIt-Op; Sun, 21 Feb 2021 15:11:39 +1100
Date:   Sun, 21 Feb 2021 15:11:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org,
        Steve Langasek <steve.langasek@ubuntu.com>
Subject: Re: [PATCH 3/4] debian: Regenerate config.guess using debhelper
Message-ID: <20210221041139.GL4662@dread.disaster.area>
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-4-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220121610.3982-4-bastiangermann@fishpost.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=fxJcL_dCAAAA:8 a=7-415B0cAAAA:8
        a=CeK0mnQAh5vRBkEZaqMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 20, 2021 at 01:16:08PM +0100, Bastian Germann wrote:
> This is a change introduced in 5.10.0-2ubuntu2 with the changelog:
> 
> > xfsprogs upstream has regressed config.guess, so use
> > dh_update_autotools_config.

What regression?

The xfsprogs build generates config.guess with the libtool
infrastructure installed on the build machine. So I'm not sure
how/what we've regressed here, because AFAIK we haven't changed
anything here recently...

> Reported-by: Steve Langasek <steve.langasek@ubuntu.com>
> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
> ---
>  debian/changelog | 3 +++
>  debian/rules     | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/debian/changelog b/debian/changelog
> index c77f04ab..6cc9926b 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -4,6 +4,9 @@ xfsprogs (5.11.0-rc0-1) experimental; urgency=medium
>    * Drop trying to create upstream distribution
>    * Enable CET on amd64
>  
> +  [ Steve Langasek ]
> +  * Regenerate config.guess using debhelper
> +
>   -- Bastian Germann <bastiangermann@fishpost.de>  Sat, 20 Feb 2021 11:57:31 +0100
>  
>  xfsprogs (5.10.0-3) unstable; urgency=medium
> diff --git a/debian/rules b/debian/rules
> index dd093f2c..1913ccb6 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -49,6 +49,7 @@ config: .census
>  	@echo "== dpkg-buildpackage: configure" 1>&2
>  	$(checkdir)
>  	AUTOHEADER=/bin/true dh_autoreconf
> +	dh_update_autotools_config
>  	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h

Why would running at tool that does a search-n-replace of built
config.guess files do anything when run before the build runs
libtoolize to copy in the config.guess file it uses? I'm a bit
confused by this...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
