Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710712;
	b=tV65QfzGoTAn0tjIk+NHYqRFKaTVPBw/z92PUTbiRO3eMjEZ17bfJPZrXjKm/frigXvR
	 wx4thazHRJY81eosya+fuY9eWZZo7od5aEEXNumZ8lsmH/MCoS2/EnSgp45T+Fpj4REuu
	 F2ZtUhTkFYob+nSVxpY6ZTFPxa1Odiv9N4qqA8AhdgjYiTjs4MrLzYRl13ci8IJyw0LEj
	 JL/VyQ5UizhOg6SZvP5TvXsQfgs/KkEXB50GKkxurL5Xn/Vx1wDZ6A3pr+4LBwFEFbYKV
	 6h11Sc8HxOhss0p8+mOoMSWdwfd4v9fLR2f38TIJyD8uR+9xzUD9h/adRVtrmkmYfzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710712;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KGzjwHEAZHgGuNvnkGGQc49B5rmUiNP/GYLMXhn4QoU=;
	b=43dOkclQ0b6q49x8ia0vpmoSTpsof67ZWixuvWC8jRKhGpVawHR9CPMwpW95+FcwW0lB
	 3JJ7+WdY0r6U45PuV7+W3/y2ji690YGPq83y5fIPRyXokLgr60+SMpXBz8LZfInLlA2rt
	 JTCZ7j2lsozJrEJ4aADp1AywarwPriglSFn05ANxdFTHSmKA5Crrn+WOYDnjPb4nzwrCb
	 HCtQdcwFozAH2u8Q1aoGL9+Hi/huZjkUyYKVmic7xPEIzEnTNAgA+NT3s/klEGkDLBJYI
	 v+Z5Pb6nWwXnnD2488Cm7uzdHBfydQfVpKcSsXWy5hj69VkwzfdxBZslzpBCgWWBSUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VggSOI0O;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C991560A260E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 16:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C991560A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VggSOI0O
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so65579415e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 08:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795710710; x=1796315510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KGzjwHEAZHgGuNvnkGGQc49B5rmUiNP/GYLMXhn4QoU=;
        b=VggSOI0OmzWQ+B+NOfEOlDXYsAgHLvnZVxl/QVk02Hv+V9wmG0EuJMChfaKcBuhvIc
         G3QIl8vZE+pH+aNZyDKt4itPQ7MpKns6ugDNFhcrrqh5xgaJeEVSFts62PBDQk6Zl4HH
         1mztfBi7AKxpXvyEWo+2uUryQdFzvL9lbQf/GnHYZmRBRZn1B3SQsSaW/v6/iWW77BiT
         1cCkWhXwr7qFh0oVDSGAZmG025QM398WOUoRXR+Nabp/EoVp74U6IEqUeXrJ9tqcHntJ
         9FIrnIbWT6ms3/kq+z7R/QHVMLyFnGlHKQyCi1KDzX3tcmVpVqvivj/a+lPGGbh/pg6r
         i0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710710; x=1796315510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KGzjwHEAZHgGuNvnkGGQc49B5rmUiNP/GYLMXhn4QoU=;
        b=lcwM1oWEQzrKbpeQepcvRgAQ0E0VjBL5MGr8BOUe8IssUjOz/zV5yMYBIRSoJZ1AgB
         cQiP9HGBEhE/euXTNrtrGLzZEwvgUvtZ/9Iq8cZn8DpVXF81RGB9xdZrHMNJnSjRWGf7
         0irbEPmzTTc6ynVgY/JoO88lEBwmQy6jAtSDU7oLGfxMG2d1FT+aI/jYXlI7mEbh55dq
         /H7hsJ3CqFiesv0rIJg96YBh6aPSHkXiREGXusWNdzWgx8NaGn7OClOO4OVpmHG/Rq2l
         Gj26BH8YEy3nDotSHh1dVjq7PjksqtkrrBc6TV5g2FWk3S+SBXBvww5GvzOvavhu2i8x
         5T7w==
X-Forwarded-Encrypted: i=1; AL+hErHK0e+Vd3r7WfnVmW+y3Qt/XQ/xLSZGR4R6ZjmEBbj/3wFYUlqK4W6ARLGz6Yhk+/9kzKwjHurzHi0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/oXkJl1LXnCDFndPIDCjtpwX7CuP1hZRKTDgW4kU+BA0SNjqNJ
	FdNsHzZQx5UEnuLqoJAZOz13/Ac0nAE5zoTn7Bpqcc6hkO3i6niUSqVt3eMFWxzEenw=
X-Gm-Gg: AZFdTZeIO/Sy7ob9OuJaumFAjZsdoyckRSRkmY3lu95RwDcd/ZSCkMShVmcFmjfGhJK
	njEoxrx59D8qIHjetA1PJlGW4ayWjA5q2ysGAPDYZ7Go6c/TjRmHgKuiqkOcZy6308QL6YPCV9+
	qF/0sHj+mB55gLfRem1TF4HjROqWUJnbb85M7mwkqM8cF9/IESL+233nimzGvZw+kAVNPJY8wLO
	aj6HSPHokXw9mUc2fzn8YtwD71xkm0kZ2mUcCSH2nmw6Ov0TJPFGswdga2lacMYFakOu32pBHH4
	vVFJMvg416DM3ILkoEEBVTblsRB48a/vUKFNRqLGT1lwU9vQET72w/mAYKdoXtqIUrbITRGJdAf
	BTt6c3IvRUI+QUfWpynKoUa2BlBRUzITMNyEhtjNSdcKWGnn+CDJeLX9d+hu+P4EWv7CNLTTRDu
	Sy3F9FvhHAd8KTAV39Dwz8ZSrg8d0YrEaqXi2om6anlBuWU06G+DQnzKNSe5znM1QQxJXaXQtQV
	h/MXf5bu+7mvICKlqoSZzdetL7mODu82ZHOJFEsuumHjnaNxnuZF14YeCaqbZL+iVPnpVnFI/Qq
	yCCjw4mhHW1BDaZOhPlsPffhpA==
X-Received: by 2002:a05:600c:a087:b0:4a2:5267:3cd4 with SMTP id 5b1f17b1804b1-4bb887c9fbamr459441665e9.3.1795710710022;
        Thu, 26 Nov 2026 08:31:50 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm721964995e9.11.2026.11.26.08.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:49 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Aring <alex.aring@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 3/4] vfs: add xflags mask to fileattr API
Date: Thu, 26 Nov 2026 17:31:13 +0100
Message-ID: <20261126163114.403846-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>
References: <20261126163114.403846-1-koray.fra@gmail.com>
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

Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr, both
__u64 to match fa_xflags' size, and bump FILE_ATTR_SIZE_LATEST to
FILE_ATTR_SIZE_VER1, which is now 40 bytes.

Add equivalent masks and a has_masks selector to struct file_kattr, so
we can know when a user of this API (userspace or filesystem) supports
them.

This lets filesystems advertise their support for specific xflags, like
statx.stx_attributes_mask does, and userspace can specify only which
xflags it wants to change without needing a RMW cycle.

These masks have the following semantics:
- fsx_xflags_rw_mask:
  * for filesystems: advertise which xflags they support changing
  * for userspace:   specify which xflags it wants to modify
- fsx_xflags_ro_mask:
  * for filesystems: advertise which xflags they support only reading
  * for userspace:   ignored

And they should be filled according to the following:
- GET:
  each filesystem that wants to implement this new API fills the masks
  according to its supported read-write and read-only xflags,
  then:
  * for boolean xflags: it fills fsx_xflags with the current on-disk value;
  * for value xflags: it sets the xflag bit to 1 in fsx_xflags and the
    xflag value in the struct field;
- SET:
  userspace fills the rw_mask with the bits of the xflags it wants to
  change, then:
  * for boolean xflags: it provides the xflag value as a bit in fa_xflags;
  * for value xflags: it sets the xflag bit to 1 in fa_xflags and then
    provides the value in the struct field; if the xflag bit is set to 0
    instead, this informs the kernel to unset/clear that value.

Add AT_FILE_ATTR_MASKS at_flags option that userspace needs to pass
(with usize >= FILE_ATTR_SIZE_VER1) in order to be able to use masks,
otherwise legacy RMW semantics are used.

If AT_FILE_ATTR_MASKS is not specified:
- on GET, zero fa_xflags_rw_mask and fa_xflags_ro_mask and strip new
  xflags added in or after VER1, so older programs doing RMW don't pass
  them back;
- on SET, reject non-zero fa_xflags_{rw,ro}_mask with -EINVAL.

If AT_FILE_ATTR_MASKS is specified on SET with fa_xflags_rw_mask = 0,
return early as a no-op after permission and support checks.

To make both legacy and new programs interact correctly with both legacy
and new/upgraded filesystems, add:
- xflags_to_flags() / flags_to_xflags(): use fileattr_fill_*() to
  convert xflags to their flags counterpart and vice-versa;
- fileattr_set_mask_to_legacy() / fileattr_set_legacy_to_mask(): convert
  between legacy read-modify-write API and modern rw_mask/ro_mask API.

Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
the projid using file_[gs]etattr() by leveraging the new masks.
In order to prevent the legacy FS_IOC_FSSETXATTR from accepting
FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
and use it to validate/clamp both the _xflags fields and the masks.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c             | 332 +++++++++++++++++++++++++++++++++----
 include/linux/fileattr.h   |   7 +
 include/uapi/linux/fcntl.h |   6 +
 include/uapi/linux/fs.h    |   7 +-
 4 files changed, 320 insertions(+), 32 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 1687891c526c..35bc2ded2ff8 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -74,6 +74,22 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
 }
 EXPORT_SYMBOL(fileattr_fill_flags);
 
+static u32 flags_to_xflags(u32 flags)
+{
+	struct file_kattr tmp = {};
+
+	fileattr_fill_flags(&tmp, flags);
+	return tmp.fsx_xflags;
+}
+
+static u32 xflags_to_flags(u32 xflags)
+{
+	struct file_kattr tmp = {};
+
+	fileattr_fill_xflags(&tmp, xflags);
+	return tmp.flags;
+}
+
 /**
  * vfs_fileattr_get - retrieve miscellaneous file attributes
  * @dentry:	the object to retrieve from
@@ -102,13 +118,20 @@ EXPORT_SYMBOL(vfs_fileattr_get);
 static void fileattr_to_file_attr(const struct file_kattr *fa,
 				  struct file_attr *fattr)
 {
-	__u32 mask = FS_XFLAGS_MASK;
-
 	memset(fattr, 0, sizeof(struct file_attr));
-	fattr->fa_xflags = fa->fsx_xflags & mask;
+	/* Pass the masks to userspace if underlying fs uses them. */
+	if (fa->has_masks) {
+		fattr->fa_xflags_rw_mask = fa->fsx_xflags_rw_mask &
+					   FS_FILE_ATTR_XFLAGS_MASK;
+		fattr->fa_xflags_ro_mask = fa->fsx_xflags_ro_mask &
+					   FS_FILE_ATTR_XFLAGS_MASK;
+	}
+	fattr->fa_xflags = fa->fsx_xflags & FS_FILE_ATTR_XFLAGS_MASK;
 	fattr->fa_extsize = fa->fsx_extsize;
 	fattr->fa_nextents = fa->fsx_nextents;
 	fattr->fa_projid = fa->fsx_projid;
+	if (fa->fsx_projid)
+		fattr->fa_xflags |= FS_XFLAG_PROJID;
 	fattr->fa_cowextsize = fa->fsx_cowextsize;
 }
 
@@ -141,15 +164,47 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
 static int file_attr_to_fileattr(const struct file_attr *fattr,
 				 struct file_kattr *fa)
 {
-	__u64 mask = FS_XFLAGS_MASK;
+	u64 mask = fa->has_masks ? FS_FILE_ATTR_XFLAGS_MASK : FS_XFLAGS_MASK;
 
 	if (fattr->fa_xflags & ~mask)
 		return -EINVAL;
 
-	fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK);
-	fa->fsx_extsize = fattr->fa_extsize;
-	fa->fsx_projid = fattr->fa_projid;
-	fa->fsx_cowextsize = fattr->fa_cowextsize;
+	if (fa->has_masks) {
+		u64 rw_user_mask = fattr->fa_xflags_rw_mask;
+
+		if (rw_user_mask & ~FS_FILE_ATTR_XFLAGS_MASK)
+			return -EINVAL;
+
+		/*
+		 * Pass xflags clamped to the rw_mask, so the rest of the code
+		 * can assume that if a flag is not in fsx_xflags, it isn't
+		 * being changed.
+		 */
+		fileattr_fill_xflags(fa, fattr->fa_xflags & rw_user_mask);
+		fa->fsx_xflags_rw_mask = rw_user_mask;
+
+		/* Like stated in the comment above, no need to rw_mask check. */
+		if (fa->fsx_xflags & (FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT))
+			fa->fsx_extsize = fattr->fa_extsize;
+		else
+			fa->fsx_extsize = 0;
+
+		if (fa->fsx_xflags & FS_XFLAG_PROJID)
+			fa->fsx_projid = fattr->fa_projid;
+		else
+			fa->fsx_projid = 0;
+
+		if (fa->fsx_xflags & FS_XFLAG_COWEXTSIZE)
+			fa->fsx_cowextsize = fattr->fa_cowextsize;
+		else
+			fa->fsx_cowextsize = 0;
+	} else {
+		fileattr_fill_xflags(fa,
+				     fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK);
+		fa->fsx_extsize = fattr->fa_extsize;
+		fa->fsx_projid = fattr->fa_projid;
+		fa->fsx_cowextsize = fattr->fa_cowextsize;
+	}
 
 	return 0;
 }
@@ -185,13 +240,23 @@ static int fileattr_set_prepare(struct inode *inode,
 			      const struct file_kattr *old_ma,
 			      struct file_kattr *fa)
 {
+	u32 rw_user_mask = fa->has_masks ?
+			   fa->fsx_xflags_rw_mask : FS_FILE_ATTR_XFLAGS_MASK;
+	u32 changed = 0;
 	int err;
 
+	/* Make sure that no filesystem ro flags have been passed as rw */
+	if (fa->has_masks && (rw_user_mask & ~old_ma->fsx_xflags_rw_mask))
+		return -EOPNOTSUPP;
+
+	/* Use the changed flags, clamped to only the requested ones. */
+	changed = (fa->fsx_xflags ^ old_ma->fsx_xflags) & rw_user_mask;
+
 	/*
 	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
 	 * the relevant capability.
 	 */
-	if ((fa->flags ^ old_ma->flags) & (FS_APPEND_FL | FS_IMMUTABLE_FL) &&
+	if (changed & (FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE) &&
 	    !capable(CAP_LINUX_IMMUTABLE))
 		return -EPERM;
 
@@ -204,21 +269,21 @@ static int fileattr_set_prepare(struct inode *inode,
 	 * namespace. Enforce that restriction only if we are trying to change
 	 * the quota ID state. Everything else is allowed in user namespaces.
 	 */
-	if (current_user_ns() != &init_user_ns) {
-		if (old_ma->fsx_projid != fa->fsx_projid)
-			return -EINVAL;
-		if ((old_ma->fsx_xflags ^ fa->fsx_xflags) &
-				FS_XFLAG_PROJINHERIT)
+	if ((rw_user_mask & FS_XFLAG_PROJID) &&
+	    old_ma->fsx_projid != fa->fsx_projid) {
+		/* Caller is not allowed to change the project ID. */
+		if (current_user_ns() != &init_user_ns)
 			return -EINVAL;
-	} else {
 		/*
 		 * Caller is allowed to change the project ID. If it is being
 		 * changed, make sure that the new value is valid.
 		 */
-		if (old_ma->fsx_projid != fa->fsx_projid &&
-		    !projid_valid(make_kprojid(&init_user_ns, fa->fsx_projid)))
+		if (!projid_valid(make_kprojid(&init_user_ns, fa->fsx_projid)))
 			return -EINVAL;
 	}
+	if ((changed & FS_XFLAG_PROJINHERIT) &&
+	    current_user_ns() != &init_user_ns)
+		return -EINVAL;
 
 	/* Check extent size hints. */
 	if ((fa->fsx_xflags & FS_XFLAG_EXTSIZE) && !S_ISREG(inode->i_mode))
@@ -250,6 +315,143 @@ static int fileattr_set_prepare(struct inode *inode,
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
 	if (fa->fsx_cowextsize == 0)
 		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
+	/*
+	 * No need for projid here, because
+	 *  (xflags & PROJID) && (rw_user_mask & PROJID) && fsx_projid == 0
+	 * gives the same result as
+	 * !(xflags & PROJID) && (rw_user_mask & PROJID) && fsx_projid >= 0.
+	 */
+
+	return 0;
+}
+
+/*
+ * Convert legacy RMW input format without masks, coming from userspace, to new
+ * input format with masks, for filesystems that already support masks.
+ */
+static int fileattr_set_legacy_to_mask(struct file_kattr *fa,
+				       struct file_kattr *old_ma)
+{
+	u32 changed = 0;
+	u32 new_rw_mask = 0;
+	u32 new_xflags = 0;
+
+	if (fa->flags_valid) {
+		/*
+		 * Assume that if the filesystem supports masks it supports its
+		 * writable FS_*_FL flags via FS_XFLAG_* and fsx_xflags_rw_mask.
+		 */
+		changed = fa->flags ^ old_ma->flags;
+		if (changed & ~xflags_to_flags(old_ma->fsx_xflags_rw_mask))
+			return -EOPNOTSUPP;
+
+		changed = flags_to_xflags(changed);
+	} else { /* if (fa->fsx_valid) */
+		changed = fa->fsx_xflags ^ old_ma->fsx_xflags;
+		changed &= FS_XFLAGS_MASK & ~FS_XFLAG_RDONLY_MASK;
+	}
+
+	new_xflags = fa->fsx_xflags;
+
+	new_rw_mask = changed;
+
+	if (fa->fsx_valid) {
+		if (fa->fsx_extsize != old_ma->fsx_extsize)
+			new_rw_mask |= new_xflags &
+				(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
+
+		if (fa->fsx_projid != old_ma->fsx_projid) {
+			new_rw_mask |= FS_XFLAG_PROJID;
+			if (fa->fsx_projid > 0)
+				new_xflags |= FS_XFLAG_PROJID;
+		}
+
+		if ((new_xflags & FS_XFLAG_COWEXTSIZE) &&
+		    (fa->fsx_cowextsize != old_ma->fsx_cowextsize))
+			new_rw_mask |= FS_XFLAG_COWEXTSIZE;
+	}
+
+	/* Make sure we're only setting the wanted bits. */
+	new_xflags &= new_rw_mask;
+
+	/* Mask aware filesystems shouldn't use fa->flags, but just to be sure. */
+	fa->flags = xflags_to_flags(new_xflags);
+
+	fa->fsx_xflags = new_xflags;
+	fa->fsx_xflags_rw_mask = new_rw_mask;
+	fa->has_masks = true;
+
+	fa->fsx_valid = true;
+	fa->flags_valid = false;
+
+	return 0;
+}
+
+/*
+ * Convert new input format with masks, coming from userspace, to legacy RMW
+ * input format without masks, for filesystems that don't support masks yet.
+ */
+static int fileattr_set_mask_to_legacy(struct file_kattr *fa,
+				       struct file_kattr *old_ma)
+{
+	u32 rw_user_mask = fa->fsx_xflags_rw_mask;
+	u32 new_xflags = fa->fsx_xflags;
+	u32 new_flags = 0;
+	u32 tmp_xflag = 0;
+
+	if (rw_user_mask &
+	    ~((FS_XFLAGS_MASK & ~FS_XFLAG_RDONLY_MASK) | FS_XFLAG_PROJID))
+		return -EOPNOTSUPP;
+
+	/* Do RMW */
+	new_xflags |= old_ma->fsx_xflags & ~rw_user_mask;
+
+	/* RMW filesystems expect to not have any globally read-only flag */
+	new_xflags &= ~FS_XFLAG_RDONLY_MASK;
+
+	new_flags = xflags_to_flags(new_xflags);
+	new_flags |= old_ma->flags & ~FS_COMMON_FL;
+
+	tmp_xflag = FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT;
+	/* User didn't turn on any flag for this field. */
+	if (!(fa->fsx_xflags & tmp_xflag)) {
+		if ((rw_user_mask & tmp_xflag) && !(new_xflags & tmp_xflag)) {
+			/*
+			 * If the user wants to clear one of them and neither
+			 * is set after the RMW above, clear fsx_extsize.
+			 */
+			fa->fsx_extsize = 0;
+		} else {
+			/*
+			 * If the user doesn't want to clear either of them OR
+			 * the other flag is still set after RMW, preserve the
+			 * old value.
+			 */
+			fa->fsx_extsize = old_ma->fsx_extsize;
+		}
+	}
+
+	tmp_xflag = FS_XFLAG_PROJID;
+	if (!(rw_user_mask & tmp_xflag))
+		fa->fsx_projid = old_ma->fsx_projid;
+	else if (!(fa->fsx_xflags & tmp_xflag))
+		fa->fsx_projid = 0;
+	/* Strip projid now that we've used it, old format doesn't have it. */
+	new_xflags &= ~FS_XFLAG_PROJID;
+
+	tmp_xflag = FS_XFLAG_COWEXTSIZE;
+	if (!(rw_user_mask & tmp_xflag))
+		fa->fsx_cowextsize = old_ma->fsx_cowextsize;
+	else if (!(new_xflags & tmp_xflag))
+		fa->fsx_cowextsize = 0;
+
+	fa->flags = new_flags;
+	fa->fsx_xflags = new_xflags;
+	fa->fsx_xflags_rw_mask = 0;
+	fa->has_masks = false;
+
+	fa->fsx_valid = true;
+	fa->flags_valid = false;
 
 	return 0;
 }
@@ -283,20 +485,62 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
 
+	if (fa->has_masks && !fa->fsx_xflags_rw_mask)
+		return 0;
+
 	inode_lock(inode);
 	err = vfs_fileattr_get(dentry, &old_ma);
 	if (err)
 		goto out;
 
-	/* initialize missing bits from old_ma */
+	if (old_ma.has_masks) {
+		old_ma.fsx_xflags_rw_mask &= FS_FILE_ATTR_XFLAGS_MASK;
+		old_ma.fsx_xflags_ro_mask &= FS_FILE_ATTR_XFLAGS_MASK;
+	}
+	old_ma.fsx_xflags &= FS_FILE_ATTR_XFLAGS_MASK;
+
+	/* Convert between formats and initialize missing bits from old_ma */
 	if (fa->flags_valid) {
-		fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
-		fa->fsx_extsize = old_ma.fsx_extsize;
-		fa->fsx_nextents = old_ma.fsx_nextents;
-		fa->fsx_projid = old_ma.fsx_projid;
-		fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+		if (!old_ma.has_masks) {
+			/* FS_IOC_SETFLAGS */
+			fa->fsx_xflags_rw_mask = 0;
+			fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
+			fa->fsx_extsize = old_ma.fsx_extsize;
+			fa->fsx_nextents = old_ma.fsx_nextents;
+			fa->fsx_projid = old_ma.fsx_projid;
+			fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+		} else {
+			err = fileattr_set_legacy_to_mask(fa, &old_ma);
+			if (err)
+				goto out;
+		}
+	} else if (!fa->has_masks) {
+		if (!old_ma.has_masks) {
+			/* FS_IOC_FSSETXATTR / file_attr VER0 */
+			fa->flags |= old_ma.flags & ~FS_COMMON_FL;
+		} else {
+			err = fileattr_set_legacy_to_mask(fa, &old_ma);
+			if (err)
+				goto out;
+		}
 	} else {
-		fa->flags |= old_ma.flags & ~FS_COMMON_FL;
+		/* file_attr VER1 */
+		if (old_ma.has_masks) {
+			/*
+			 * Don't preserve non-common flags since filesystems
+			 * with masks only use xflags
+			 */
+		} else {
+			/*
+			 * Filesystem doesn't support _mask API yet, switch to
+			 * old rmw format.
+			 * PROJID is supported like the legacy masks, but will
+			 * be stripped during conversion.
+			 */
+			err = fileattr_set_mask_to_legacy(fa, &old_ma);
+			if (err)
+				goto out;
+		}
 	}
 
 	err = fileattr_set_prepare(inode, &old_ma, fa);
@@ -390,7 +634,8 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	BUILD_BUG_ON(sizeof(struct file_attr) < FILE_ATTR_SIZE_VER0);
 	BUILD_BUG_ON(sizeof(struct file_attr) != FILE_ATTR_SIZE_LATEST);
 
-	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((at_flags &
+	     ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_FILE_ATTR_MASKS)) != 0)
 		return -EINVAL;
 
 	if (!(at_flags & AT_SYMLINK_NOFOLLOW))
@@ -399,7 +644,10 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	if (usize > PAGE_SIZE)
 		return -E2BIG;
 
-	if (usize < FILE_ATTR_SIZE_VER0)
+	if (usize != FILE_ATTR_SIZE_VER0 && usize < FILE_ATTR_SIZE_VER1)
+		return -EINVAL;
+
+	if ((at_flags & AT_FILE_ATTR_MASKS) && usize < FILE_ATTR_SIZE_VER1)
 		return -EINVAL;
 
 	CLASS(filename_maybe_null, name)(filename, at_flags);
@@ -424,6 +672,17 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 		return error;
 
 	fileattr_to_file_attr(&fa, &fattr);
+	/*
+	 * Caller doesn't know about masks, so it also doesn't know about
+	 * xflags added in or after VER1.
+	 * Zero out the masks and strip VER1+ xflags.
+	 */
+	if (!(at_flags & AT_FILE_ATTR_MASKS)) {
+		fattr.fa_xflags &= FS_XFLAGS_MASK;
+		fattr.fa_xflags_rw_mask = 0;
+		fattr.fa_xflags_ro_mask = 0;
+	}
+
 	error = copy_struct_to_user(ufattr, usize, &fattr,
 				    sizeof(struct file_attr), NULL);
 
@@ -443,7 +702,8 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	BUILD_BUG_ON(sizeof(struct file_attr) < FILE_ATTR_SIZE_VER0);
 	BUILD_BUG_ON(sizeof(struct file_attr) != FILE_ATTR_SIZE_LATEST);
 
-	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((at_flags &
+	     ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_FILE_ATTR_MASKS)) != 0)
 		return -EINVAL;
 
 	if (!(at_flags & AT_SYMLINK_NOFOLLOW))
@@ -452,7 +712,10 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (usize > PAGE_SIZE)
 		return -E2BIG;
 
-	if (usize < FILE_ATTR_SIZE_VER0)
+	if (usize != FILE_ATTR_SIZE_VER0 && usize < FILE_ATTR_SIZE_VER1)
+		return -EINVAL;
+
+	if ((at_flags & AT_FILE_ATTR_MASKS) && usize < FILE_ATTR_SIZE_VER1)
 		return -EINVAL;
 
 	error = copy_struct_from_user(&fattr, sizeof(struct file_attr), ufattr,
@@ -460,9 +723,9 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 	if (error)
 		return error;
 
-	error = file_attr_to_fileattr(&fattr, &fa);
-	if (error)
-		return error;
+	if (!(at_flags & AT_FILE_ATTR_MASKS) &&
+	    (fattr.fa_xflags_rw_mask || fattr.fa_xflags_ro_mask))
+		return -EINVAL;
 
 	CLASS(filename_maybe_null, name)(filename, at_flags);
 	if (!name && dfd >= 0) {
@@ -479,6 +742,13 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const char __user *, filename,
 			return error;
 	}
 
+	if (at_flags & AT_FILE_ATTR_MASKS)
+		fa.has_masks = true;
+
+	error = file_attr_to_fileattr(&fattr, &fa);
+	if (error)
+		return error;
+
 	error = mnt_want_write(filepath.mnt);
 	if (!error) {
 		error = vfs_fileattr_set(mnt_idmap(filepath.mnt),
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 09e32b84e02a..725efac15e76 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -35,6 +35,10 @@
 	(FS_XFLAG_COMMON | FS_XFLAG_RDONLY_MASK | FS_XFLAG_VALUES_MASK | \
 	 FS_XFLAG_DIRONLY_MASK | FS_XFLAG_MISC_MASK)
 
+/* Flags only for fa_ fields */
+#define FS_FILE_ATTR_XFLAGS_MASK \
+	(FS_XFLAGS_MASK | FS_XFLAG_PROJID)
+
 /*
  * Merged interface for miscellaneous file attributes.  'flags' originates from
  * ext* and 'fsx_flags' from xfs.  There's some overlap between the two, which
@@ -45,6 +49,8 @@ struct file_kattr {
 	u32	flags;		/* flags (FS_IOC_GETFLAGS/FS_IOC_SETFLAGS) */
 	/* struct fsxattr: */
 	u32	fsx_xflags;	/* xflags field value (get/set) */
+	u32	fsx_xflags_rw_mask; /* supported writeable xflags (get) / flags to set (set) */
+	u32	fsx_xflags_ro_mask; /* supported read-only xflags (get) */
 	u32	fsx_extsize;	/* extsize field value (get/set)*/
 	u32	fsx_nextents;	/* nextents field value (get)	*/
 	u32	fsx_projid;	/* project identifier (get/set) */
@@ -52,6 +58,7 @@ struct file_kattr {
 	/* selectors: */
 	bool	flags_valid:1;
 	bool	fsx_valid:1;
+	bool	has_masks:1;
 };
 
 int copy_fsxattr_to_user(const struct file_kattr *fa, struct fsxattr __user *ufa);
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index e43e3de3e9ee..a6ecca6f5e63 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -191,4 +191,10 @@ struct delegation {
 #define AT_EXECVE_CHECK		0x10000	/* Only perform a check if execution
 					   would be allowed. */
 
+/* Flags for file_getattr(2) / file_setattr(2). */
+#define AT_FILE_ATTR_MASKS	0x001	/* Advertise knowing and being able to
+					   handle the struct file_attr fields
+					   fa_xflags_rw_mask and
+					   fa_xflags_ro_mask */
+
 #endif /* _UAPI_LINUX_FCNTL_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a13c7b32a1bd..63d88ebe3420 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -238,10 +238,13 @@ struct file_attr {
 	__u32 fa_nextents;	/* nextents field value (get)   */
 	__u32 fa_projid;	/* project identifier (get/set) */
 	__u32 fa_cowextsize;	/* CoW extsize field value (get/set) */
+	__u64 fa_xflags_rw_mask;/* supported writeable xflags (get) / flags to set (set) */
+	__u64 fa_xflags_ro_mask;/* supported read-only xflags (get) */
 };
 
 #define FILE_ATTR_SIZE_VER0 24
-#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
+#define FILE_ATTR_SIZE_VER1 40
+#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
 
 /*
  * Flags for the fsx_xflags field
@@ -270,6 +273,8 @@ struct file_attr {
  */
 #define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
 #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
+#define FS_XFLAG_PROJID		0x00100000	/* project ID */
+
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.56.0

