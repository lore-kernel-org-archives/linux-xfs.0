Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C289C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 19:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3414A61AE0
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 19:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhJAT7W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Oct 2021 15:59:22 -0400
Received: from sandeen.net ([63.231.237.45]:51392 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231246AbhJAT7V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Oct 2021 15:59:21 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0ADA014A18;
        Fri,  1 Oct 2021 14:56:56 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174722755.350433.4462645030660733660.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 06/61] xfs: Fix fall-through warnings for Clang
Message-ID: <563b2dfb-17ba-6734-0018-39f37a734a84@sandeen.net>
Date:   Fri, 1 Oct 2021 14:57:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163174722755.350433.4462645030660733660.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/15/21 6:07 PM, Darrick J. Wong wrote:

I'd like to wrap this in

#ifdef __has_attribute

(with another else to define it away) so we don't have any gcc version surprises.
Ok?  (yes, yes, old gcc yuck but would rather not break it if we don't have to)

#if defined __has_attribute
#  if __has_attribute(__fallthrough__)
#    define fallthrough                    __attribute__((__fallthrough__))
#  else
#    define fallthrough                    do {} while (0)  /* fallthrough */
#  endif
#else
#    define fallthrough                    do {} while (0)  /* fallthrough */
#endif

Unless there's objection I'll do that before I merge it.

(note, can't do #if defined __has_attribute && __has_attribute(), as shown at
https://gcc.gnu.org/onlinedocs/cpp/_005f_005fhas_005fattribute.html)

Thanks,
-Eric

> +#if __has_attribute(__fallthrough__)
> +# define fallthrough                    __attribute__((__fallthrough__))
> +#else
> +# define fallthrough                    do {} while (0)  /* fallthrough */
> +#endif
