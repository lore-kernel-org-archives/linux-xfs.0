Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B33FC6379D
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Nov 2020 16:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 765152344C
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Nov 2020 16:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgKOQaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Nov 2020 11:30:13 -0500
Received: from sandeen.net ([63.231.237.45]:59138 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbgKOQaN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Nov 2020 11:30:13 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B68DB2A96;
        Sun, 15 Nov 2020 10:29:50 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
 <160375515483.880118.8069916247570952970.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs_db: add a directory path lookup command
Message-ID: <173ab71d-7f27-786f-1908-10ecb1cd865d@sandeen.net>
Date:   Sun, 15 Nov 2020 10:30:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <160375515483.880118.8069916247570952970.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/26/20 6:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a command to xfs_db so that we can navigate to inodes by path.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

...


> +/* Path lookup */
> +
> +/* Key for looking up metadata inodes. */
> +struct dirpath {
> +	/* Array of string pointers. */
> +	char		**path;
> +
> +	/* Number of strings in path. */
> +	unsigned int	depth;
> +};

This generates warnings for me in gcc-4.8.5 (hah, I know) as well as
gcc-9.

namei.c:101:12: warning: pointer targets in initialization of ‘const unsigned char *’ from ‘char *’ differ in signedness [-Wpointer-sign]

due to the "unsigned char *" type from:

commit e2bcd936eb95d0019ca5e05f9fdd27e770ddded1
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Jan 20 10:44:58 2010 +1100

    xfs: directory names are unsigned
    
    Convert the struct xfs_name to use unsigned chars for the name
    strings to match both what is stored on disk (__uint8_t) and what
    the VFS expects (unsigned char).
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

so maybe just cast to shut it up?
diff --git a/db/namei.c b/db/namei.c
index 4b467ff8..a902f302 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -98,7 +98,7 @@ path_navigate(
 
 	for (i = 0; i < dirpath->depth; i++) {
 		struct xfs_name	xname = {
-			.name	= dirpath->path[i],
+			.name	= (unsigned char *)dirpath->path[i],
 			.len	= strlen(dirpath->path[i]),
 		};
 
@@ -253,7 +253,7 @@ dir_emit(
 	uint8_t			dtype)
 {
 	char			*display_name;
-	struct xfs_name		xname = { .name = name };
+	struct xfs_name		xname = { .name = (unsigned char *)name };
 	const char		*dstr = get_dstr(mp, dtype);
 	xfs_dahash_t		hash;
 	bool			good;

