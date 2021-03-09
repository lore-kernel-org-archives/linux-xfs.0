Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AD7C43332
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F826529C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhCIEjh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhCIEjf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D69F665275;
        Tue,  9 Mar 2021 04:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264774;
        bh=/TdeTTMPrzpHzqenNLnOVX7tKgg8odoXiyJ+FC5FdNY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CAZTCJTHteDWGlrxq5k6WJtiZN1k73b70S3k8vQEoXz58ZsT9DvccWyxl89dhIE64
         E/ejOqhmbBUcpaVZ3ET6B7SiLn/1bsafS1WtPNllAeOv7R5/+uDnvbrixBoCvwiM1r
         bor0LEBZyYNCm8TT7uU67pYeHKp+MXLtk1OaTc8aA8spmToEgFZtoYMgdwgTVYgWhf
         W6JuetDoOia/ApG2TJvvB0UOILLIBPn7rcRJsP+Kuv/09on3OFJfyy6JW4M1g13u9K
         krTlKuKt3v9EEYD+U17NKv8HbNYgSoxv5z1EfosgZMliN4DCnqFYLYnlvmv3+W5azl
         +VKWgBn+UTnwg==
Subject: [PATCH 1/2] fsstress: get rid of attr_list
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:34 -0800
Message-ID: <161526477474.1212985.14857729520784229723.stgit@magnolia>
In-Reply-To: <161526476928.1212985.15718497220408703599.stgit@magnolia>
References: <161526476928.1212985.15718497220408703599.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

attr_list is deprecated, so just call llistxattr directly.  This is a
bit involved, since attr_remove_f was highly dependent on libattr
structures.  Note that attr_list uses llistxattr internally and
llistxattr is limited to XATTR_LIST_MAX, so this doesn't result in any
loss of functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsstress.c |   80 ++++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 43 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 73751935..10c27a7d 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -394,7 +394,7 @@ struct print_string	flag_str = {0};
 
 void	add_to_flist(int, int, int, int);
 void	append_pathname(pathname_t *, char *);
-int	attr_list_path(pathname_t *, char *, const int, int, attrlist_cursor_t *);
+int	attr_list_path(pathname_t *, char *, const int);
 int	attr_remove_path(pathname_t *, const char *);
 int	attr_set_path(pathname_t *, const char *, const char *, const int);
 void	check_cwd(void);
@@ -868,28 +868,36 @@ append_pathname(pathname_t *name, char *str)
 	name->len += len;
 }
 
+int
+attr_list_count(char *buffer, int buffersize)
+{
+	char *p = buffer;
+	char *end = buffer + buffersize;
+	int count = 0;
+
+	while (p < end && *p != 0) {
+		count++;
+		p += strlen(p) + 1;
+	}
+
+	return count;
+}
+
 int
 attr_list_path(pathname_t *name,
 	       char *buffer,
-	       const int buffersize,
-	       int flags,
-	       attrlist_cursor_t *cursor)
+	       const int buffersize)
 {
 	char		buf[NAME_MAX + 1];
 	pathname_t	newname;
 	int		rval;
 
-	if (flags != ATTR_DONTFOLLOW) {
-		errno = EINVAL;
-		return -1;
-	}
-
-	rval = attr_list(name->path, buffer, buffersize, flags, cursor);
+	rval = llistxattr(name->path, buffer, buffersize);
 	if (rval >= 0 || errno != ENAMETOOLONG)
 		return rval;
 	separate_pathname(name, buf, &newname);
 	if (chdir(buf) == 0) {
-		rval = attr_list_path(&newname, buffer, buffersize, flags, cursor);
+		rval = attr_list_path(&newname, buffer, buffersize);
 		assert(chdir("..") == 0);
 	}
 	free_pathname(&newname);
@@ -2313,32 +2321,24 @@ aread_f(int opno, long r)
 void
 attr_remove_f(int opno, long r)
 {
-	attrlist_ent_t		*aep;
-	attrlist_t		*alist;
-	char			*aname;
-	char			buf[4096];
-	attrlist_cursor_t	cursor;
+	char			*bufname;
+	char			*bufend;
+	char			*aname = NULL;
+	char			buf[XATTR_LIST_MAX];
 	int			e;
 	int			ent;
 	pathname_t		f;
-	int			total;
+	int			total = 0;
 	int			v;
 	int			which;
 
 	init_pathname(&f);
 	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
 		append_pathname(&f, ".");
-	total = 0;
-	bzero(&cursor, sizeof(cursor));
-	do {
-		bzero(buf, sizeof(buf));
-		e = attr_list_path(&f, buf, sizeof(buf), ATTR_DONTFOLLOW, &cursor);
-		check_cwd();
-		if (e)
-			break;
-		alist = (attrlist_t *)buf;
-		total += alist->al_count;
-	} while (alist->al_more);
+	e = attr_list_path(&f, buf, sizeof(buf));
+	check_cwd();
+	if (e > 0)
+		total = attr_list_count(buf, e);
 	if (total == 0) {
 		if (v)
 			printf("%d/%d: attr_remove - no attrs for %s\n",
@@ -2346,25 +2346,19 @@ attr_remove_f(int opno, long r)
 		free_pathname(&f);
 		return;
 	}
+
 	which = (int)(random() % total);
-	bzero(&cursor, sizeof(cursor));
+	bufname = buf;
+	bufend = buf + e;
 	ent = 0;
-	aname = NULL;
-	do {
-		bzero(buf, sizeof(buf));
-		e = attr_list_path(&f, buf, sizeof(buf), ATTR_DONTFOLLOW, &cursor);
-		check_cwd();
-		if (e)
-			break;
-		alist = (attrlist_t *)buf;
-		if (which < ent + alist->al_count) {
-			aep = (attrlist_ent_t *)
-				&buf[alist->al_offset[which - ent]];
-			aname = aep->a_name;
+	while (bufname < bufend) {
+		if (which < ent) {
+			aname = bufname;
 			break;
 		}
-		ent += alist->al_count;
-	} while (alist->al_more);
+		ent++;
+		bufname += strlen(bufname) + 1;
+	}
 	if (aname == NULL) {
 		if (v)
 			printf(

