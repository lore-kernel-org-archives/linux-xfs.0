Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DCEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345187AbiATAWt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47434 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbiATAWt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1F33B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4E7C004E1;
        Thu, 20 Jan 2022 00:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638166;
        bh=JMHNbi7u6vrPnvCf7w7knF+zpcfnaHn+hl9fzEmtCtw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uk4Cp6bYQQjWDi+qLO72zwUUfII4evE8NKxgkN0bnQ/8XTB1tlakDXsxiVL+doRan
         HBi7d9Q769rLSr2CAMbwb6ySMyCyUmHuUL1Jo7in8OweWaPcGA3yhJpvKbqobXPnVS
         MPs88k7MLwFnGaHyFaECCavV8D1MjrPcYWqUj+MDB5Qyu14YX/ggaYccI11AW8o1N2
         7neqqHpwJYYtAzfJdpKYoHneULxEuigCeb444rmBxx9hMXMb704Y871YhVPlm09FBd
         vQdTaqlwDwykjevO34ouh3p0B49NYDrc19Waai6UVnUbqj1oz9eEEI78NetxR4XHsB
         7KcV8TMB/EO9A==
Subject: [PATCH 13/17] mkfs: prevent corruption of passed-in suboption string
 values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:46 -0800
Message-ID: <164263816636.863810.3932965298888705668.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Eric and I were trying to play with mkfs.configuration files, when I
spotted this (with the libini package from Ubuntu 20.04):

# cat << EOF > /tmp/r
[data]
su=2097152
sw=1
EOF
# mkfs.xfs -f -c options=/tmp/r /dev/sda
Parameters parsed from config file /tmp/r successfully
-d su option requires a value

It turns out that libini's parser uses stack variables(!) to store the
value of a key=value pair that it parses, and passes this stack array to
the parse_cfgopt function.  If the particular option calls getstr(),
then we save the value of that pointer (not its contents) to the
cli_params.  Being a stack array, the contents will be overwritten by
other function calls, which means that our value of '2097152' has been
destroyed by the time we actually call getnum when we're validating the
new fs config.

We never noticed this until now because the only other caller was
getsubopt on the argv array, which gets chopped up but left intact in
memory.  The solution is to make a private copy of those strings if we
ever save them for later.  For now we'll be lazy and let the memory
leak, since mkfs is not a long-running process.

Fixes: 33c62516 ("mkfs: add initial ini format config file parsing support")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3a41e17f..fcad6b55 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1438,12 +1438,21 @@ getstr(
 	struct opt_params	*opts,
 	int			index)
 {
+	char			*ret;
+
 	check_opt(opts, index, true);
 
 	/* empty strings for string options are not valid */
 	if (!str || *str == '\0')
 		reqval(opts->name, opts->subopts, index);
-	return (char *)str;
+
+	ret = strdup(str);
+	if (!ret) {
+		fprintf(stderr, _("Out of memory while saving suboptions.\n"));
+		exit(1);
+	}
+
+	return ret;
 }
 
 static int

