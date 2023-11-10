Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C17EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 19:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343770AbjKJTDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbjKJTDF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 14:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC9CF6DF3
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 10:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699640556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KdqvTdO2716oq+zvVf0KMmOF2aDzL6NfJKKObUNa1q8=;
        b=AYQ/4LMabBs/1OyXUppKFTkiJvXfTLyhmw1RKXHRVxIpz9mqmwlMyugVZ/6UnILsgioMnI
        avZSrt39xw1cROaAa+tZ7Gnv1pa0dKneruf3q0n2X6fI/hW+jSY+pwvSIm39A+q/63bWe5
        iT0E4GG3qF+8tBH6HF8Jkfc8yPcH5kU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-sUE90jpQMgie0n9x4mGDdQ-1; Fri, 10 Nov 2023 13:22:34 -0500
X-MC-Unique: sUE90jpQMgie0n9x4mGDdQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7872be95468so214642639f.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 10:22:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699640552; x=1700245352;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KdqvTdO2716oq+zvVf0KMmOF2aDzL6NfJKKObUNa1q8=;
        b=o0+mKAYdOykAxToL62ZzY3d/mlXUo74Ylkb/DZOrrtu/O3YRZAxVKBV4pNxVy0EN0V
         GieCfMs5KB62DF0axfJPR5VAVLo1Ahddc4TrpAvrbOnBDkqk/o9lhflZaexnEKwtY19u
         sPDCfHCKGQWlaIJThU6+t084YqwWbNVSHAZo8/fX8AzIqbOWy3lbkIOX5yP48H9Ex9cI
         NV3JYZ44oBurUdK/ptWfL8UiSqvsYxjj9dPyUrfr60GgXa4kcBwdAN7n9hjezBumO/AM
         SsPFN8DMctMLXXYOMtLj5Rvx8ZY3w77iYUQE28Adu9Q3V/4qzJlxEQEipD7Dqp9LcpOv
         tHTA==
X-Gm-Message-State: AOJu0YzyZ/QGD7AkGPn0BsyVbS1aRYRAAFHCCbkjRiGjGkuhdj2PRtG/
        vy5fubkQ5KzFInGhrejU5W5sLskYfdbcs0+aloFRuTBlQbppc1NuqFFiuTlnAdAcFNOsJZdizFr
        rQjRvpW4TZhVfkftA5amSHOzrI3kCQA6Zm8+1kkWO6I1DFuC15R6b4LaqxvbXHiUW7CTbyZRzbZ
        WcO2M=
X-Received: by 2002:a05:6602:4185:b0:7a9:571c:5694 with SMTP id bx5-20020a056602418500b007a9571c5694mr119597iob.10.1699640552044;
        Fri, 10 Nov 2023 10:22:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFot5/ozoFYXWfbeyFaEevx6Wmd9q41kDstnqo1G2uRX3TCrxN8MrK0IqH9Zungu1GtWu86Ag==
X-Received: by 2002:a05:6602:4185:b0:7a9:571c:5694 with SMTP id bx5-20020a056602418500b007a9571c5694mr119582iob.10.1699640551736;
        Fri, 10 Nov 2023 10:22:31 -0800 (PST)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id s6-20020a5ec646000000b0079f7734a77esm4652192ioo.35.2023.11.10.10.22.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Nov 2023 10:22:31 -0800 (PST)
Message-ID: <3ca21cbc-fbe2-4c43-b8af-50bc7467b9cd@redhat.com>
Date:   Fri, 10 Nov 2023 12:22:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: notify user when cache flush starts
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We recently had the opportunity to run xfs_repair on a system
with 2T of memory and over a billion inodes. After phase 7
had completed, xfs_repair appeared to have hung for over an
hour as the massive cache was written back.

In the long run it might be nice to see if we can add progress
reporting to the cache flush if it's sufficiently large, but
for now at least let the user know what's going on.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ff29bea9..5597b9ba 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1388,6 +1388,7 @@
 	 * verifiers are run (where we discover the max metadata LSN), reformat
 	 * the log if necessary and unmount.
 	 */
+	do_log(_("Flushing cache...\n"));
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);


