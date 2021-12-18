Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F13C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Dec 2021 00:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhLRAUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 19:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhLRAUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 19:20:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6ECC061574
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 16:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74EFAB82B2B
        for <linux-xfs@vger.kernel.org>; Sat, 18 Dec 2021 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32491C36AE2;
        Sat, 18 Dec 2021 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639786811;
        bh=DdbQKzu1p33hhtdqayI6sm066OqWi2K8bgimfW+pufM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mIwb+Z0UieRDinCiwo/TybUJ6fHJNjYsaKokq9lJYaIfzQ7P0CE51TpsgBewqhKsD
         I0xhzMl2f5uwU4DwadUKbti4p2xiz56JnCaxinS+4phn1xupwKddU56fpih5GyffcT
         oRk+RHlMP5lniqE1B3RtAZErpx6qBbdkkZDB/AKO8F3J3Qcs12896aiUg82LwrhbPU
         ZlbfIzAPLDqDbJnOVw7A6p87h1vcXbPpDHnO5yGB34U0d/+XWRsYMkKwToHGeMGBkc
         YXEjsiCdLjQajSSVBXuy2K1X/SkDi8omJP0FRimAz7PrVPMF41qYDE1AIbRabH0nBH
         +lJvPd+M8oIgw==
Date:   Fri, 17 Dec 2021 16:20:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 2/3] mkfs: prevent corruption of passed-in suboption string
 values
Message-ID: <20211218002010.GT27664@magnolia>
References: <20211218001616.GB27676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218001616.GB27676@magnolia>
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
