Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800F6C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4292423B3E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbhANSjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbhANSjK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 13:39:10 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE0BC061786
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:04 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id ga15so9693829ejb.4
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ORJHwxZZWNn63QogxiCAQ/JNG4Gky54xOaWWrx9B95A=;
        b=Bjv7ENe2ig2ejaWwLifqN6epMrugkXletbcFZ6z7b9BvQPYSP1NgEaTHvaji6m+N5+
         Zrj5iB8vvahmAJeQD4AQ7I6vGsgGPhuGC30k6Y5nzAhU0mCWYJxAfTzQvbO4B3YJM0z1
         2jiA6WoHghDIMSadCwPEWV7FUpO47HiXPYMQZUFrAPF6wVAdPqp8pvftAEuFH4B5pEbY
         9SoqSc6NlNR3ug+Ux6lnYqGPaoyeBn/VhZA7Ne+aCM3VvnMb+iU06tsu3+6RZLIyjYnQ
         Tf+ik5KKiQEeJXi0c+Rf+hZfvtR2NXS6A07D4zOpGGIfsFVc/hmbuj/QKXI38GGVa01o
         Am1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORJHwxZZWNn63QogxiCAQ/JNG4Gky54xOaWWrx9B95A=;
        b=IMSzXD8z1jxahxeY0UbZhbHAscgyu5T1bz1Zkb9zDehSxXq+kL/qEH/SbrZxSIuAXD
         kMzKOxBYRGbJGnsgqiHeHf5moBx7topiZpm0A7yOCgtRmRhFkcP2U38uBz3cIJuviCdr
         QDcXRFTbrC51cov46eWcXKACQFSuuuebcft4oIKb+kj7J9qnpGnXmWTKq7jF760+PHOm
         9ZUzurTjUldQUSJuPcXKMZTzCzRyznAwGIaWGtSHR6q6B5VKSJRcJLvUUBjCN81/XMwm
         HYYCryaryJn0f3OelP+mRpaNGyDgkv5HrhWDk/aVZPf+tZ0Mbs0TVTj5yJBgfyUduJSc
         fREQ==
X-Gm-Message-State: AOAM5301xSQI3MI4BsVXS2Zai7w8QHs8kOckq/ytxHfRccEf9p8c5Hh0
        azjGyD2X2Ru6BLLza9S2b/oaSEp9Y7GVS5r2
X-Google-Smtp-Source: ABdhPJz7DPmagYipt3OICevs5nAgwjslHOt4/v/pvwaq0llehoHwgZQUCvZvxdBWxi7+4+WHVaAfuA==
X-Received: by 2002:a17:907:160d:: with SMTP id hb13mr6168001ejc.521.1610649482576;
        Thu, 14 Jan 2021 10:38:02 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id s19sm2540876edx.7.2021.01.14.10.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:38:02 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 5/6] debian: add missing copyright info
Date:   Thu, 14 Jan 2021 19:37:46 +0100
Message-Id: <20210114183747.2507-6-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For binary distribution, the copyright info in (L)GPL licensed, compiled
files needs to be retained in the copyright file.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/copyright | 111 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 98 insertions(+), 13 deletions(-)

diff --git a/debian/copyright b/debian/copyright
index 74f4c897..c225bec3 100644
--- a/debian/copyright
+++ b/debian/copyright
@@ -1,19 +1,104 @@
-This package was debianized by Nathan Scott nathans@debian.org on
-Sun, 19 Nov 2000 07:37:09 -0500.
-
-It can be downloaded from https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/
+Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
+Upstream-Name: xfsprogs
+Comment: This package was debianized by Nathan Scott <nathans@debian.org>
+Source: https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/
 
+Files: *
 Copyright:
+ 1995-2013 Silicon Graphics, Inc.
+ 2010-2018 Red Hat, Inc.
+ 2016-2020 Oracle.  All Rights Reserved.
+Comment: For most files, only one of the copyrights applies.
+License: GPL-2
+
+Files:
+ libhandle/*.c
+Copyright: 1995, 2001-2002, 2005 Silicon Graphics, Inc.
+Comment: This also applies to some header files.
+License: LGPL-2.1
+ This library is free software; you can redistribute it and/or modify it
+ under the terms of the GNU Lesser General Public License as published by
+ the Free Software Foundation; version 2.1 of the License.
+ .
+ This library is distributed in the hope that it will be useful, but WITHOUT
+ ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
+ for more details.
+ .
+ On Debian systems, refer to /usr/share/common-licenses/LGPL-2.1
+ for the complete text of the GNU Lesser General Public License.
+
+Files: config.*
+Copyright: 1992-2013 Free Software Foundation, Inc.
+License: GPL-3+ with autoconf exception
+ This file is free software; you can redistribute it and/or modify it
+ under the terms of the GNU General Public License as published by
+ the Free Software Foundation; either version 3 of the License, or
+ (at your option) any later version.
+ .
+ This program is distributed in the hope that it will be useful, but
+ WITHOUT ANY WARRANTY; without even the implied warranty of
+ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ General Public License for more details.
+ .
+ You should have received a copy of the GNU General Public License
+ along with this program; if not, see <http://www.gnu.org/licenses/>.
+ .
+ As a special exception to the GNU General Public License, if you
+ distribute this file as part of a program that contains a
+ configuration script generated by Autoconf, you may include it under
+ the same distribution terms that you use for the rest of that
+ program.  This Exception is an additional permission under section 7
+ of the GNU General Public License, version 3 ("GPLv3").
+ .
+ On Debian systems, the full text of the GNU General Public License version 3
+ License can be found in /usr/share/common-licenses/GPL-3 file.
+
+Files: io/copy_file_range.c
+Copyright: 2016 Netapp, Inc. All rights reserved.
+License: GPL-2
 
-Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
+Files: io/encrypt.c
+Copyright: 2016, 2019 Google LLC
+License: GPL-2
 
-You are free to distribute this software under the terms of
-the GNU General Public License.
-On Debian systems, the complete text of the GNU General Public
-License can be found in /usr/share/common-licenses/GPL file.
+Files:
+ io/link.c
+ libxfs/xfs_iext_tree.c
+Copyright: 2014, 2017 Christoph Hellwig.
+License: GPL-2
+
+Files: io/log_writes.c
+Copyright: 2017 Intel Corporation.
+License: GPL-2
+
+Files: io/utimes.c
+Copyright: 2016 Deepa Dinamani
+License: GPL-2
+
+Files: libfrog/radix-tree.*
+Copyright:
+ 2001 Momchil Velikov
+ 2001 Christoph Hellwig
+ 2005 SGI, Christoph Lameter <clameter@sgi.com>
+License: GPL-2
 
-The library named "libhandle" and the headers in "xfslibs-dev" are
-licensed under Version 2.1 of the GNU Lesser General Public License.
-On Debian systems, refer to /usr/share/common-licenses/LGPL-2.1
-for the complete text of the GNU Lesser General Public License.
+Files: libxfs/xfs_log_rlimit.c
+Copyright: 2013 Jie Liu.
+License: GPL-2
 
+License: GPL-2
+ This program is free software; you can redistribute it and/or modify it under
+ the terms of the GNU General Public License as published by the Free Software
+ Foundation; version 2 of the License.
+ .
+ This program is distributed in the hope that it will be useful, but WITHOUT
+ ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
+ .
+ You should have received a copy of the GNU General Public License along with
+ this package; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ St, Fifth Floor, Boston, MA  02110-1301 USA
+ .
+ On Debian systems, the full text of the GNU General Public License version 2
+ License can be found in /usr/share/common-licenses/GPL-2 file.
-- 
2.30.0

