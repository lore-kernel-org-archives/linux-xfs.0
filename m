Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2445C64ED6
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Feb 2023 16:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjB1Qjm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 11:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjB1Qjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 11:39:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCD0A7
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 08:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677602316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9dthIMzBNkPFVPpbUDA0OPOiUirpGj3a9CchKP8gPIU=;
        b=d2+WOVXLDl7pPayLq4QZklnAol/dML2A8RdfNgq9/07EJjRfFVJ9q+0DEK7m/eB/CA4BFr
        isqAHnm9s8cDOsiSuLSo6khVVANSrYcwX0NfNnoIqOfP7225BN+ig7NwSAt5FU8Hy0rIgz
        L/pIzrqC8CuH9FCY08BmiSpkKrlWsA8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-9ut1CI2fPs-mZFizt81eXA-1; Tue, 28 Feb 2023 11:38:35 -0500
X-MC-Unique: 9ut1CI2fPs-mZFizt81eXA-1
Received: by mail-wm1-f71.google.com with SMTP id e22-20020a05600c219600b003e000facbb1so7113613wme.9
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 08:38:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677602314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9dthIMzBNkPFVPpbUDA0OPOiUirpGj3a9CchKP8gPIU=;
        b=mT1olqkWmr+h3pfzfwBNjSSn+q4ytpCssp+ZzkmYZHFIem4ElnjE50YoxEP7t33KRf
         W0igaXDECqPpN+r3ME0VUQx7lVjBj5BEXSTS+9wjNxE1dOblppq0DvDn28TPxsFw1c/F
         KLJOt7UCqQiFjFaIyhsSM6xx0n8OfjQnJ1hZTPgEf+K6l9x6IyZZnaepfPCaoiigmhrq
         jF9NTZwcPgxg0vVak+xgmLEpay/q+33YuxCmUAmZyO9T7Kbp0p5dPXaeNRBwrAwUDCTR
         /jCQp8uWAZPsNI9gYzt08j5LpgUVvpF7zom3xAh3hZpQZ3pDpZEOBDm/adCqcTFqHBb5
         p0MQ==
X-Gm-Message-State: AO0yUKX83J9ec38KrSlqsWCKOA684ml5o955GfnA/cb0/uc7Jf53j/xG
        Zyo7DOfFZ3tfTLooYLjSk9wtD13rPIERXCSm5nvywIBjjlbyohIA7d/4wkCZogmwiNad2a68t1/
        Y0FzUqFf3qjPVMOTlDd/7Xb42YRBUZ1QkCesuEqGWahrVEjDUph1fjPho28cG919j7RqwsXFhOV
        lr
X-Received: by 2002:a05:600c:181b:b0:3dc:4fd7:31f7 with SMTP id n27-20020a05600c181b00b003dc4fd731f7mr2606820wmp.41.1677602314248;
        Tue, 28 Feb 2023 08:38:34 -0800 (PST)
X-Google-Smtp-Source: AK7set9jiU6jyyl/PFQP4WdO/aknOJSdcU8u6Iy7xsjVE0bjhTvma2T5IsgV/gfdPObLOLrDy7bRbQ==
X-Received: by 2002:a05:600c:181b:b0:3dc:4fd7:31f7 with SMTP id n27-20020a05600c181b00b003dc4fd731f7mr2606805wmp.41.1677602313921;
        Tue, 28 Feb 2023 08:38:33 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id t10-20020a05600c128a00b003dfee43863fsm16275847wmd.26.2023.02.28.08.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 08:38:33 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     cem@kernel.org, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs_db: introduce attr_modify command
Date:   Tue, 28 Feb 2023 17:35:50 +0100
Message-Id: <20230228163549.1947105-1-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This command allows for writing value over already existing value of
inode's extended attribute. The difference from 'write' command is
that extended attribute can be addressed by name and new value is
written over old value.

The command also allows addressing via binary names (introduced by
parent pointers). This can be done by specified name length (-m) and
value in #hex format.

Example:

	# Modify attribute with name #00000042 by overwriting 8
	# bytes at offset 3 with value #0000000000FF00FF
	attr_modify -o 3 -m 4 -v 8 #42 #FF00FF

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---

For now I use this for fs-verity tests to corrupt extended attributes.

---
 db/attrset.c | 202 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 db/write.c   |   2 +-
 db/write.h   |   1 +
 3 files changed, 202 insertions(+), 3 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 0d8d70a8..7249294a 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -16,10 +16,12 @@
 #include "field.h"
 #include "inode.h"
 #include "malloc.h"
+#include "write.h"
 #include <sys/xattr.h>
 
 static int		attr_set_f(int argc, char **argv);
 static int		attr_remove_f(int argc, char **argv);
+static int		attr_modify_f(int argc, char **argv);
 static void		attrset_help(void);
 
 static const cmdinfo_t	attr_set_cmd =
@@ -30,6 +32,11 @@ static const cmdinfo_t	attr_remove_cmd =
 	{ "attr_remove", "aremove", attr_remove_f, 1, -1, 0,
 	  N_("[-r|-s|-u] [-n] name"),
 	  N_("remove the named attribute from the current inode"), attrset_help };
+static const cmdinfo_t	attr_modify_cmd =
+	{ "attr_modify", "amodify", attr_modify_f, 1, -1, 0,
+	  N_("[-r|-s|-u] [-o n] [-v n] [-m n] name value"),
+	  N_("modify value of the named attribute of the current inode"),
+		attrset_help };
 
 static void
 attrset_help(void)
@@ -38,8 +45,9 @@ attrset_help(void)
 "\n"
 " The 'attr_set' and 'attr_remove' commands provide interfaces for debugging\n"
 " the extended attribute allocation and removal code.\n"
-" Both commands require an attribute name to be specified, and the attr_set\n"
-" command allows an optional value length (-v) to be provided as well.\n"
+" Both commands together with 'attr_modify' require an attribute name to be\n"
+" specified. The attr_set and attr_modify commands allow an optional value\n"
+" length (-v) to be provided as well.\n"
 " There are 4 namespace flags:\n"
 "  -r -- 'root'\n"
 "  -u -- 'user'		(default)\n"
@@ -48,6 +56,9 @@ attrset_help(void)
 " For attr_set, these options further define the type of set operation:\n"
 "  -C -- 'create'    - create attribute, fail if it already exists\n"
 "  -R -- 'replace'   - replace attribute, fail if it does not exist\n"
+" attr_modify command provides more of the following options:\n"
+"  -m -- 'name length'   - specify length of the name (handy with binary names)\n"
+"  -o -- 'value offset'   - offset new value within old attr's value\n"
 " The backward compatibility mode 'noattr2' can be emulated (-n) also.\n"
 "\n"));
 }
@@ -60,6 +71,7 @@ attrset_init(void)
 
 	add_command(&attr_set_cmd);
 	add_command(&attr_remove_cmd);
+	add_command(&attr_modify_cmd);
 }
 
 static int
@@ -263,3 +275,189 @@ out:
 		libxfs_irele(args.dp);
 	return 0;
 }
+
+static int
+attr_modify_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_da_args	args = { };
+	int			c;
+	int			offset = 0;
+	char			*sp;
+	char			*converted;
+	uint8_t			*name;
+	int			namelen = 0;
+	uint8_t			*value;
+	int			valuelen = 0;
+
+	if (cur_typ == NULL) {
+		dbprintf(_("no current type\n"));
+		return 0;
+	}
+
+	if (cur_typ->typnm != TYP_INODE) {
+		dbprintf(_("current type is not inode\n"));
+		return 0;
+	}
+
+	while ((c = getopt(argc, argv, "rusnv:o:m:")) != EOF) {
+		switch (c) {
+		/* namespaces */
+		case 'r':
+			args.attr_filter |= LIBXFS_ATTR_ROOT;
+			args.attr_filter &= ~LIBXFS_ATTR_SECURE;
+			break;
+		case 'u':
+			args.attr_filter &= ~(LIBXFS_ATTR_ROOT |
+					      LIBXFS_ATTR_SECURE);
+			break;
+		case 's':
+			args.attr_filter |= LIBXFS_ATTR_SECURE;
+			args.attr_filter &= ~LIBXFS_ATTR_ROOT;
+			break;
+
+		case 'n':
+			/*
+			 * We never touch attr2 these days; leave this here to
+			 * avoid breaking scripts.
+			 */
+			break;
+
+		case 'o':
+			offset = strtol(optarg, &sp, 0);
+			if (*sp != '\0' || offset < 0 || offset > 64 * 1024) {
+				dbprintf(_("bad attr_modify offset %s\n"),
+						optarg);
+				return 0;
+			}
+			break;
+
+		case 'v':
+			valuelen = strtol(optarg, &sp, 0);
+			if (*sp != '\0' || offset < 0 || valuelen > 64 * 1024) {
+				dbprintf(_("bad attr_modify value len %s\n"),
+						optarg);
+				return 0;
+			}
+			break;
+
+		case 'm':
+			namelen = strtol(optarg, &sp, 0);
+			if (*sp != '\0' || offset < 0 || namelen > MAXNAMELEN) {
+				dbprintf(_("bad attr_modify name len %s\n"),
+						optarg);
+				return 0;
+			}
+			break;
+
+		default:
+			dbprintf(_("bad option for attr_modify command\n"));
+			return 0;
+		}
+	}
+
+	if (optind != argc - 2) {
+		dbprintf(_("too few options for attr_modify\n"));
+		return 0;
+	}
+
+	if (namelen >= MAXNAMELEN) {
+		dbprintf(_("name too long\n"));
+		return 0;
+	}
+
+	if (!namelen) {
+		if (argv[optind][0] == '#')
+			namelen = strlen(argv[optind])/2;
+		if (argv[optind][0] == '"')
+			namelen = strlen(argv[optind]) - 2;
+	}
+
+	name = xcalloc(namelen, sizeof(uint8_t));
+	converted = convert_arg(argv[optind], (int)(namelen*8));
+	if (!converted) {
+		dbprintf(_("invalid name\n"));
+		goto out_free_name;
+	}
+
+	memcpy(name, converted, namelen);
+	args.name = (const uint8_t *)name;
+	args.namelen = namelen;
+
+	optind++;
+
+	if (valuelen > 64 * 1024) {
+		dbprintf(_("value too long\n"));
+		goto out_free_name;
+	}
+
+	if (!valuelen) {
+		if (argv[optind][0] == '#')
+			valuelen = strlen(argv[optind])/2;
+		if (argv[optind][0] == '"')
+			valuelen = strlen(argv[optind]) - 2;
+	}
+
+	if ((valuelen + offset) > 64 * 1024) {
+		dbprintf(_("offsetted value too long\n"));
+		goto out_free_name;
+	}
+
+	value = xcalloc(valuelen, sizeof(uint8_t));
+	converted = convert_arg(argv[optind], (int)(valuelen*8));
+	if (!converted) {
+		dbprintf(_("invalid value\n"));
+		goto out_free_value;
+	}
+	memcpy(value, converted, valuelen);
+
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp)) {
+		dbprintf(_("failed to iget inode %llu\n"),
+			(unsigned long long)iocur_top->ino);
+		goto out;
+	}
+
+	if (libxfs_attr_get(&args)) {
+		dbprintf(_("failed to get attr '%s' from inode %llu\n"),
+			args.name, (unsigned long long)iocur_top->ino);
+		goto out;
+	}
+
+	if (valuelen + offset > args.valuelen) {
+		dbprintf(_("new value too long\n"));
+		goto out;
+	}
+
+	/* As args.valuelen is now set let's get args.value */
+	if (libxfs_attr_get(&args)) {
+		dbprintf(_("failed to get attr '%s' from inode %llu\n"),
+			args.name, (unsigned long long)iocur_top->ino);
+		goto out;
+	}
+
+	/* modify value */
+	memcpy((uint8_t *)args.value + offset, value, valuelen);
+
+	args.attr_flags = XATTR_REPLACE;
+	args.attr_flags &= ~XATTR_CREATE;
+	if (libxfs_attr_set(&args)) {
+		dbprintf(_("failed to set attr '%s' from inode %llu\n"),
+			(unsigned char *)args.name,
+			(unsigned long long)iocur_top->ino);
+		goto out;
+	}
+
+	/* refresh with updated inode contents */
+	set_cur_inode(iocur_top->ino);
+
+out:
+	if (args.dp)
+		libxfs_irele(args.dp);
+	xfree(args.value);
+out_free_value:
+	xfree(value);
+out_free_name:
+	xfree(name);
+	return 0;
+}
diff --git a/db/write.c b/db/write.c
index 6c67e839..838fb04e 100644
--- a/db/write.c
+++ b/db/write.c
@@ -511,7 +511,7 @@ convert_oct(
  * are adjusted in the buffer so that the first input bit is to be be written to
  * the first bit in the output.
  */
-static char *
+char *
 convert_arg(
 	char		*arg,
 	int		bit_length)
diff --git a/db/write.h b/db/write.h
index e24e07d4..4ba04d03 100644
--- a/db/write.h
+++ b/db/write.h
@@ -6,6 +6,7 @@
 
 struct field;
 
+extern char	*convert_arg(char *arg, int bit_length);
 extern void	write_init(void);
 extern void	write_block(const field_t *fields, int argc, char **argv);
 extern void	write_struct(const field_t *fields, int argc, char **argv);
-- 
2.38.1

