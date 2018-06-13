Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46148 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751898AbeFMTee (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 15:34:34 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C68F92ACC
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 14:34:09 -0500 (CDT)
Subject: [PATCH 1/2] mkfs: initialize return value of parse_config_stream to
 success
From: Eric Sandeen <sandeen@sandeen.net>
References: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
Message-ID: <8318bdfe-ff7b-02b9-414e-f63f9ccdbdbc@sandeen.net>
Date: Wed, 13 Jun 2018 14:34:33 -0500
MIME-Version: 1.0
In-Reply-To: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Right now the return value is initialized to -1 (failure) and set to zero
only if a valid token is found.  However, this means that i.e. a blank
or template config file containing only comments will yield failure on
parsing.
    
Initialize to success, and set to failure only if failure occurs.
    
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/config.c b/mkfs/config.c
index 835adc4..1a2cd35 100644
--- a/mkfs/config.c
+++ b/mkfs/config.c
@@ -385,7 +385,7 @@ parse_config_stream(
 	const char 			*config_file,
 	FILE				*fp)
 {
-	int				ret = -1;
+	int				ret = 0;
 	char				*line = NULL;
 	ssize_t				linelen;
 	size_t				len = 0, lineno = 0;

