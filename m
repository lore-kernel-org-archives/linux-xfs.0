Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5FDC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 19:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhLQTJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 14:09:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44748 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbhLQTJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 14:09:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3982962390
        for <linux-xfs@vger.kernel.org>; Fri, 17 Dec 2021 19:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDF3C36AE2;
        Fri, 17 Dec 2021 19:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639768142;
        bh=DdbQKzu1p33hhtdqayI6sm066OqWi2K8bgimfW+pufM=;
        h=Date:From:To:Cc:Subject:From;
        b=gxJrelsIUBopuZz5bVoilmKGCpzYh4SGCdu7TgabQ7Rr5okMVyxBzD+ipj/rDru9s
         //maNdBP8DfrBih87P++IIpgMj4qRCAjcXOJZN1AYA0lxffiAtZycC6hSpc0/C4zsA
         Wg4tapwWBTQXPSkc/EUPU79udFb291+SNgykPQAoKorwlibBXjL5GyCubp5qEgMjyL
         zeUyO8v4TwWmoac33DGwOxr7Ch5bXLQpvOR4IpulF6YYBIQqFSRrP545w5xhUbq8q9
         p6BDQF8oAm5ddA8HTd4oL5GaK9H2D1a/KV13UYyB7DNZNKZ0Dgnjybj6uN4jbx+KNV
         eKibzH0gEBliQ==
Date:   Fri, 17 Dec 2021 11:09:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: prevent corruption of passed-in suboption string values
Message-ID: <20211217190902.GL27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
