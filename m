Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAE5C2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 08:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A29820692
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 08:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgDIILb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 04:11:31 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:39415 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDIILb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 04:11:31 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mqrjz-1j0c1O016v-00moPq; Thu, 09 Apr 2020 10:09:19 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: stop CONFIG_XFS_DEBUG from changing compiler flags
Date:   Thu,  9 Apr 2020 10:08:56 +0200
Message-Id: <20200409080909.3646059-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:IoKJ889AecgOScKrn8FN6R5/hy7yMIO15rGFoYkNx5UwRxeI8Pc
 11fHZN0d2fYCi+5PHbyyyWORRQ3ZD64dSBV/S6JxoV///MdUb1jErmO4rVR5oDX1lSmOxA6
 QT9KiCmxxrQjBaK/1ZayTtMddCz9C55RnZQQM6aAM04Amlaq7Aa9uQEeBX8B+DCIHSZzXSq
 oyDYhvFA8T8hL8SmrEMCQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vwtos7LEcOM=:uz1COH1mSJtUcTxQOoynRh
 8Qr87Yw5Kxk3KHR13NU/dXPnuXk3ticYJ8fWYmYZyqAnwy17cvQfg8cpvK/GQvz6SI6gn0rcU
 2846I+PtIo8tfobiGM+x5ZgLM+czo3kLpAWAsTQWeb5+qJte0Rm8qRp5P6EmnMkzd3tsFkvEk
 hSlMasVKHZveo7R+yhHIk7xRhFP5Q/QoZ+e8GMQfT5YAV63s/qVuRGfJcgtF6ONSEicGpvk9o
 ffwpdKwI4tyCRaJ6xnn139Uu1S3ubGc016fif8YzX/DwjPzqmDl4V6EtdHBJtmtxhcmH48X/h
 UY+7slDfKijY91bR1jUDlzLzuILRqINY/o+pHWJJdhCxn+vqWhtttD7XI847VGVWsazcg4FnW
 0MGHZeg4lPFCqxGaXhHw/UMFiXFssPKFREwONf/OKQbzrKPEiOMhTk+log9gr2iQQBWi5Do90
 RQtGEJCoyycefJTXnU/6j++EX5vzOBh8duQ8bUSnWzJMnXaYQJcqfg2f0yiCu6NPlXktk62jM
 V7zN6fpkJ10PF5L2jMifKkMGRYm6AlP8z67b2RYqzsFHCsC0AIXfzzGVWUSxjbSbY8C62oT7R
 8kG3i7/kuRVoPU+Y30weVqovaIzmG9wI/CXdWue4wskslO28v84J79C1qOa1c1iJQM+KiEEt/
 0RV6m2/RqqnwOYVTI9AjN80MIEQcKdt0qXnnhTXeutmhVO1DbnixQ3fGPaM/zZkwW0jP/fTjA
 SkPAv8RnUzKS9jsx0ot9P+JUIRHofW1cMUEUoNaTKe4Z18VaVFzmh1vZMhwhIBFVDVRnbl5tf
 i+pRy/xPoXLL6J4C+l8HBF22kouCHBPdNoOtXPN0wph1thzjn4=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I ran into a linker warning in XFS that originates from a mismatch
between libelf, binutils and objtool when certain files in the kernel
are built with "gcc -g":

x86_64-linux-ld: fs/xfs/xfs_trace.o: unable to initialize decompress status for section .debug_info

After some discussion, nobody could identify why xfs sets this flag
here. CONFIG_XFS_DEBUG used to enable lots of unrelated settings, but
now its main purpose is to enable extra consistency checks and assertions
that are unrelated to the debug info.

Remove the Makefile logic to set the flag here. If anyone relies
on the debug info, this can simply be enabled again with the global
CONFIG_DEBUG_INFO option.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: https://lore.kernel.org/lkml/20200409074130.GD21033@infradead.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4f95df476181..ff94fb90a2ee 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -7,8 +7,6 @@
 ccflags-y += -I $(srctree)/$(src)		# needed for trace events
 ccflags-y += -I $(srctree)/$(src)/libxfs
 
-ccflags-$(CONFIG_XFS_DEBUG) += -g
-
 obj-$(CONFIG_XFS_FS)		+= xfs.o
 
 # this one should be compiled first, as the tracing macros can easily blow up
-- 
2.26.0

