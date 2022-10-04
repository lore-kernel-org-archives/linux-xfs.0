Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DF4C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 18:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJDSe2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJDSe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 14:34:26 -0400
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4790C66119
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 11:34:25 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7cb4.dip0.t-ipconnect.de [93.221.124.180])
        by mail.itouring.de (Postfix) with ESMTPSA id D0139103762;
        Tue,  4 Oct 2022 20:34:23 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 8B192F01606;
        Tue,  4 Oct 2022 20:34:23 +0200 (CEST)
Subject: Re: [PATCH] xfsprogs: fix warnings/errors due to missing include
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <865733c7-8314-cd13-f363-5ba2c6842372@applied-asynchrony.com>
 <Yzx7RrC1v2LQ6wSf@magnolia>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <e1df04bf-866d-1dc8-9653-7612cce96fe0@applied-asynchrony.com>
Date:   Tue, 4 Oct 2022 20:34:23 +0200
MIME-Version: 1.0
In-Reply-To: <Yzx7RrC1v2LQ6wSf@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022-10-04 20:28, Darrick J. Wong wrote:
> On Tue, Oct 04, 2022 at 08:11:05PM +0200, Holger Hoffstätte wrote:
>>
>> Gentoo is currently trying to rebuild the world with clang-16, uncovering exciting
>> new errors in many packages since several warnings have been turned into errors,
>> among them missing prototypes, as documented at:
>> https://discourse.llvm.org/t/clang-16-notice-of-potentially-breaking-changes/65562
>>
>> xfsprogs came up, with details at https://bugs.gentoo.org/875050.
>>
>> The problem was easy to find: a missing include for the u_init/u_cleanup
>> prototypes. The error:
>>
>> Building scrub
>>      [CC]     unicrash.o
>> unicrash.c:746:2: error: call to undeclared function 'u_init'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>>          u_init(&uerr);
>>          ^
>> unicrash.c:746:2: note: did you mean 'u_digit'?
>> /usr/include/unicode/uchar.h:4073:1: note: 'u_digit' declared here
>> u_digit(UChar32 ch, int8_t radix);
>> ^
>> unicrash.c:754:2: error: call to undeclared function 'u_cleanup'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>>          u_cleanup();
>>          ^
>> 2 errors generated.
>>
>> The complaint is valid and the fix is easy enough: just add the missing include.
>>
>> Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> 
> Aha, that explains why I kept hearing reports about this but could never
> get gcc to spit out this error.  Thanks for fixing this.

You're welcome. This reproduces with gcc when explicitly enabled:

$CFLAGS="-Werror=implicit-function-declaration -Werror=implicit-int" ./configure

cheers,
Holger
