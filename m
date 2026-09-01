Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EBA361959;
	Tue,  1 Sep 2026 12:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264892; cv=none; b=XLGLYsNW79U7/Fgqyytt+lADUfGoJiYUBXY5G4RLoIv8AfvAP18aSdQ8jFkm0+vQA1IIxtRAEx5SdEciTfUru5qT1knr4Qes1FEZ1ha0L8bGrISPHohCK0u7asG2U9/O6osenDCaHRlhKZ/mdBZoOeJa1c3uNZdaZ7zL9GDx7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264892; c=relaxed/simple;
	bh=GYscaWe/jMisSZXOKQrutqJ86cvJ20zKEIu+UCCVV7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eOJ8YbiMmeIW318n28240cFHIGVnjcmuVkg/R/4WdeTVMbZasBgygj7pEd80vwEony+o5+2T7K0GsMLE57dDnREgRXmbR9up31tTpT1fmX8opfetxuMgIlgwak7WcvOlp3kz2CweiW73bF7m06dWSGi7yyarwN7dLep2/ZEKZp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/LPFdoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/LPFdoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2671F00ACF;
	Tue,  1 Sep 2026 12:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264890;
	bh=JuRAzGktmajwKmYRzWjalnJ46VpXp9DXMRrpTvcYt6c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E/LPFdoq222DhSh0yXR2ky5KZADgQDjF+ap4TKVbpb2PCHDl2Va512MXsStEJginy
	 BcvbIPZmEHgcqXovFn8FERfHX5v66+XnIEq1dZXSslmeL0SNIVzOsWeYezKJqsx/no
	 uRg3n601BgNWmG4XBeYq2ozKPCpKUTut6BN6EtIzXRMSxT/97rLkPvexRAogFaAyz3
	 6yzhpnNL4i77SYRFPn8sPWFi9tyXYsGpiP3zuwB9scEDyG7u0KnSR+xx/zH7YVSzyb
	 N05bCWeFMBfyFfAsb+tCshva7C5PU62EDdEfwMo6COjQOLntAaIiU19chpKZEUqyit
	 IeDe96jJ7MyWw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:26 +0200
Subject: [PATCH 01/27] userns: pass const uid_gid_map in lookup helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-1-54ccd48e100b@kernel.org>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org, 
 Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, 
 Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=5460; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GYscaWe/jMisSZXOKQrutqJ86cvJ20zKEIu+UCCVV7s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7imNdWzLPH1JcW3F9/c5fixzrNx0ewg6/UzprxO4
 S48OFllbkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBElL4wMjzu4rE6kyfKvPtT
 kbTJNDNJt3vBuYKOO99FBgfWrj3x5QjD/zzh/63RU3QznstOva7kuXYFj9+FxVuu/s27vN73oiN
 HIzsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

map_id_down(), map_id_up() and map_id_range_up() search the extents
of an idmapping and never modify it. Let all relevant helpers pass a
const struct uid_gid_map. Callers can now pass pass struct mnt_idmap as
const and pass down &idmap->uid_map and &idmap->gid_map.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/uidgid.h  | 12 ++++++------
 kernel/user_namespace.c | 28 ++++++++++++++--------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 2dc767e08f54..02403629b49f 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -130,9 +130,9 @@ static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 	return from_kgid(ns, gid) != (gid_t) -1;
 }
 
-u32 map_id_down(struct uid_gid_map *map, u32 id);
-u32 map_id_up(struct uid_gid_map *map, u32 id);
-u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count);
+u32 map_id_down(const struct uid_gid_map *map, u32 id);
+u32 map_id_up(const struct uid_gid_map *map, u32 id);
+u32 map_id_range_up(const struct uid_gid_map *map, u32 id, u32 count);
 
 #else
 
@@ -182,17 +182,17 @@ static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 	return gid_valid(gid);
 }
 
-static inline u32 map_id_down(struct uid_gid_map *map, u32 id)
+static inline u32 map_id_down(const struct uid_gid_map *map, u32 id)
 {
 	return id;
 }
 
-static inline u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
+static inline u32 map_id_range_up(const struct uid_gid_map *map, u32 id, u32 count)
 {
 	return id;
 }
 
-static inline u32 map_id_up(struct uid_gid_map *map, u32 id)
+static inline u32 map_id_up(const struct uid_gid_map *map, u32 id)
 {
 	return id;
 }
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 0bed462e9b2a..55b6bd75624b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -278,8 +278,8 @@ static int cmp_map_id(const void *k, const void *e)
  * map_id_range_down_max - Find idmap via binary search in ordered idmap array.
  * Can only be called if number of mappings exceeds UID_GID_MAP_MAX_BASE_EXTENTS.
  */
-static struct uid_gid_extent *
-map_id_range_down_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
+static const struct uid_gid_extent *
+map_id_range_down_max(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
 {
 	struct idmap_key key;
 
@@ -296,8 +296,8 @@ map_id_range_down_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 cou
  * Can only be called if number of mappings is equal or less than
  * UID_GID_MAP_MAX_BASE_EXTENTS.
  */
-static struct uid_gid_extent *
-map_id_range_down_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
+static const struct uid_gid_extent *
+map_id_range_down_base(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
 {
 	unsigned idx;
 	u32 first, last, id2;
@@ -315,9 +315,9 @@ map_id_range_down_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 co
 	return NULL;
 }
 
-static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
+static u32 map_id_range_down(const struct uid_gid_map *map, u32 id, u32 count)
 {
-	struct uid_gid_extent *extent;
+	const struct uid_gid_extent *extent;
 	unsigned extents = map->nr_extents;
 	smp_rmb();
 
@@ -335,7 +335,7 @@ static u32 map_id_range_down(struct uid_gid_map *map, u32 id, u32 count)
 	return id;
 }
 
-u32 map_id_down(struct uid_gid_map *map, u32 id)
+u32 map_id_down(const struct uid_gid_map *map, u32 id)
 {
 	return map_id_range_down(map, id, 1);
 }
@@ -345,8 +345,8 @@ u32 map_id_down(struct uid_gid_map *map, u32 id)
  * Can only be called if number of mappings is equal or less than
  * UID_GID_MAP_MAX_BASE_EXTENTS.
  */
-static struct uid_gid_extent *
-map_id_range_up_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
+static const struct uid_gid_extent *
+map_id_range_up_base(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
 {
 	unsigned idx;
 	u32 first, last, id2;
@@ -368,8 +368,8 @@ map_id_range_up_base(unsigned extents, struct uid_gid_map *map, u32 id, u32 coun
  * map_id_up_max - Find idmap via binary search in ordered idmap array.
  * Can only be called if number of mappings exceeds UID_GID_MAP_MAX_BASE_EXTENTS.
  */
-static struct uid_gid_extent *
-map_id_range_up_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count)
+static const struct uid_gid_extent *
+map_id_range_up_max(unsigned extents, const struct uid_gid_map *map, u32 id, u32 count)
 {
 	struct idmap_key key;
 
@@ -381,9 +381,9 @@ map_id_range_up_max(unsigned extents, struct uid_gid_map *map, u32 id, u32 count
 		       sizeof(struct uid_gid_extent), cmp_map_id);
 }
 
-u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
+u32 map_id_range_up(const struct uid_gid_map *map, u32 id, u32 count)
 {
-	struct uid_gid_extent *extent;
+	const struct uid_gid_extent *extent;
 	unsigned extents = map->nr_extents;
 	smp_rmb();
 
@@ -401,7 +401,7 @@ u32 map_id_range_up(struct uid_gid_map *map, u32 id, u32 count)
 	return id;
 }
 
-u32 map_id_up(struct uid_gid_map *map, u32 id)
+u32 map_id_up(const struct uid_gid_map *map, u32 id)
 {
 	return map_id_range_up(map, id, 1);
 }

-- 
2.53.0

