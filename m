Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42824 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbdHOXUM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Aug 2017 19:20:12 -0400
Subject: Re: [PATCH 3/6 v2] mkfs: remove intermediate getstr followed by
 getnum
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-2-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b1707a0d-9a59-a058-7242-71df0437faf4@sandeen.net>
Date: Tue, 15 Aug 2017 18:20:11 -0500
MIME-Version: 1.0
In-Reply-To: <20170815150812.32237-2-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 8/15/17 10:08 AM, Jan Tulak wrote:
> Some options loaded a number as a string with getstr and converted it to
> number with getnum later in the code, without any reason for this
> approach.  (They were probably forgotten in some past cleaning.)
> 
> This patch changes them to skip the string and use getnum directly in
> the main option-parsing loop, as do all the other numerical options.
> And as we now have two variables of the same type for the same value,
> merge them together. (e.g. former string dsize and number dbytes).
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> 
> ---
> UPDATE:
> * in getnum: set_conf_raw -> set_conf_raw_safe

Looks fine, though if you take my advice on patch1, it'll
be set_conf_raw_safe -> set_conf_raw again ;)

-Eric

