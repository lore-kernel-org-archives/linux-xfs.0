Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3724BC5479D
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Jan 2023 09:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjAFJqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Jan 2023 04:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbjAFJpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2023 04:45:35 -0500
X-Greylist: delayed 378 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 01:43:00 PST
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862C77149A
        for <linux-xfs@vger.kernel.org>; Fri,  6 Jan 2023 01:43:00 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5ddd79e3.dip0.t-ipconnect.de [93.221.121.227])
        by mail.itouring.de (Postfix) with ESMTPSA id 453CC127843;
        Fri,  6 Jan 2023 10:36:40 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 823CBF01583;
        Fri,  6 Jan 2023 10:36:39 +0100 (CET)
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        Carlos Maiolino <cem@kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: [PATCH RESEND] xfsprogs: scrub: fix warnings/errors due to missing
 include
Organization: Applied Asynchrony, Inc.
Message-ID: <e2ce73c2-9633-1a7b-7502-b79b83245fd0@applied-asynchrony.com>
Date:   Fri, 6 Jan 2023 10:36:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Gentoo is currently trying to rebuild the world with clang-16, uncovering exciting
new errors in many packages since several warnings have been turned into errors,
among them missing prototypes, as documented at:
https://discourse.llvm.org/t/clang-16-notice-of-potentially-breaking-changes/65562

xfsprogs came up, with details at https://bugs.gentoo.org/875050.

The problem was easy to find: a missing include for the u_init/u_cleanup
prototypes. The error:

Building scrub
     [CC]     unicrash.o
unicrash.c:746:2: error: call to undeclared function 'u_init'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
         u_init(&uerr);
         ^
unicrash.c:746:2: note: did you mean 'u_digit'?
/usr/include/unicode/uchar.h:4073:1: note: 'u_digit' declared here
u_digit(UChar32 ch, int8_t radix);
^
unicrash.c:754:2: error: call to undeclared function 'u_cleanup'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
         u_cleanup();
         ^
2 errors generated.

The complaint is valid and the fix is easy enough: just add the missing include.

Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
  scrub/unicrash.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index cb0880c1..24d4ea58 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -10,6 +10,7 @@
  #include <sys/types.h>
  #include <sys/statvfs.h>
  #include <strings.h>
+#include <unicode/uclean.h>
  #include <unicode/ustring.h>
  #include <unicode/unorm2.h>
  #include <unicode/uspoof.h>
-- 
2.39.0
