Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935743AbeFRT3s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jun 2018 15:29:48 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 985CB30820C5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jun 2018 19:29:48 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B3325B681
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jun 2018 19:29:48 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs: explicitly warn about unknown token failures
Message-ID: <1b2f2674-d6ef-4354-057e-f476ac2e2a83@redhat.com>
Date: Mon, 18 Jun 2018 14:29:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Rather than a generic "Error parsing line" for an unknown token
within a section, issue a more helpful error message, i.e.

[data]
foo=1

would yield:

Invalid token in section [data] at line /etc/xfs/mkfs/default:2 : foo

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I may make one more pass over all these error messages because they seem
a little hard to parse, but for now this matches the others, in general.

i.e. i'd rather have:

Invalid section "[splat]" at /etc/xfs/mkfs/default:1
...
Invalid token "foo" in section [data] at /etc/xfs/mkfs/default:2

or something like that, but I'll try to make any textual changes file-wide
if they seem warranted.

diff --git a/mkfs/config.c b/mkfs/config.c
index 9954691..70d752c 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -466,9 +466,6 @@ _("No section specified yet on line %s:%zu : %s\n"),
 			 */
 			snprintf(p, len, "%s=%lu", tag, value);
 
-			/* Not needed anymore */
-			free(tag);
-
 			/*
 			 * We only use getsubopt() to validate the possible
 			 * subopt, we already parsed the value and its already
@@ -476,6 +473,16 @@ _("No section specified yet on line %s:%zu : %s\n"),
 			 */
 			subopt = getsubopt(&p, (char **) confopt->subopts,
 					   &ignore_value);
+			if (subopt == -1) {
+				errno = EINVAL;
+				fprintf(stderr,
+_("Invalid token in section [%s] at line %s:%zu : %s\n"),
+					confopt->name, config_file, lineno, tag);
+				goto out_free_tag;
+			}
+
+			/* Not needed anymore */
+			free(tag);
 
 			ret = confopt->parser(dft, subopt, value);
 			if (ret) {

