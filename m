Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44622468C
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 01:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>,
	Felix Janda <felix.janda@posteo.de>
Subject: [PATCH v3 2/4] io: Assert we have a sensible off_t
Date: Fri, 15 Dec 2023 01:36:41 +0000
Message-ID: <20231215013657.1995699-2-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215013657.1995699-1-sam@gentoo.org>
References: <20231215013657.1995699-1-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Suggested by Darrick during review of the first LFSization patch. Assert
we have an off_t capable of handling >=4GiB as a failsafe against the macros
not doing the right thing.

This is not the first time we've been on this adventure in XFS:
* 5c0599b721d1d232d2e400f357abdf2736f24a97 ('Fix building xfsprogs on 32-bit platforms')
* 65b4f302b7a1ddc14684ffbf8690227a67362586 ('platform: remove use of off64_t')
* 7fda99a0c2970f7da2661118b438e64dec1751b4 ('xfs.h: require transparent LFS for all users')
* ebe750ed747cbc59a5675193cdcbc3459ebda107 ('configure: error out when LFS does not work')
* 69268aaec5fb39ad71674336c0f6f75ca9f57999 ('configure: use AC_SYS_LARGEFILE')

Cc: Felix Janda <felix.janda@posteo.de>
Signed-off-by: Sam James <sam@gentoo.org>
---
 io/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io/init.c b/io/init.c
index 104cd2c1..2fb598ac 100644
--- a/io/init.c
+++ b/io/init.c
@@ -44,6 +44,9 @@ init_cvtnum(
 static void
 init_commands(void)
 {
+	/* We're only interested in supporting an off_t which can handle >=4GiB. */
+	BUILD_BUG_ON(sizeof(off_t) < 8);
+
 	attr_init();
 	bmap_init();
 	bulkstat_init();
-- 
2.43.0

