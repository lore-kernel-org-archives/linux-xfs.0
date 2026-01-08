Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [178.154.239.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEB22DCF4C;
	Thu,  8 Jan 2026 16:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891223; cv=none; b=Fky/zNpte1a7z6QcDjdMAOteQG6MI7PZn/4NiVly4l1w0HpNQBoHzWxQQlqOCQDVCTUBfi86dc3QW7WbJ38HBCmcPivVBsG9EA/CK4F/RNZbnpgKyibT+dqL4YryEhTKDOSLwDvduAtQgY8EjrJQBpo80E/+E3nGfMrxX3548Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891223; c=relaxed/simple;
	bh=a/PG0I0qaKEOF6UHEkAU70vnBJfzao1XHkqiurKGDhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/silcOYjxoOsPwFQb7hfBDvIdkPBgDPOyAYIRbU3tKKqvQqQRE1FaJAIDVh5XT5s9kAxVPJ8Hq7uztfSfBtu5gzSDn4nh4QZY6hQDYT8tg+VEic7VlTDRUnqTiV3EEfYbYZL9+2xtAv8F7LWQQqgPui3+sy9PZ8RC455jreB+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ndBNT6ng; arc=none smtp.client-ip=178.154.239.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ndBNT6ng"
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:582e:0:640:200:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id DAB4A80835;
	Thu, 08 Jan 2026 19:53:30 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id RrRCtaIHHKo0-LmnSN20e;
	Thu, 08 Jan 2026 19:53:30 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1767891210; bh=DwingL75fI5q1yVA8SihsPfpQUrP3tVSNDl7+Gk5ZXk=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=ndBNT6ngNBft3FMWJbAcaU3nLjp3I7bhXi7VnV7eidT/mw063jVxk03UBnEu+m49d
	 /T9dzRIXhJ7YB/PhNMZkL1stUkXHN3mM3OuXw77cUSTpCiUEoCNHg/hPOrP++XS2HZ
	 yiDajZbTaXQEjFp9TADXsdT3HcYyb1U6+eEeTKAc=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v3 2/2] xfs: adjust handling of a few numerical mount options
Date: Thu,  8 Jan 2026 19:52:16 +0300
Message-ID: <20260108165216.1054625-2-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108165216.1054625-1-dmantipov@yandex.ru>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prefer recently introduced 'memvalue()' over an ad-hoc 'suffix_kstrtoint()'
and 'suffix_kstrtoull()' to parse and basically validate the values passed
via 'logbsize', 'allocsize', and 'max_atomic_write' mount options, and
reject non-power-of-two values passed via the first and second one early
in 'xfs_fs_parse_param()' rather than in 'xfs_fs_validate_params()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v3: adjust to match new 'memvalue()' syntax
v2: rely on 'memvalue()' as (well, IIUC) suggested by Christoph and
    handle both 'logbsize' and 'allocsize' in 'xfs_fs_parse_param()'
---
 fs/xfs/xfs_super.c | 127 +++++++++++----------------------------------
 1 file changed, 29 insertions(+), 98 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8..4707cd3acf73 100644
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
@@ -1427,8 +1356,8 @@ xfs_fs_parse_param(
 {
 	struct xfs_mount	*parsing_mp = fc->s_fs_info;
 	struct fs_parse_result	result;
-	int			size = 0;
-	int			opt;
+	int			opt, ret;
+	unsigned long long	val;
 
 	BUILD_BUG_ON(XFS_QFLAGS_MNTOPTS & XFS_MOUNT_QUOTA_ALL);
 
@@ -1444,8 +1373,19 @@ xfs_fs_parse_param(
 		parsing_mp->m_logbufs = result.uint_32;
 		return 0;
 	case Opt_logbsize:
-		if (suffix_kstrtoint(param->string, 10, &parsing_mp->m_logbsize))
+		ret = memvalue(param->string, &val);
+		if (ret)
+			return ret;
+		if (val != 0 &&
+		    (val < XLOG_MIN_RECORD_BSIZE ||
+		     val > XLOG_MAX_RECORD_BSIZE ||
+		     !is_power_of_2(val))) {
+			xfs_warn(parsing_mp,
+				 "invalid logbsize %llu: not a power-of-two in [%u..%u]",
+				 val, XLOG_MIN_RECORD_BSIZE, XLOG_MAX_RECORD_BSIZE);
 			return -EINVAL;
+		}
+		parsing_mp->m_logbsize = val;
 		return 0;
 	case Opt_logdev:
 		kfree(parsing_mp->m_logname);
@@ -1460,9 +1400,18 @@ xfs_fs_parse_param(
 			return -ENOMEM;
 		return 0;
 	case Opt_allocsize:
-		if (suffix_kstrtoint(param->string, 10, &size))
+		ret = memvalue(param->string, &val);
+		if (ret)
+			return ret;
+		if (val < (1ULL << XFS_MIN_IO_LOG) ||
+		    val > (1ULL << XFS_MAX_IO_LOG) ||
+		    !is_power_of_2(val)) {
+			xfs_warn(parsing_mp,
+				 "invalid allocsize %llu: not a power-of-two in [%u..%u]",
+				 val, 1 << XFS_MIN_IO_LOG, 1 << XFS_MAX_IO_LOG);
 			return -EINVAL;
-		parsing_mp->m_allocsize_log = ffs(size) - 1;
+		}
+		parsing_mp->m_allocsize_log = ffs(val) - 1;
 		parsing_mp->m_features |= XFS_FEAT_ALLOCSIZE;
 		return 0;
 	case Opt_grpid:
@@ -1570,12 +1519,13 @@ xfs_fs_parse_param(
 		parsing_mp->m_features |= XFS_FEAT_NOLIFETIME;
 		return 0;
 	case Opt_max_atomic_write:
-		if (suffix_kstrtoull(param->string, 10,
-				     &parsing_mp->m_awu_max_bytes)) {
+		ret = memvalue(param->string, &val);
+		if (ret) {
 			xfs_warn(parsing_mp,
  "max atomic write size must be positive integer");
-			return -EINVAL;
+			return ret;
 		}
+		parsing_mp->m_awu_max_bytes = val;
 		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
@@ -1629,25 +1579,6 @@ xfs_fs_validate_params(
 		return -EINVAL;
 	}
 
-	if (mp->m_logbsize != -1 &&
-	    mp->m_logbsize !=  0 &&
-	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
-	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
-	     !is_power_of_2(mp->m_logbsize))) {
-		xfs_warn(mp,
-			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
-			mp->m_logbsize);
-		return -EINVAL;
-	}
-
-	if (xfs_has_allocsize(mp) &&
-	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
-	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
-		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
-- 
2.52.0

