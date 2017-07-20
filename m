Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934694AbdGTJ3h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:29:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94A337CE0D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:29:37 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
Date: Thu, 20 Jul 2017 11:29:26 +0200
Message-Id: <20170720092932.32580-2-jtulak@redhat.com>
In-Reply-To: <20170720092932.32580-1-jtulak@redhat.com>
References: <20170720092932.32580-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Save exactly what the user gave us for every option.  This way, we will
never lose the information if we need it to print back an issue.
(Just add the infrastructure now, used in the next patches.)

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a69190b9..4b030101 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -107,6 +107,11 @@ unsigned int		sectorsize;
  *     sets what is used with simple specifying the subopt (-d file).
  *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
  *     value in any case.
+ *
+ *   raw_input INTERNAL
+ *     Filled raw string from the user, so we never lose that information e.g.
+ *     to print it back in case of an issue.
+ *
  */
 struct opt_params {
 	const char	name;
@@ -122,6 +127,7 @@ struct opt_params {
 		long long	minval;
 		long long	maxval;
 		long long	defaultval;
+		const char	*raw_input;
 	}		subopt_params[MAX_SUBOPTS];
 };
 
@@ -729,6 +735,18 @@ struct opt_params mopts = {
  */
 #define WHACK_SIZE (128 * 1024)
 
+static inline void
+set_conf_raw(struct opt_params *opt, int subopt, const char *value)
+{
+	opt->subopt_params[subopt].raw_input = value;
+}
+
+static inline const char *
+get_conf_raw(const struct opt_params *opt, int subopt)
+{
+	return opt->subopt_params[subopt].raw_input;
+}
+
 /*
  * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
  */
-- 
2.11.0

