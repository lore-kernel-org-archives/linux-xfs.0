Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890AFC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Dec 2021 17:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhLERjd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Dec 2021 12:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbhLERjc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Dec 2021 12:39:32 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5616BC061714
        for <linux-xfs@vger.kernel.org>; Sun,  5 Dec 2021 09:36:05 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mtvQh-00060T-6W; Sun, 05 Dec 2021 17:36:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1000974: copy_move_algo.hpp:1083:10: error: =?UTF-8?Q?=E2=80=98=5F=5Ffallthrough=5F=5F=E2=80=99?= was not declared in this scope; did you mean =?UTF-8?Q?=E2=80=98fallthrough=E2=80=99=3F?=
Reply-To: Thomas Goirand <zigo@debian.org>, 1000974@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1000974
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Keywords: 
References: <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch> <9b9bda73-9554-0c75-824d-f8d1b9b98e19@debian.org> <7686ac7e-0df1-a98c-27ce-51dc5e46c55e@debian.org> <c7ccff50-c177-7f96-2d99-2077f77374ad@debian.org> <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1000974-submit@bugs.debian.org id=B1000974.163872562421581
          (code B ref 1000974); Sun, 05 Dec 2021 17:36:02 +0000
Received: (at 1000974) by bugs.debian.org; 5 Dec 2021 17:33:44 +0000
Received: from mx.atlanta.gplhost.com ([103.230.71.13]:54813)
        by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <zigo@debian.org>)
        id 1mtvOS-0005bg-O8
        for 1000974@bugs.debian.org; Sun, 05 Dec 2021 17:33:44 +0000
Received: from mx.atlanta.gplhost.com (localhost.localdomain [127.0.0.1])
        by mx.atlanta.gplhost.com (Postfix) with ESMTP id 2D8873A800F;
        Sun,  5 Dec 2021 17:33:42 +0000 (UTC)
Received: from zbuz.infomaniak.ch (aputeaux-551-1-116-4.w92-132.abo.wanadoo.fr [92.132.227.4])
        by mx.atlanta.gplhost.com (Postfix) with ESMTPA id 87C5B3A8004;
        Sun,  5 Dec 2021 17:33:41 +0000 (UTC)
To:     Giovanni Mascellani <gio@debian.org>, 1000974@bugs.debian.org,
        xfslibs-dev@packages.debian.org
From:   Thomas Goirand <zigo@debian.org>
Organization: Debian
Message-ID: <86067ed6-28c5-2591-b27a-80957166a9a9@debian.org>
Date:   Sun, 5 Dec 2021 18:33:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c7ccff50-c177-7f96-2d99-2077f77374ad@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/5/21 4:50 PM, Giovanni Mascellani wrote:
> reassign 1000974 xfslibs-dev
> severity 1000974 important
> retitle 1000974 xfs/linux.h defines common word "fallthrough" breaking
> unrelated headers
> thanks
> 
> Hi,
> 
> On 04/12/21 23:36, Thomas Goirand wrote:
>> On 12/4/21 5:11 PM, Giovanni Mascellani wrote:
>>> Could you try running that compilation command with g++ -E, so you can
>>> see what BOOST_FALLTHROUGH is actually begin replaced with?
>>
>> Oh, sorry, now I get what you meant (did a c++ --help to understand what
>> -E was doing). Here's the result in
>> CMakeFiles/seastar.dir/src/core/file.cc.o:
>>
>> __attribute__((__attribute__((__fallthrough__))));
>>
>> Probably, there's a mistake, and it should really be:
>>
>> __attribute__((__fallthrough__));
>>
>> instead, which is the source of the trouble?
> 
> It seems that the problem goes this way:
> 
>  * Boost defines in /usr/include/boost/config/compiler/gcc.hpp:
> 
> #define BOOST_FALLTHROUGH __attribute__((fallthrough))
> 
>  * But /usr/include/xfs/linux.h defines:
> 
> #define fallthrough __attribute__((__fallthrough__))
> 
> So the "fallthrough" in Boost's definition is expanded again and causes
> the problem.
> 
> I think xfs/linux.h is at fault here, because it aggressively defines a
> common word (while Boost namespaces all its definitions with a BOOST_
> prefix). Unfortunately the C/C++ preprocessor makes it easy to break
> other headers if you define stuff too liberally. This wold also, for
> example, break any program that use the name "fallthrough" for a
> variable, which is a completely reasonable name to use. A simple example
> could be:
> ---
> #include <xfs/linux.h>
> 
> int main() {
>     int fallthrough = 0;
>     return fallthrough;
> }
> ---
> which fails compilation with:
> ---
> $ LANG=C gcc test.c
> test.c: In function 'main':
> test.c:4:5: warning: 'fallthrough' attribute not followed by ';'
> [-Wattributes]
>     4 |     int fallthrough = 0;
>       |     ^~~
> test.c:4:21: error: expected identifier or '(' before '=' token
>     4 |     int fallthrough = 0;
>       |                     ^
> In file included from test.c:1:
> test.c:5:12: error: expected expression before '__attribute__'
>     5 |     return fallthrough;
>       |            ^~~~~~~~~~~
> ---
> 
> You can probably work around this problem by undefining "fallthrough"
> just after the xfs/linux.h header. In the meantime I am reassigning this
> bug to xfslibs-dev.
> 
> Giovanni.


Hi,

I can confirm that commenting away line 373 to 381 of xfs/linux.h solve
the troubles when building Ceph. Downgrading to 5.13.0-1 (using
snapshot.d.o) also solved the trouble, showing that 5.14.0 really is the
trouble here.

Thanks Giovanni for finding this out.

Cheers,

Thomas Goirand (zigo)
