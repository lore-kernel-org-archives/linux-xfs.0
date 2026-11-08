Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794101081;
	b=vR0yIqsC9+cf3LkwxfsviICJNkeJPjPs63/y+pQYcDPpdpID00FrkyveBAgiQJUcZD8y
	 dw7/BxYXS3eT4tKmJkOMpQ7mHnBix6/MZ/NqF8JCMc33axP4KrcqCxN9CV1ETEM0i6L0z
	 zh+GJqVWbY1OyacQog8RSlGeoZP+tvH5516Z6PMoDjEsWPygaZRgstC7FcMTNkTByxWw6
	 D3TcCIZjQiyGVo/0hUAhz1oFUofTzwtQZ7jgYbA9yted3eI1t9qW23vOVYBDp4npFFGs1
	 b7viQmigVZj+/iC1pStX/aRTU64o8MijZwS5ZMzNEx33Z4FVcTYMxg0ijWXWwPMB/jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794101081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fynx4BF+BE6Rr0FItY/Hw9N1v6IsflNrTh0Mq7iV+o0=;
	b=rBLOg9eGa7+SYVeFt5zBJFraZvuqYH2eouLuA3kMV/9aj57oDk3jp1sHPEdqpFc9ltaK
	 jiUjPqIejN+jSRgmKR9MHDGYWbdLyJF3qpW3R3l01ogz/hTkEIOK1jquXSr9rbf6DBtTX
	 4SnJvOj/d6h6OqdC56+Dv5CVEl69Gsufyf3OJBJFy6cdsvKkgJeRLYXXvYxMLXGYtp7sX
	 jYcTzCO4/GnD+ngEu8JCmWuZDeG9JNbJeVezhC3Brm3fxdmqoP244CRZY7HUsttBx9xTO
	 6zzXCdb1bXtAOeKV6AV+3HUqWIUDfbgZUpp7ZLk2yLDxRGTRnwNMXeI4gYYeAW94xtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XkgWcM18;
	arc=none smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266B2606A326
	for <linux-xfs@vger.kernel.org>; Sun,  8 Nov 2026 01:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 266B2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XkgWcM18
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b354d27917so427397b3.0
        for <linux-xfs@vger.kernel.org>; Sat, 07 Nov 2026 17:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794101080; x=1794705880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fynx4BF+BE6Rr0FItY/Hw9N1v6IsflNrTh0Mq7iV+o0=;
        b=XkgWcM183XzRR0HjYLKMkAB+lb5s1CoOoRHCaPTxtc4jOvBgpkD+p/G3qjz8C3HHLq
         Ta3C+wzvplg/SgiMdqqQLCE1xD5n4Ur1dglGtVzYrekMSd9e/yQUVJt+nzpGYHrlWPua
         pkvB8XG1PaLd4jg/vI8pAaz8ue55/8VdY45HNzq0iM3IlC0MkFNpTlgjwnRn2FiMOPUB
         bLpbxl1b1LEjq4/w6q9YF7A7wvEDoIPUwIHF3ayDFlazyZXSefsguB0ad46yKRn9o1dA
         YDUCrhjXSXkXfMRTWZcMQgZeL5caR87M9la4A1Z9yQ51M6aIftOb5+/QoHJq7bMt5Dpy
         Ig6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794101080; x=1794705880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fynx4BF+BE6Rr0FItY/Hw9N1v6IsflNrTh0Mq7iV+o0=;
        b=K7uxnMdu+SA3FfafJ0AepV4yqEkHvUYE+bv9wWpwC425dTSOeVtnwk1OmIIaAARFD6
         Rvp+wadIG1O5s3W1GCw3TQ6uBHKT5pgSymrNUJcJxcZlQkUA9pjxXDt8vNHkpn4Sx1Mw
         DtHXEgFoMX6fPnsT6PxHE8rBuMaAgdaQTekxGYYZJAbYgBl42P/VRDImoto9eC0xXLLu
         TwFQleieKRp8j5/o6xfacKJysxjFgSXXZ8PLXhLOwbeQ5Sqq23VDbUZmkyMvBifyRqvc
         umMpkgI/+uM92erDUuoN6FcgOGA/km1Bkjw+Wb6JuZQv57koPObxg86ecVjkDU6syvtR
         DOaw==
X-Gm-Message-State: APuU4Z/s9A+pPf1PrHy9htkefIFu+L9lRFE2MW91kVUr4NHd0TmGcMBl
	v1aS4+zKAaWimoCv4JpoE8HS50apQ/Ufi6gKLwY6vYhacHAlslemge/wsE+CZA==
X-Gm-Gg: AYBFou3e1Bd5jeQnKjDLLLsJ4gTrjv7dWkIonifa3R/GYLqjFOfxKGk71k+jPKrzxYt
	MAtm7GKuB6m9s5qauYdh/klMNOerrKvSXdarn4YkJpdU2+mOjI6Ut7f0DJruP8a4tLoZWo/8EJP
	vq+vEdiiaF8PBPMLpwDWhjvvEdafgIDzn8WopEFiBozBHk9aSF2ZF0jR5kjdB5UAoRMpHedZGPZ
	h02qUBePVZcXzPuBxmTIyDRP3VPx1tzFSEvwNyjVnQJjPo3ls2Eg7o1/5wMvHcR4gCGK5M7PbGt
	YO4ImjOu7rx0rQW3jYLOXQQaT9G03G1MezUFq/rBYpHKkXonUYC6tFL671Xh/zpOxybFcs26GXC
	PxaAJrvnjcwofOojAb7U1iHeBqk7C1tHsJzX2fetBLl298lxPIJ2eqKHKU5wAgWT+ykmKvA6uR+
	z1zToNjhW450UO9UGS81yk0iUrisIIMANc4SR8hTr7SV/LNiC89AX+06taJ/S3sR+Up4LkkPSOm
	mudy6M4ZMgGulqrln67dk0ocWpT+ZjebrXGe54nRG8ME12+vUtRxBw631+yvf2ldFh93gS6XCfc
	uHDnC75WVtz49ehPBbACkSA4ob9N65HLO9G7Unzy43+sxwq6UM91hVuLRQ==
X-Received: by 2002:a05:690c:386:b0:873:5c7b:c0ef with SMTP id 00721157ae682-8b36ca6dd35mr3019497b3.39.1794101080211;
        Sat, 07 Nov 2026 17:24:40 -0800 (PST)
Received: from diego.local ([186.151.96.233])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b36bb86036sm4910457b3.18.2026.11.07.17.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 17:24:39 -0800 (PST)
From: Diego Rivera <diego.rivera.cr@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	cem@kernel.org,
	djwong@kernel.org,
	Diego Rivera <diego.rivera.cr@gmail.com>
Subject: [PATCH xfsdump 2/2] xfsdump: allow dump levels up to 254
Date: Sat,  7 Nov 2026 19:24:09 -0600
Message-ID: <20261108012410.3156325-3-diego.rivera.cr@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108012410.3156325-1-diego.rivera.cr@gmail.com>
References: <20261108012410.3156325-1-diego.rivera.cr@gmail.com>
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

The 0-9 range of dump levels is not imposed by any on-media or
inventory structure. The media file header stores the level as an
int32_t (cih_level) and the inventory as a byte (sh_level). The range
is a policy constant, LEVEL_MAX in dump/content.c, inherited from
the traditional dump(8) convention of single-digit levels; Linux
dump(8) itself has accepted any integer level for years. The only
code that actually depends on it is xfsrestore's display of the level,
which asserted the level was a single digit (fixed earlier in this
series).

Raise LEVEL_MAX to INV_LEVEL_MAX, 254: the most sh_level can hold,
keeping 255 (PR_MAXLEVEL) as the "any level" marker of the -I level=
print filter. The inventory format and code are otherwise unchanged,
so older xfsdump, xfsrestore and xfsinvutil sharing the inventory see
the real levels, and older xfsdump never picks a session above its own
maximum of 9 as the base of an incremental.

Released xfsrestore still carries that assert, and aborts on any dump
whose level is 10 or more when built without NDEBUG. To let it restore
the new dumps anyway, cap the level xfsdump writes into cih_level at
9, and record the real level in the 4 bytes of alignment padding that
follow it (pad1, renamed cih_level_ext): two tag bytes plus a
big-endian 16-bit level. Older xfsrestore only compares cih_level with
0, so it restores such a dump correctly and just reports it as level
9. New xfsrestore decodes the real level with cih_get_level(). The
padding was always zeroed (the header template is calloc()ed), and
the tag is only honoured together with cih_level == 9, so dumps from
older xfsdump decode unchanged. Dumps at levels 0-9 are byte-for-byte
the same as before.

Restore's cumulative-restore checks work on base dump ids, not on
levels, so they need no change.

Also reject a non-numeric -l argument instead of letting atoi() turn
it silently into level 0.

Drafted with an AI coding assistant (Claude); details in the cover
letter of the posting.

Signed-off-by: Diego Rivera <diego.rivera.cr@gmail.com>
---
 common/arch_xlate.c    |  2 +-
 common/content_inode.h | 60 +++++++++++++++++++++++++++++++++++++++---
 dump/content.c         | 23 +++++++++++++---
 inventory/inventory.h  |  7 ++++-
 man/man8/xfsdump.8     | 10 +++++--
 restore/content.c      |  6 ++---
 6 files changed, 94 insertions(+), 14 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index 46d525f..fcd553e 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -253,7 +253,7 @@ xlate_content_inode_hdr(content_inode_hdr_t *cih1, content_inode_hdr_t *cih2, in
 		ptr2 = cih1;
 	}
 
-	BXLATE(pad1);
+	BXLATE(cih_level_ext);
 	BXLATE(cih_last_id);
 	BXLATE(cih_resume_id);
 	BXLATE(cih_pad2);
diff --git a/common/content_inode.h b/common/content_inode.h
index c49a532..565ac02 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -71,9 +71,10 @@ struct content_inode_hdr {
 	int32_t cih_dumpattr;				/*   4   8 */
 		/* dump attributes: see #defines below */
 	int32_t cih_level;				/*   4   c */
-		/* dump level */
-	char pad1[4];					/*   4  10 */
-		/* alignment */
+		/* dump level, clamped: use cih_{get,set}_level() */
+	char cih_level_ext[4];				/*   4  10 */
+		/* dump levels above CIH_LEVEL_LEGACY_MAX; was "pad1",
+		 * always zero in dumps from older xfsdump */
 	time32_t cih_last_time;				/*   4  14 */
 		/* if an incremental, time of previous dump at a lesser level */
 	time32_t cih_resume_time;			/*   4  18 */
@@ -132,6 +133,59 @@ typedef struct content_inode_hdr content_inode_hdr_t;
 #define CIH_DUMPATTR_EXTATTRHDR_CHECKSUM	(1 << 13)
 #define CIH_DUMPATTR_NOTSELFCONTAINED		(1 << 14)
 
+/* dump level encoding
+ *
+ * cih_level is an int32_t, but xfsrestore up to and including v3.3.0
+ * asserts that it is a single digit, and otherwise only ever checks it
+ * against zero. So that those versions can still restore dumps made at
+ * higher levels, a level above CIH_LEVEL_LEGACY_MAX is recorded in
+ * cih_level as CIH_LEVEL_LEGACY_MAX, and in full in cih_level_ext as the
+ * two tag bytes below followed by the level as a big-endian 16-bit value.
+ * Dumps at levels 0 to CIH_LEVEL_LEGACY_MAX are written exactly as before,
+ * with cih_level_ext all zero.
+ *
+ * cih_level_ext is copied byte for byte by xlate_content_inode_hdr(), so
+ * byte order is handled here.
+ */
+#define CIH_LEVEL_LEGACY_MAX	9
+#define CIH_LEVEL_EXT_MAX	0xffff
+#define CIH_LEVEL_EXT_TAG0	'L'
+#define CIH_LEVEL_EXT_TAG1	'V'
+
+/* the caller is responsible for level <= CIH_LEVEL_EXT_MAX */
+static inline void
+cih_set_level(content_inode_hdr_t *cih, uint32_t level)
+{
+	if (level <= CIH_LEVEL_LEGACY_MAX) {
+		cih->cih_level = (int32_t)level;
+		cih->cih_level_ext[0] = 0;
+		cih->cih_level_ext[1] = 0;
+		cih->cih_level_ext[2] = 0;
+		cih->cih_level_ext[3] = 0;
+		return;
+	}
+	cih->cih_level = CIH_LEVEL_LEGACY_MAX;
+	cih->cih_level_ext[0] = CIH_LEVEL_EXT_TAG0;
+	cih->cih_level_ext[1] = CIH_LEVEL_EXT_TAG1;
+	cih->cih_level_ext[2] = (char)((level >> 8) & 0xff);
+	cih->cih_level_ext[3] = (char)(level & 0xff);
+}
+
+static inline uint32_t
+cih_get_level(const content_inode_hdr_t *cih)
+{
+	const unsigned char *ext = (const unsigned char *)cih->cih_level_ext;
+	uint32_t level;
+
+	if (cih->cih_level != CIH_LEVEL_LEGACY_MAX ||
+	    ext[0] != CIH_LEVEL_EXT_TAG0 ||
+	    ext[1] != CIH_LEVEL_EXT_TAG1)
+		return (uint32_t)cih->cih_level;
+
+	level = ((uint32_t)ext[2] << 8) | (uint32_t)ext[3];
+	return level > CIH_LEVEL_LEGACY_MAX ? level : CIH_LEVEL_LEGACY_MAX;
+}
+
 
 /* timestruct_t - time structure
  *
diff --git a/dump/content.c b/dump/content.c
index 6462267..acea33a 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -75,10 +75,14 @@
  */
 #define ULONGLONG_MAX	18446744073709551615LLU
 
-/* legal range of dump levels
+/* legal range of dump levels: bounded by what the inventory can record
+ * and by what the media file header can carry (see content_inode.h)
  */
 #define LEVEL_DEFAULT	0
-#define LEVEL_MAX	9
+#define LEVEL_MAX	INV_LEVEL_MAX
+#if LEVEL_MAX > CIH_LEVEL_EXT_MAX
+#error "LEVEL_MAX does not fit in the media file header"
+#endif
 
 /* ordinary files as big or bigger than this many pages will be
  * preceeded in the dump by enough padding to align the first byte
@@ -660,7 +664,18 @@ content_init(int argc,
 				usage();
 				return BOOL_FALSE;
 			}
-			sc_level = (ix_t)atoi(optarg);
+			{
+				char *endp;
+				unsigned long lvl;
+
+				errno = 0;
+				lvl = strtoul(optarg, &endp, 10);
+				if (!*optarg || *endp || errno ||
+				    lvl > LEVEL_MAX) {
+					lvl = (unsigned long)LEVEL_MAX + 1;
+				}
+				sc_level = (ix_t)lvl;
+			}
 			if (sc_level > LEVEL_MAX) {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument must be "
@@ -1538,7 +1553,7 @@ _("%s is not the root of the filesystem (bind mount?) - use primary mountpoint\n
 	 */
 	assert(sizeof(cwhdrtemplatep->ch_specific) >= sizeof(*scwhdrtemplatep));
 	scwhdrtemplatep->cih_mediafiletype = CIH_MEDIAFILETYPE_DATA;
-	scwhdrtemplatep->cih_level = (int32_t)sc_level;
+	cih_set_level(scwhdrtemplatep, (uint32_t)sc_level);
 	scwhdrtemplatep->cih_dumpattr = CIH_DUMPATTR_INOMAP;
 	if (subtreecnt) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_SUBTREE;
diff --git a/inventory/inventory.h b/inventory/inventory.h
index e81f153..28d0e20 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -64,7 +64,12 @@ typedef uint32_t		inv_version_t;
 #define PR_STRMSONLY 	3
 #define PR_ALL		4
 #define PR_MAXDEPTH	5
-#define PR_MAXLEVEL	255
+#define PR_MAXLEVEL	255	/* -I level= value meaning "any level" */
+
+/* highest dump level a session can be recorded at: sh_level is a byte,
+ * and PR_MAXLEVEL is reserved as the "any level" marker
+ */
+#define INV_LEVEL_MAX	(PR_MAXLEVEL - 1)
 
 /*----------------------------------------------------------------------*/
 /* Inventory                                                            */
diff --git a/man/man8/xfsdump.8 b/man/man8/xfsdump.8
index 7d261ed..362f1e9 100644
--- a/man/man8/xfsdump.8
+++ b/man/man8/xfsdump.8
@@ -125,13 +125,19 @@ preceding the source filesystem specification)
 is specified.
 .TP 5
 \f3\-l\f1 \f2level\f1
-Specifies a dump level of 0 to 9.
+Specifies a dump level of 0 to 254.
 The dump level determines the base dump to which this
 dump is relative.
 The base dump is the most recent dump at a lesser level.
 A level 0 dump is absolute \- all files are dumped.
-A dump level where 1 <= \f2level\f1 <= 9 is referred to as an incremental dump.
+A dump level where 1 <= \f2level\f1 <= 254 is referred to as an incremental dump.
 Only files that have been changed since the base dump are dumped.
+Older versions of
+.B xfsdump
+only accept levels 0 to 9.
+Older versions of
+.BR xfsrestore (8)
+can restore dumps made at higher levels, but report them as level 9.
 Subtree dumps
 (see the
 .B \-s
diff --git a/restore/content.c b/restore/content.c
index 963aa7f..cd9fea2 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -2083,7 +2083,7 @@ content_stream_restore(ix_t thrdix)
 		matchpr = BOOL_FALSE;
 		resumepr = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_RESUME);
 		assert(scrhdrp->cih_level >= 0);
-		level = (ix_t)scrhdrp->cih_level;
+		level = (ix_t)cih_get_level(scrhdrp);
 		baseidp = resumepr
 			  ?
 			  &scrhdrp->cih_resume_id
@@ -2339,7 +2339,7 @@ content_stream_restore(ix_t thrdix)
 		if (!tranp->t_treeinitdonepr) {
 			bool_t fullpr;
 
-			fullpr = (scrhdrp->cih_level
+			fullpr = (cih_get_level(scrhdrp)
 				   ==
 				   0)
 				 &&
@@ -9432,7 +9432,7 @@ display_dump_label(bool_t lockpr,
 
 	assert(scrhdrp->cih_level >= 0);
 	snprintf(level_string, sizeof(level_string), "%u",
-		 (uint)scrhdrp->cih_level);
+		 (uint)cih_get_level(scrhdrp));
 
 	uuid_unparse(grhdrp->gh_dumpid, dump_string_uuid);
 	uuid_unparse(mrhdrp->mh_mediaid, media_string_uuid);
-- 
2.43.0

