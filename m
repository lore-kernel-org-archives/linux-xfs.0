Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94999C46467
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 23:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjASXjW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 18:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjASXjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 18:39:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7294F526C
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 15:39:13 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so6585946pjq.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 15:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6MFaWJtnrNy23NOckrHX0v3agJ8GzYKt5uQcMvuYHM=;
        b=iBSr8BPIdE5O83HxpbIiLbg8dmAHUBJNVubPYolZUulqa/uhrlapVo6clLfDzS+sQr
         L1xRKg/ltqxcc/+vEa0bkieZ6g1Df0fhHtR9vmPysqzfVacCOqwdg2rNTeKaFxgbsbks
         +a0+hvmeS2Cob8RKLHgBMCYbmCj7WgyliwwXEXMaxAyfdD3wdIgYnMot/Y0R0GZfRt9V
         P5eyKR/s4sJ1ghTojRbnL/Z75w4asSQ/9mb3YH+1wRyVzuxMGca72d5Q2EkKHM7kymWo
         VbTYp3IGfnQOmbCc+oG/E5KAOlaJ03p1tPyz0ZeOVuSV919TYsDUHexm7T93k10TXy+R
         EwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6MFaWJtnrNy23NOckrHX0v3agJ8GzYKt5uQcMvuYHM=;
        b=nr3r2ZKcgW+gqQOThEJf/u8L+s58bc3XIn3Rb4TFrmSBbl+1mkvoDijDai/0tHucqj
         6GxeiX4ewzB+FSCvwju+8oZxz6of8R8D7rWymwN3XYujqjK4GLkD8FjvSy4DZpYlcpPO
         KX+47DJ1NdgXMNmrvne0N/c2D/9KVrIoLKMNtSgJUfyfDcH4zzTYhAp9erWj01PDPIHk
         D+Bsg1hSV4OWibytoyeDSyrDMz3ru0MFHEuPsqYx1PpL5VY7DiM3OwCG2k00CwBxl6hn
         H5hmiZBXYs4KnvoN7FrANRDFYJ4nrrtaG/s3g5onaFt11iIvtY2xDJT1KfrX+LCFBHPm
         ay+Q==
X-Gm-Message-State: AFqh2kpMCsGg0xLLzVIYnK+RP4JfKxlTPiaHVjqEWJmv0fBYHZ3q2Q1n
        EtOBeYBlUjdZmoxTkTyBO7021dP3Sddz81PQ
X-Google-Smtp-Source: AMrXdXs4PuJn2pyhrSXqIJAUbPWD5K4S5lF+ckpVPw6nGi15xV1HdLjZ1tqNt/pvq+/lFR5UVVWrEQ==
X-Received: by 2002:a17:90a:6447:b0:226:ae12:444d with SMTP id y7-20020a17090a644700b00226ae12444dmr13147612pjm.43.1674171552919;
        Thu, 19 Jan 2023 15:39:12 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id h1-20020a17090ac38100b0022908f1398dsm199710pjt.32.2023.01.19.15.39.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:39:12 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIeUv-00581g-4Y
        for linux-xfs@vger.kernel.org; Fri, 20 Jan 2023 10:39:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIeUu-008cfn-30
        for linux-xfs@vger.kernel.org;
        Fri, 20 Jan 2023 10:39:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] progs: autoconf fails during debian package builds
Date:   Fri, 20 Jan 2023 10:39:05 +1100
Message-Id: <20230119233906.2055062-2-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119233906.2055062-1-david@fromorbit.com>
References: <20230119233906.2055062-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For some reason, a current debian testing build system will fail to
build debian packages because the build environment is not correctly
detecting that libtoolize needs the "-i" parameter to copy in the
files needed by autoconf.

My build scripts run "make -j 16 realclean; make -j 16 deb", and the
second step is failing immediately with:

libtoolize -c `libtoolize -n -i >/dev/null 2>/dev/null && echo -i` -f
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, '.'.
libtoolize: copying file './ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'm4'.
libtoolize: copying file 'm4/libtool.m4'
libtoolize: copying file 'm4/ltoptions.m4'
libtoolize: copying file 'm4/ltsugar.m4'
libtoolize: copying file 'm4/ltversion.m4'
libtoolize: copying file 'm4/lt~obsolete.m4'
libtoolize: Consider adding '-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
cp include/install-sh .
aclocal -I m4
autoconf
./configure $LOCAL_CONFIGURE_OPTIONS
configure: error: cannot find required auxiliary files: config.guess config.sub
make: *** [Makefile:131: include/builddefs] Error 1

If I run 'make realclean; make deb' from the command line, the
package build runs to completion.  I have not been able to work out
why the initial build fails, but then succeeds after a 'make
realclean' has been run, and I don't feel like spending hours
running down this rabbit hole.

This conditional "-i" flag detection was added back in *2009* when
default libtoolize behaviour was changed to not copy the config
files into the build area, and the "-i" flag was added to provide
that behaviour. It is detecting that the "-i" flag is needed that is
now failing, but it is most definitely still needed.

Rather than ispending lots of time trying to understand this and
then making the detection more complex, just use the "-i" flag
unconditionally and require any userspace that this now breaks on to
upgrade their 15+ year old version of libtoolize something a little
more modern.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Makefile | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 0edc2700933d..c8455a9e665f 100644
--- a/Makefile
+++ b/Makefile
@@ -115,14 +115,8 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
-
-# Recent versions of libtool require the -i option for copying auxiliary
-# files (config.sub, config.guess, install-sh, ltmain.sh), while older
-# versions will copy those files anyway, and don't understand -i.
-LIBTOOLIZE_INSTALL = `$(LIBTOOLIZE_BIN) -n -i >/dev/null 2>/dev/null && echo -i`
-
 configure: configure.ac
-	$(LIBTOOLIZE_BIN) -c $(LIBTOOLIZE_INSTALL) -f
+	$(LIBTOOLIZE_BIN) -c -i -f
 	cp include/install-sh .
 	aclocal -I m4
 	autoconf
-- 
2.39.0

