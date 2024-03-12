Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3047D3F9
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710259964; cv=none; b=X46uwECWqltY7kBa0+V8Ofy0jZJKByq+wuJYE4THKWBZY+k7sq01TdZrjP8uiUtz6aMNevEqijQTRVePiEsx9ijspZjGLQHAnJeWat62KV3L//1D8+BNZZSNLcWvJRO0eArq/e8te/kFrnpvzvW27dPUTE0mZqBopxaH80QPUhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710259964; c=relaxed/simple;
	bh=dGhsZ8px9E6KxaOQAw2b3U4rGcm4ARU505M1jOxkr2A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VCR9+y92QRY8g24cFt9/bERvSMrnK+HmN/BOm26UY04MNGbADxc+evdpXYgikzZ76zKu0wLriXl3jWO//xP6VsGNYUoYBgzSX2D23HtH7Fo40HbP/55idJGCZOXebAv/UXNZlSg6wBeyJXoWTeKY3mdCRbH/hT2rnyWpVCE+iDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kb1fMth2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kb1fMth2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA11FC433F1;
	Tue, 12 Mar 2024 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710259964;
	bh=dGhsZ8px9E6KxaOQAw2b3U4rGcm4ARU505M1jOxkr2A=;
	h=Date:From:To:Cc:Subject:From;
	b=kb1fMth2qqYx0MWqXjKTP3uwZylBkpHliBHE1EcCluiS1fBpVlNcaystgD0D37IXZ
	 7NhJB0vaSJCdDmdGtOqp4LsQByf7Z4S3JVsUOJXDEkgH/+T12xF3AnlhlJsQGP1DC8
	 olQrYL7PKfAYy9Felb9ygToA2PrqSiqrVOnVydUQ14cHXbS5Pxmk/fYYAE79/62Vzk
	 MSXEk5T1TRcdrVfd2KyH9L0uOrW1vsUi0r9Krng3HzkHgkzqDA9LTJqAoS/QnBi7G7
	 zHm3PnPCJQ8BtQ/CBza15n9Og4vp+3WoUcPXSLddS1z+tT4ZnhF9eUqZCnwFPSztiw
	 d0bKYzi2vezOg==
Date: Tue, 12 Mar 2024 09:12:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] misc: fix string buffer compile warnings
Message-ID: <20240312161242.GA1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix various minor compiler warnings (gcc 12.2, Debian 12):

Widen various char arrays so that we don't get complaints about buffer
overflows when doing snprintf.

Use snprintf over sprintf.

Use memcpy instead of strncpy when copying fixed-width label fields.

Fix an unused variable warning.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/global.c   |    2 +-
 dump/content.c    |    4 ++--
 invutil/fstab.c   |    2 +-
 invutil/invidx.c  |    4 ++--
 invutil/menu.c    |    2 +-
 invutil/stobj.c   |    6 +++---
 restore/content.c |    5 ++---
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/common/global.c b/common/global.c
index 6a4e348..53fb4e0 100644
--- a/common/global.c
+++ b/common/global.c
@@ -82,7 +82,7 @@ global_hdr_alloc(int argc, char *argv[])
 
 	/* fill in the magic number
 	 */
-	strncpy(ghdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ);
+	memcpy(ghdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ);
 
 	/* fill in the hdr version
 	 */
diff --git a/dump/content.c b/dump/content.c
index 6462267..a0d3a84 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -6348,7 +6348,7 @@ static bool_t
 Media_prompt_erase(drive_t *drivep)
 {
 	fold_t fold;
-	char question[100];
+	char question[256];
 	char *preamblestr[PREAMBLEMAX];
 	size_t preamblecnt;
 	char *querystr[QUERYMAX];
@@ -6375,7 +6375,7 @@ Media_prompt_erase(drive_t *drivep)
 
 	/* query: ask if overwrite ok
 	 */
-	sprintf(question,
+	snprintf(question, sizeof(question),
 		 "pre-erase (-%c) option specified "
 		 "and non-blank media encountered:\n"
 		 "please confirm media erase "
diff --git a/invutil/fstab.c b/invutil/fstab.c
index 88d849e..56132e1 100644
--- a/invutil/fstab.c
+++ b/invutil/fstab.c
@@ -149,7 +149,7 @@ fstab_select(WINDOW *win, node_t *current, node_t *list)
 int
 fstab_highlight(WINDOW *win, node_t *current, node_t *list)
 {
-    static char txt[256];
+    static char txt[512];
     char uuidstr[UUID_STR_LEN + 1];
     data_t *d;
     invt_fstab_t *fstabentry;
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 5874e8d..0fb55c5 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -115,7 +115,7 @@ invidx_commit(WINDOW *win, node_t *current, node_t *list)
 	struct stat s;
 	char dst_stobjfile[MAXPATHLEN];
 	char *stobjfile;
-	char cmd[1024];
+	char cmd[(MAXPATHLEN * 2) + 16];
 
 	snprintf(dst_idxfile, sizeof(dst_idxfile), "%s/%s", inventory_path, basename(invidx_file[fidx].name));
 
@@ -688,7 +688,7 @@ invidx_select(WINDOW *win, node_t *current, node_t *list)
 int
 invidx_highlight(WINDOW *win, node_t *current, node_t *list)
 {
-    static char txt[256];
+    static char txt[512];
     data_t *d;
     invt_entry_t *invtentry;
 
diff --git a/invutil/menu.c b/invutil/menu.c
index 81baa42..89a350c 100644
--- a/invutil/menu.c
+++ b/invutil/menu.c
@@ -101,7 +101,7 @@ menu(WINDOW *win, int line, int col, node_t *list, int keyc, menukey_t *keyv)
     int c;
     int k;
     int quit;
-    char txt[256];
+    char txt[512];
     node_t *current;
     node_t *last;
     data_t *d;
diff --git a/invutil/stobj.c b/invutil/stobj.c
index 2912e0c..852f160 100644
--- a/invutil/stobj.c
+++ b/invutil/stobj.c
@@ -171,7 +171,7 @@ stobjsess_commit(WINDOW *win, node_t *current, node_t *list)
 int
 stobjsess_highlight(WINDOW *win, node_t *current, node_t *list)
 {
-    static char txt[256];
+    static char txt[512];
     char uuidstr[UUID_STR_LEN + 1];
     data_t *d;
     invt_seshdr_t *stobjhdr;
@@ -210,7 +210,7 @@ stobjsess_highlight(WINDOW *win, node_t *current, node_t *list)
 int
 stobjstrm_highlight(WINDOW *win, node_t *current, node_t *list)
 {
-    static char txt[256];
+    static char txt[512];
     data_t *d;
     invt_stream_t *stobjstrm;
 
@@ -246,7 +246,7 @@ stobjstrm_highlight(WINDOW *win, node_t *current, node_t *list)
 int
 stobjmed_highlight(WINDOW *win, node_t *current, node_t *list)
 {
-    static char txt[256];
+    static char txt[512];
     char uuidstr[UUID_STR_LEN + 1];
     data_t *d;
     invt_mediafile_t *stobjmed;
diff --git a/restore/content.c b/restore/content.c
index 7ec3a4d..5536411 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -5077,7 +5077,7 @@ pi_insertfile(ix_t drivecnt,
 	     &&
 	     ! DH2O(objh)->o_idlabvalpr) {
 		uuid_copy(DH2O(objh)->o_id, *mediaidp);
-		strncpy(DH2O(objh)->o_lab,
+		memcpy(DH2O(objh)->o_lab,
 			 medialabel,
 			 sizeof(DH2O(objh)->o_lab));
 		DH2O(objh)->o_idlabvalpr = BOOL_TRUE;
@@ -5107,7 +5107,7 @@ pi_insertfile(ix_t drivecnt,
 	     &&
 	     ! DH2O(prevobjh)->o_idlabvalpr) {
 		uuid_copy(DH2O(prevobjh)->o_id, *prevmediaidp);
-		strncpy(DH2O(prevobjh)->o_lab,
+		memcpy(DH2O(prevobjh)->o_lab,
 			       prevmedialabel,
 			       sizeof(DH2O(prevobjh)->o_lab));
 		DH2O(prevobjh)->o_idlabvalpr = BOOL_TRUE;
@@ -8632,7 +8632,6 @@ restore_extattr(drive_t *drivep,
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	extattrhdr_t *ahdrp = (extattrhdr_t *)get_extattrbuf(drivep->d_index);
-	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	bool_t isfilerestored = BOOL_FALSE;
 
