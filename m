Received: from forward206a.mail.yandex.net (forward206a.mail.yandex.net [178.154.239.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980A615624B
	for <linux-xfs@vger.kernel.org>; Thu, 25 Dec 2025 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766673726; cv=none; b=AI/nd2ZqCW3O1E7Jns2akKqkI6UT0IbVf80qz8Fwr4xUryQqqDHK6bmyHlsZkwS1RfuWPr3OrHDCWUaRI2RqJ53XM7ApieI+5LdjI+Ll4AeHujdPZx61xoza0E3UxVmXljJnFBNEtwdXoOHhwpusjiclpWIzrFGTtnWNIEEHxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766673726; c=relaxed/simple;
	bh=SrO910D7k0Kwwf55osU2c4tUmu/H78epECpovpMftL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LK7tTmMlbJvKLTBOGlr/XtC2X+IR/mdlZohr1RD/9EKqznDuD8pEAecoNf/rAIC67kMyo02B0OC4cMYe41pKBkn8CBxQhgj2dAhngMqLn/n5n83OlgccVRU1++FMEeotgU33GXWb8V1SvSMiu14TL+olj8xvKFzZpBISde1aiCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=iFYcLbYe; arc=none smtp.client-ip=178.154.239.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="iFYcLbYe"
Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d102])
	by forward206a.mail.yandex.net (Yandex) with ESMTPS id 4838D8602C
	for <linux-xfs@vger.kernel.org>; Thu, 25 Dec 2025 17:41:55 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1d:6148:0:640:ada2:0])
	by forward102a.mail.yandex.net (Yandex) with ESMTPS id 781E3C0065;
	Thu, 25 Dec 2025 17:41:47 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id jfeRmt9GvGk0-JFfNcUSk;
	Thu, 25 Dec 2025 17:41:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1766673705; bh=YjCOFnRu2ZOeHHYlrsrSfqpS49do96XMawy0MOL1IjY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=iFYcLbYeWq/GlzmAWw6VBeBAjUjuIY/WCBKBsMYEH5OzDARKAN6jRxEz7TKYplcL5
	 UqvzsbDX9t5LI86jkipOTvieoIkHMXMnURMViMFsYcY//JCGdLKYR/mSFjfPC4Md/E
	 6kUBAhEezNfK39dxbZAKuII1LThJMdExfveNvPRE=
Authentication-Results: mail-nwsmtp-smtp-production-main-67.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 1/2] xfs: use memparse() when parsing mount options
Date: Thu, 25 Dec 2025 17:41:37 +0300
Message-ID: <20251225144138.150882-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'xfs_fs_parse_param()', prefer convenient 'memparse()' over
'suffix_kstrtoint()' and 'suffix_kstrtoull()' (and remove both
of them since they're not used anywhere else).

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/xfs/xfs_super.c | 93 ++++++++--------------------------------------
 1 file changed, 15 insertions(+), 78 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8..433c27721b95 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1319,77 +1319,6 @@ static const struct super_operations xfs_super_operations = {
 	.show_stats		= xfs_fs_show_stats,
 };
 
-static int
-suffix_kstrtoint(
-	const char	*s,
-	unsigned int	base,
-	int		*res)
-{
-	int		last, shift_left_factor = 0, _res;
-	char		*value;
-	int		ret = 0;
-
-	value = kstrdup(s, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
-		shift_left_factor = 10;
-		value[last] = '\0';
-	}
-	if (value[last] == 'M' || value[last] == 'm') {
-		shift_left_factor = 20;
-		value[last] = '\0';
-	}
-	if (value[last] == 'G' || value[last] == 'g') {
-		shift_left_factor = 30;
-		value[last] = '\0';
-	}
-
-	if (kstrtoint(value, base, &_res))
-		ret = -EINVAL;
-	kfree(value);
-	*res = _res << shift_left_factor;
-	return ret;
-}
-
-static int
-suffix_kstrtoull(
-	const char		*s,
-	unsigned int		base,
-	unsigned long long	*res)
-{
-	int			last, shift_left_factor = 0;
-	unsigned long long	_res;
-	char			*value;
-	int			ret = 0;
-
-	value = kstrdup(s, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
-		shift_left_factor = 10;
-		value[last] = '\0';
-	}
-	if (value[last] == 'M' || value[last] == 'm') {
-		shift_left_factor = 20;
-		value[last] = '\0';
-	}
-	if (value[last] == 'G' || value[last] == 'g') {
-		shift_left_factor = 30;
-		value[last] = '\0';
-	}
-
-	if (kstrtoull(value, base, &_res))
-		ret = -EINVAL;
-	kfree(value);
-	*res = _res << shift_left_factor;
-	return ret;
-}
-
 static inline void
 xfs_fs_warn_deprecated(
 	struct fs_context	*fc,
@@ -1429,6 +1358,8 @@ xfs_fs_parse_param(
 	struct fs_parse_result	result;
 	int			size = 0;
 	int			opt;
+	char			*end;
+	unsigned long long	v;
 
 	BUILD_BUG_ON(XFS_QFLAGS_MNTOPTS & XFS_MOUNT_QUOTA_ALL);
 
@@ -1444,8 +1375,12 @@ xfs_fs_parse_param(
 		parsing_mp->m_logbufs = result.uint_32;
 		return 0;
 	case Opt_logbsize:
-		if (suffix_kstrtoint(param->string, 10, &parsing_mp->m_logbsize))
+		v = memparse(param->string, &end);
+		if (*end != 0)
 			return -EINVAL;
+		if (v > INT_MAX)
+			return -ERANGE;
+		parsing_mp->m_logbsize = v;
 		return 0;
 	case Opt_logdev:
 		kfree(parsing_mp->m_logname);
@@ -1460,8 +1395,12 @@ xfs_fs_parse_param(
 			return -ENOMEM;
 		return 0;
 	case Opt_allocsize:
-		if (suffix_kstrtoint(param->string, 10, &size))
+		v = memparse(param->string, &end);
+		if (*end != 0)
 			return -EINVAL;
+		if (v > INT_MAX)
+			return -ERANGE;
+		size = v;
 		parsing_mp->m_allocsize_log = ffs(size) - 1;
 		parsing_mp->m_features |= XFS_FEAT_ALLOCSIZE;
 		return 0;
@@ -1570,12 +1509,10 @@ xfs_fs_parse_param(
 		parsing_mp->m_features |= XFS_FEAT_NOLIFETIME;
 		return 0;
 	case Opt_max_atomic_write:
-		if (suffix_kstrtoull(param->string, 10,
-				     &parsing_mp->m_awu_max_bytes)) {
-			xfs_warn(parsing_mp,
- "max atomic write size must be positive integer");
+		v = memparse(param->string, &end);
+		if (*end != 0 || v == 0)
 			return -EINVAL;
-		}
+		parsing_mp->m_awu_max_bytes = v;
 		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
-- 
2.52.0

