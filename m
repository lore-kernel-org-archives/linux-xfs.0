Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3774C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 11:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 970B121928
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 11:46:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0DFA/eQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfIRLqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 07:46:00 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:43251 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfIRLp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 07:45:59 -0400
Received: by mail-pl1-f181.google.com with SMTP id 4so3017817pld.10;
        Wed, 18 Sep 2019 04:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Dggx4R3qY3lc/gADzNBnYMriarrvnw+2zDTWucCST4Q=;
        b=Y0DFA/eQVAyqNevfL6GcO45xtFLN60TyLF9lkKrt3dnec0OK1QDJH1Q1bSztsPK8K3
         XSiPwXSweiM2T8MJKpUlb688ijtBb34yqb1kAe7edmGnq7cKiT6f7dtGyT+8q/oB0cEl
         41kAtNNENK3QwM4SYEhznSYA7+5NJ2dja39k9AqXQ+FVIPoHX9bozRfyvVh+Ma1woAF4
         Oztwxu0p3sneopvp9FxUZZuzKMNug98a5th/+GXsSSUZFq3dgrImYGkS+PCInz3vWBom
         mbOwxwXiL7tkogenYYpQDMHK8UssPJqoBwFm5Fy+fIS8Sjs7pNC1NSA3Bypt6Eo6RmjD
         K3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Dggx4R3qY3lc/gADzNBnYMriarrvnw+2zDTWucCST4Q=;
        b=P28qLHSb13AxBtiWmlYZvzjY64YUosXpJ67Oaft8aPsdgXZYwHPSw9j5Eg+QGd7PMm
         vhiwnt17DCrhTWaUY7YZwhj7mGJXzeKDSzX/zdZ9bi25bxaQAsCRRifRAqLegaUGzEhq
         D0+0oY+8vi+6sRJIYNVbJvjeGUSV/ohRab6edfokAHOTOpnCiUxPoe235dsotdGY9oCH
         LDywzuVmZoaiflyey7hDtAZVE8fNtl6qFy9b2/N+mdoEN3eEUqBuwEZ/Ge+p1Y3vO2Pi
         h7EqfZGqWWe7U/u7eaxgdxNFh6Lpiq8orSAqIjiJOp386OF3quYgeo3qMHOVUBaYlzU/
         XBwQ==
X-Gm-Message-State: APjAAAX74fEJ/bI/bhiEmj28agcyeMNsYauxV9Kwl1j/O1J4U5DDWlOz
        lnnWXK2K6k9TM7WmzUX3JQ==
X-Google-Smtp-Source: APXvYqywT4HLOXAhp3VSymOuPcKcKyC+KoBufJ01RvCgCvRX+oqhvENE0ERi+QLwu1T6h0PGq7xLiQ==
X-Received: by 2002:a17:902:b613:: with SMTP id b19mr3610269pls.225.1568807159226;
        Wed, 18 Sep 2019 04:45:59 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id s21sm2098486pjr.24.2019.09.18.04.45.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:45:58 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eryu Guan <guaneryu@gmail.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v3 0/2] xfstests: add deadlock between the AGI and AGF with
 RENAME_WHITEOUT test
Message-ID: <6e7e5cd2-76c1-6d4c-4b99-a166f6d26408@gmail.com>
Date:   Wed, 18 Sep 2019 19:45:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, so add test to check that whether
the rename() call works well. This test require a special rename flag,
so add support check for if a given rename flag is supported in
_requires_renameat2.

kaixuxia (2):
  common: check if a given rename flag is supported in
    _requires_renameat2
  xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT

 common/renameat2  | 30 ++++++++++++++++-
 tests/generic/024 | 13 ++------
 tests/generic/025 | 13 ++------
 tests/generic/078 | 13 ++------
 tests/xfs/512     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |  2 ++
 tests/xfs/group   |  1 +
 7 files changed, 137 insertions(+), 31 deletions(-)
 create mode 100755 tests/xfs/512
 create mode 100644 tests/xfs/512.out

-- 
1.8.3.1

-- 
kaixuxia
