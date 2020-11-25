Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06058C56201
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 21:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B285C206F9
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 21:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgKYVHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:07:20 -0500
Received: from sandeen.net ([63.231.237.45]:36488 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgKYVHU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Nov 2020 16:07:20 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id EB9BA324E60;
        Wed, 25 Nov 2020 15:07:12 -0600 (CST)
Subject: Re: [PATCH 5/5] debian: add build dependency on libinih-dev
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160633667604.634603.7657982642827987317.stgit@magnolia>
 <160633670660.634603.13629119948503534425.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b137ab8e-bc41-0221-3b11-4453382f425d@sandeen.net>
Date:   Wed, 25 Nov 2020 15:07:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <160633670660.634603.13629119948503534425.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/25/20 2:38 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> mkfs now supports configuration files, which are parsed using libinih.
> Add this dependency to the debian build.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I don't speak Debian very well but this looks fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  debian/control |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/debian/control b/debian/control
> index ddd17850e378..49ffd3409dc0 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -3,7 +3,7 @@ Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
>  Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
> -Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
> +Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
>  
> 
