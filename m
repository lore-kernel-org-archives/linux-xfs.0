Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63884C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0432220F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgLCUUl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:20:41 -0500
Received: from sandeen.net ([63.231.237.45]:52170 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgLCUUk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Dec 2020 15:20:40 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7295B7906;
        Thu,  3 Dec 2020 14:19:41 -0600 (CST)
To:     Dan Melnic <dmm@fb.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Omar Sandoval <osandov@osandov.com>
References: <B8D4A2D8-01A0-40D6-AB89-887BD0B1F4B4@fb.com>
 <20201203193507.GI106272@magnolia>
 <864CA3B9-B24E-4DB6-B87D-763E25DFF2FF@fb.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: xfsprogs and libintl
Message-ID: <d3abd8ca-735d-d7d7-6229-e7540325cd84@sandeen.net>
Date:   Thu, 3 Dec 2020 14:19:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <864CA3B9-B24E-4DB6-B87D-763E25DFF2FF@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/3/20 2:05 PM, Dan Melnic wrote:
> I guess this is an older version - 3.1.4:

That's ... 10 years old!

platform_defs.h has not been installed on the system since
2015 or so:

,commit dcabd4e7e955231a6bb92ce1038e62e5a9b90c5d
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Aug 3 09:58:33 2015 +1000

    xfsprogs: don't install platform_defs.h

> xfs.h includes platform_defs.h:
> #ifndef __XFS_H__
> #define __XFS_H__
> 
> #include <xfs/platform_defs.h>
> #include <xfs/xfs_fs.h>
> 
> #endif  /* __XFS_H__ */
> 
> Which:
> 
> /* Define if you want gettext (I18N) support */
> /* #undef ENABLE_GETTEXT */
> #ifdef ENABLE_GETTEXT
> # include <libintl.h>
> # define _(x)                   gettext(x)
> # define N_(x)                   x
> #else
> # define _(x)                   (x)
> # define N_(x)                   x
> # define textdomain(d)          do { } while (0)
> # define bindtextdomain(d,dir)  do { } while (0)
> #endif
> #include <locale.h>
> 
> I'll try to upgrade to a newer version then.

I think that is wise :)

-Eric

> Dan


