Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55104 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbeCUDk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:40:28 -0400
Subject: [PATCH 07/14] xfs_scrub: check name for suspicious characters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:40:23 -0700
Message-ID: <152160362336.8288.2857656394745535422.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Look for suspicious characters in each name we process.  This includes
control characters, text direction overrides, zero-width code points,
and names that mix characters from different directionalities.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/unicrash.c |  110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 06ccadf..3b5b46e 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -94,6 +94,18 @@ struct unicrash {
  */
 #define UNICRASH_NOT_UNIQUE	(1 << 0)
 
+/* Name contains directional overrides. */
+#define UNICRASH_BIDI_OVERRIDE	(1 << 1)
+
+/* Name mixes left-to-right and right-to-left characters. */
+#define UNICRASH_BIDI_MIXED	(1 << 2)
+
+/* Control characters in name. */
+#define UNICRASH_CONTROL_CHAR	(1 << 3)
+
+/* Invisible characters.  Only a problem if we have collisions. */
+#define UNICRASH_ZERO_WIDTH	(1 << 4)
+
 /*
  * We only care about validating utf8 collisions if the underlying
  * system configuration says we're using utf8.  If the language
@@ -267,6 +279,66 @@ name_entry_hash(
 	}
 }
 
+/*
+ * Check a name for suspicious elements that have appeared in filename
+ * spoofing attacks.  This includes names that mixed directions or contain
+ * direction overrides control characters, both of which have appeared in
+ * filename spoofing attacks.
+ */
+static void
+name_entry_examine(
+	struct name_entry	*entry,
+	unsigned int		*badflags)
+{
+	UChar32			uchr;
+	int32_t			i;
+	uint8_t			mask = 0;
+
+	for (i = 0; i < entry->normstrlen;) {
+		U16_NEXT_UNSAFE(entry->normstr, i, uchr);
+
+		/* zero width character sequences */
+		switch (uchr) {
+		case 0x200B:	/* zero width space */
+		case 0x200C:	/* zero width non-joiner */
+		case 0x200D:	/* zero width joiner */
+		case 0xFEFF:	/* zero width non breaking space */
+		case 0x2060:	/* word joiner */
+		case 0x2061:	/* function application */
+		case 0x2062:	/* invisible times (multiply) */
+		case 0x2063:	/* invisible separator (comma) */
+		case 0x2064:	/* invisible plus (addition) */
+			*badflags |= UNICRASH_ZERO_WIDTH;
+			break;
+		}
+
+		/* control characters */
+		if (u_iscntrl(uchr))
+			*badflags |= UNICRASH_CONTROL_CHAR;
+
+		switch (u_charDirection(uchr)) {
+		case U_LEFT_TO_RIGHT:
+			mask |= 0x01;
+			break;
+		case U_RIGHT_TO_LEFT:
+			mask |= 0x02;
+			break;
+		case U_RIGHT_TO_LEFT_OVERRIDE:
+			*badflags |= UNICRASH_BIDI_OVERRIDE;
+			break;
+		case U_LEFT_TO_RIGHT_OVERRIDE:
+			*badflags |= UNICRASH_BIDI_OVERRIDE;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* mixing left-to-right and right-to-left chars */
+	if (mask == 0x3)
+		*badflags |= UNICRASH_BIDI_MIXED;
+}
+
 /* Initialize the collision detector. */
 static bool
 unicrash_init(
@@ -369,6 +441,18 @@ unicrash_complain(
 		bad2 = string_escape(dup_entry->name);
 
 	/*
+	 * Most filechooser UIs do not look for bidirectional overrides when
+	 * they render names.  This can result in misleading name presentation
+	 * that makes "hig<rtl>gnp.sh" render like "highs.png".
+	 */
+	if (badflags & UNICRASH_BIDI_OVERRIDE) {
+		str_warn(uc->ctx, descr,
+_("Unicode name \"%s\" in %s contains suspicious text direction overrides."),
+				bad1, what);
+		goto out;
+	}
+
+	/*
 	 * Two names that normalize to the same string will render
 	 * identically even though the filesystem considers them unique
 	 * names.  "cafe\xcc\x81" and "caf\xc3\xa9" have different byte
@@ -381,6 +465,30 @@ _("Unicode name \"%s\" in %s renders identically to \"%s\"."),
 		goto out;
 	}
 
+	/*
+	 * Unfiltered control characters can mess up your terminal and render
+	 * invisibly in filechooser UIs.
+	 */
+	if (badflags & UNICRASH_CONTROL_CHAR) {
+		str_warn(uc->ctx, descr,
+_("Unicode name \"%s\" in %s contains control characters."),
+				bad1, what);
+		goto out;
+	}
+
+	/*
+	 * It's not considered good practice (says Unicode) to mix LTR
+	 * characters with RTL characters.  The mere presence of different
+	 * bidirectional characters isn't enough to trip up software, so don't
+	 * warn about this too loudly.
+	 */
+	if (badflags & UNICRASH_BIDI_MIXED) {
+		str_info(uc->ctx, descr,
+_("Unicode name \"%s\" in %s mixes bidirectional characters."),
+				bad1, what);
+		goto out;
+	}
+
 out:
 	free(bad1);
 	free(bad2);
@@ -442,6 +550,8 @@ __unicrash_check_name(
 	if (!name_entry_create(uc, name, ino, &new_entry))
 		return true;
 
+	name_entry_examine(new_entry, &badflags);
+
 	moveon = unicrash_add(uc, new_entry, &badflags, &dup_entry);
 	if (!moveon)
 		return false;

