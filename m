Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B736DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 23:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhKSXOL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 18:14:11 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:57392 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234188AbhKSXOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 18:14:10 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 2CFD2110636;
        Sat, 20 Nov 2021 10:11:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1moD29-00AsC4-GK; Sat, 20 Nov 2021 10:11:05 +1100
Date:   Sat, 20 Nov 2021 10:11:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Bastian Germann <bage@debian.org>
Cc:     linux-xfs@vger.kernel.org, Helmut Grohne <helmut@subdivi.de>
Subject: Re: [PATCH 2/2] debian: Fix FTCBFS: Skip crc32 test (Closes: #999879)
Message-ID: <20211119231105.GA449541@dread.disaster.area>
References: <20211119171241.102173-1-bage@debian.org>
 <20211119171241.102173-3-bage@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119171241.102173-3-bage@debian.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61982f0b
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=xNf9USuDAAAA:8 a=7-415B0cAAAA:8
        a=hOIuo8Pf0Pv82YjTfwsA:9 a=CjuIK1q_8ugA:10 a=SEwjQc04WA-l_NiBhQ7s:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 19, 2021 at 06:12:41PM +0100, Bastian Germann wrote:
> xfsprogs fails to cross build from source, because it attempts to build
> its crc32 test with the build architecture compiler and thus fails
> finding the liburcu, which is only requested for the host architecture.
> While this test is useful for native builds, it is not that useful for
> cross builds. Skip it by pre-creating the output file.

I don't get it. The crcselftest does not use liburcu in
any way, nor does it try to link against liburcu, so it should not
fail because other parts of xfsprogs use liburcu.

What's the build error that occurs?

> Reported-by: Helmut Grohne <helmut@subdivi.de>
> Signed-off-by: Bastian Germann <bage@debian.org>
> ---
>  debian/rules | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/debian/rules b/debian/rules
> index 6d5b82a8..28cc414d 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -40,6 +40,9 @@ build-arch: built
>  build-indep: built
>  built: dibuild config
>  	@echo "== dpkg-buildpackage: build" 1>&2
> +ifneq ($(DEB_BUILD_ARCH),$(DEB_HOST_ARCH))
> +	touch --date=+3day libfrog/crc32selftest
> +endif
>  	$(MAKE) $(PMAKEFLAGS) default
>  	touch built

We need to fix the generic cross-build problem in the xfsprogs code,
not slap a distro-specific build band-aid over it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
