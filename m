Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115767;
	b=rC6erCuq3DLk134aweJ4pP+yn0QLHFQhnCzxgs3K5wOwRnulLdUeE3eak6vsmdRIGrgw
	 CV0x/rNnZBDXvy74rRRqXbUsVGj2RAhhcT5s0koaVxJj9VntPvVkXyDy8eYjEips7ZXfI
	 NHKfTqS4YWgJ0Lbccse3PJD3jQdLM2hfdD2R8deBSjPfOEgsCrZliTUHkGOZ9NhNOFD6V
	 92cOLvVzW4CHVGvNfvOJE8bNasWAkUrhmLz3raNI0Z1uYj7rT1KHIvLkbWldDq5veoQqf
	 hkStRyq97b7+MehnwWlqNsh7aQnFw9rJwOERcB4lROi8vISijoVk3CufnFtChuh0X5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115767;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=Oy+CE2RYYyn0oETTZTxS64aySK+Ap9wleRO+M9MAhTE=;
	b=Hm+it2xu4OPkk7qumnhEdetUG3A+9osi1akAoAAWgweX4VPgi5XPY4830gIpRyLm5hS7
	 adqrxR1lC2w01GQnTsGe8y6BvuOry5ZfR+rPhfQOZVq/JPWKpEgyCEeeZnaOfHf4H/IX/
	 GNW7i4vFA/ILST5aIjUbeE1ZBlnAd8D2y7GgHVnVY2N2ebO5rpiICQfpBiyWxv/JQRs/0
	 nuNgYm4xe8+zz/px1A5FiSQoVGouuZKikk8fNgCQqYV9CnSNhXAKk6UrMDFeek0Sm1A03
	 n5uV1BE+GUO5j3JaDBnmmMkxinsu2BNmaRMOPd5rFjMDWnkECoheP+Nje00rEPEn/yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="AF4T/wAL";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D1606A31D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 15:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F39D1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=AF4T/wAL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Oy+CE2RYYyn0oETTZTxS64aySK+Ap9wleRO+M9MAhTE=; b=AF4T/wALHl4WeP+OfB6Wjr/Pyg
	0hHbLxhMACzjmRIZt5b+I1x/Z3Jn3dJJj9rwJLzmBlScvXgteGLySUEfrGkulZzzmEuoqNgFPXVM2
	s03XRBnNCxxh7sxDH2IRjhRu3QftLGWM/mtF7mcWg+tkm+MjspGQHWDt4L95+BHQsETGMRNN3g2yB
	SWCZ+idN6039DweTA9u05fUvxlAPRqcrKQwdRBYXPKhLnzTV7sl10C+wGUmyC29t0NUHegK2PUY0W
	dXeYAoRO0s4JVidXHwPudWlrF079JwBb/hTSfzJ8UjO9FGB55+3DUaLRe6PRc6gIIQvCImOTzlX8Q
	2axrKIdA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLjK2-00000005FvV-10Ql;
	Tue, 27 Oct 2026 15:42:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] libfrog: constify cvt*
Date: Tue, 27 Oct 2026 16:42:16 +0100
Message-ID: <20261027154237.1997484-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027154237.1997484-1-hch@lst.de>
References: <20261027154237.1997484-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/convert.c | 20 ++++++++++----------
 libfrog/convert.h | 24 ++++++++++++------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/libfrog/convert.c b/libfrog/convert.c
index 65b9e47459e2..605f309f2ad9 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -29,7 +29,7 @@ numlen(
  */
 int64_t
 cvt_s64(
-	char		*s,
+	const char	*s,
 	int		base)
 {
 	long long	i;
@@ -59,7 +59,7 @@ cvt_s64(
  */
 int32_t
 cvt_s32(
-	char		*s,
+	const char	*s,
 	int		base)
 {
 	int64_t		i;
@@ -82,7 +82,7 @@ cvt_s32(
  */
 int16_t
 cvt_s16(
-	char		*s,
+	const char	*s,
 	int		base)
 {
 	int64_t		i;
@@ -105,7 +105,7 @@ cvt_s16(
  */
 uint64_t
 cvt_u64(
-	char			*s,
+	const char		*s,
 	int			base)
 {
 	unsigned long long	i;
@@ -135,7 +135,7 @@ cvt_u64(
  */
 uint32_t
 cvt_u32(
-	char		*s,
+	const char	*s,
 	int		base)
 {
 	uint64_t	i;
@@ -158,7 +158,7 @@ cvt_u32(
  */
 uint16_t
 cvt_u16(
-	char		*s,
+	const char	*s,
 	int		base)
 {
 	uint64_t	i;
@@ -266,7 +266,7 @@ cvtstr(
 
 time64_t
 cvttime(
-	char		*s)
+	const char	*s)
 {
 	time64_t	i;
 	char		*sp;
@@ -303,7 +303,7 @@ cvttime(
 
 prid_t
 prid_from_string(
-	char		*project)
+	const char	*project)
 {
 	fs_project_t	*prj;
 	unsigned long	prid_long;
@@ -328,7 +328,7 @@ prid_from_string(
 
 uid_t
 uid_from_string(
-	char		*user)
+	const char	*user)
 {
 	struct passwd	*pwd;
 	unsigned long	uid_long;
@@ -349,7 +349,7 @@ uid_from_string(
 
 gid_t
 gid_from_string(
-	char		*group)
+	const char	*group)
 {
 	struct group	*grp;
 	unsigned long	gid_long;
diff --git a/libfrog/convert.h b/libfrog/convert.h
index 223d3e73c942..2a91b5b5b6b6 100644
--- a/libfrog/convert.h
+++ b/libfrog/convert.h
@@ -6,21 +6,21 @@
 #ifndef __LIBFROG_CONVERT_H__
 #define __LIBFROG_CONVERT_H__
 
-extern int64_t	cvt_s64(char *s, int base);
-extern int32_t	cvt_s32(char *s, int base);
-extern int16_t	cvt_s16(char *s, int base);
+int64_t	cvt_s64(const char *s, int base);
+int32_t	cvt_s32(const char *s, int base);
+int16_t	cvt_s16(const char *s, int base);
 
-extern uint64_t	cvt_u64(char *s, int base);
-extern uint32_t	cvt_u32(char *s, int base);
-extern uint16_t	cvt_u16(char *s, int base);
+uint64_t cvt_u64(const char *s, int base);
+uint32_t cvt_u32(const char *s, int base);
+uint16_t cvt_u16(const char *s, int base);
 
-extern long long cvtnum(size_t blocksize, size_t sectorsize, const char *s);
-extern void cvtstr(double value, char *str, size_t sz);
-extern time64_t cvttime(char *s);
+long long cvtnum(size_t blocksize, size_t sectorsize, const char *s);
+void cvtstr(double value, char *str, size_t sz);
+time64_t cvttime(const char *s);
 
-extern uid_t	uid_from_string(char *user);
-extern gid_t	gid_from_string(char *group);
-extern prid_t	prid_from_string(char *project);
+uid_t uid_from_string(const char *user);
+gid_t gid_from_string(const char *group);
+prid_t prid_from_string(const char *project);
 
 #define EXABYTES(x)	((unsigned long long)(x) << 60)
 #define PETABYTES(x)	((unsigned long long)(x) << 50)
-- 
2.53.0

