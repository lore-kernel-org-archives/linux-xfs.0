Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0974C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 18:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJDSyN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJDSyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 14:54:11 -0400
X-Greylist: delayed 2582 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 11:54:10 PDT
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751335FAFC
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 11:54:09 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7cb4.dip0.t-ipconnect.de [93.221.124.180])
        by mail.itouring.de (Postfix) with ESMTPSA id 6E72B103762;
        Tue,  4 Oct 2022 20:54:08 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 2DF9AF01606;
        Tue,  4 Oct 2022 20:54:08 +0200 (CEST)
Subject: Re: [PATCH] xfsprogs: fix warnings/errors due to missing include
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <865733c7-8314-cd13-f363-5ba2c6842372@applied-asynchrony.com>
 <Yzx7RrC1v2LQ6wSf@magnolia>
 <e1df04bf-866d-1dc8-9653-7612cce96fe0@applied-asynchrony.com>
 <Yzx+Omrqs3Q16O57@magnolia>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <1665bde4-d582-3fcf-8cf2-62cbf877a08d@applied-asynchrony.com>
Date:   Tue, 4 Oct 2022 20:54:08 +0200
MIME-Version: 1.0
In-Reply-To: <Yzx+Omrqs3Q16O57@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022-10-04 20:40, Darrick J. Wong wrote:
> On Tue, Oct 04, 2022 at 08:34:23PM +0200, Holger Hoffstätte wrote:
>> On 2022-10-04 20:28, Darrick J. Wong wrote:
>>> On Tue, Oct 04, 2022 at 08:11:05PM +0200, Holger Hoffstätte wrote:
>>>>
>>>> Gentoo is currently trying to rebuild the world with clang-16, uncovering exciting
>>>> new errors in many packages since several warnings have been turned into errors,
>>>> among them missing prototypes, as documented at:
>>>> https://discourse.llvm.org/t/clang-16-notice-of-potentially-breaking-changes/65562
>>>>
>>>> xfsprogs came up, with details at https://bugs.gentoo.org/875050.
>>>>
>>>> The problem was easy to find: a missing include for the u_init/u_cleanup
>>>> prototypes. The error:
>>>>
>>>> Building scrub
>>>>       [CC]     unicrash.o
>>>> unicrash.c:746:2: error: call to undeclared function 'u_init'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>>>>           u_init(&uerr);
>>>>           ^
>>>> unicrash.c:746:2: note: did you mean 'u_digit'?
>>>> /usr/include/unicode/uchar.h:4073:1: note: 'u_digit' declared here
>>>> u_digit(UChar32 ch, int8_t radix);
>>>> ^
>>>> unicrash.c:754:2: error: call to undeclared function 'u_cleanup'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
>>>>           u_cleanup();
>>>>           ^
>>>> 2 errors generated.
>>>>
>>>> The complaint is valid and the fix is easy enough: just add the missing include.
>>>>
>>>> Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>>>
>>> Aha, that explains why I kept hearing reports about this but could never
>>> get gcc to spit out this error.  Thanks for fixing this.
>>
>> You're welcome. This reproduces with gcc when explicitly enabled:
>>
>> $CFLAGS="-Werror=implicit-function-declaration -Werror=implicit-int" ./configure
> 
> Huh.  I don't know why my system won't complain.
> 
> $ gcc --version
> gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0
> Copyright (C) 2021 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is
> NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
> PURPOSE.
> 
> $ gcc -Wall -g -O3 -fstack-protector --param=ssp-buffer-size=4
> -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3 -D_FILE_OFFSET_BITS=64
> -Wno-address-of-packed-member -femit-struct-debug-detailed=any
> -Wno-error=unused-but-set-variable -Wuninitialized -Wno-pointer-sign
> -Wall -Wextra -Wno-unused-parameter -fstack-usage -Werror
> -Wno-sign-compare -Wno-missing-field-initializers -Wmaybe-uninitialized
> -Wno-error=unused-function -Wno-error=unused-variable
> -Wno-error=maybe-uninitialized -Werror=implicit-function-declaration
> -Werror=implicit-int   -g -O2 -DDEBUG
> -DVERSION=\"6.1.0-rc0~WIP-2022-10-03\" -DLOCALEDIR=\"/usr/share/locale\"
> -DPACKAGE=\"xfsprogs\" -I../include -I../libxfs -I.. -D_LGPL_SOURCE
> -D_GNU_SOURCE -funsigned-char -fno-strict-aliasing -Wall -Werror -Wextra
> -Wno-unused-parameter -DHAVE_MNTENT -DHAVE_FSETXATTR -DENABLE_BLKID
> -DHAVE_GETFSMAP -DHAVE_GETFSREFCOUNTS -DHAVE_FALLOCATE
> -DHAVE_LIBURCU_ATOMIC64 -DHAVE_MALLINFO -DHAVE_MALLINFO2 -DHAVE_SYNCFS
> -DHAVE_LIBATTR -DHAVE_LIBICU  -DHAVE_SG_IO -DHAVE_HDIO_GETGEO -c
> unicrash.c
> $

holger>gcc --version
gcc (Gentoo 12.2.0 p1) 12.2.0
..
holger>cd /tmp
holger>tar xf /var/cache/distfiles/xfsprogs-5.18.0.tar.xz
holger>cd xfsprogs-5.18.0
holger>CFLAGS="-pipe -O2 -Werror=implicit-function-declaration -Werror=implicit-int" ./configure && make -j8
...
     [CC]     unicrash.o
unicrash.c: In function 'unicrash_load':
unicrash.c:746:9: error: implicit declaration of function 'u_init'; did you mean 'u_digit'? [-Werror=implicit-function-declaration]
   746 |         u_init(&uerr);
       |         ^~~~~~
       |         u_digit
unicrash.c: In function 'unicrash_unload':
unicrash.c:754:9: error: implicit declaration of function 'u_cleanup'; did you mean 'scrub_cleanup'? [-Werror=implicit-function-declaration]
   754 |         u_cleanup();
       |         ^~~~~~~~~
       |         scrub_cleanup
     [CC]     link.o
     [CC]     mmap.o
     [SED]    xfs_scrub_all
     [CC]     open.o
     [SED]    xfs_scrub_all.cron
     [CC]     parent.o
cc1: some warnings being treated as errors

Alternatively add CC=clang to the configure line and check out the other
nice warnings as well. :)

cheers
Holger
