Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87721C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42DB464F03
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhBXVoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:44:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230330AbhBXVoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 16:44:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614203007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ij/p5GM50HPwNBaUy4fo+FQsgEAi87WUJ/9oNZJtEAg=;
        b=e0Om0BqrEY2+NiIALElE+Eny7d8wgt/VHm7mZ1IYUY71bLnsIXCMOgvd9GOuLsZCiwrDHF
        BYuqu3DWxhuUc1DaBYB+60R8to/mPDh/kMqv4i4pYrs9Mpi7IzUzZvIbJwQHD1ws4W0oxK
        IXDdnIUrOmoLrU+HKkKmjUXXaC75YWs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-0DZG2e7ENnWWKekClT-ZRQ-1; Wed, 24 Feb 2021 16:43:26 -0500
X-MC-Unique: 0DZG2e7ENnWWKekClT-ZRQ-1
Received: by mail-wr1-f70.google.com with SMTP id q5so1625745wrs.20
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 13:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ij/p5GM50HPwNBaUy4fo+FQsgEAi87WUJ/9oNZJtEAg=;
        b=nIgcCsrBKo4aNtK1yylHWdyjPs/CKRETSeDXmQ+zkuTlHkl6/xqusf/bUzrL9cJ3T/
         ghRo9CSFH0s81fgMsHvX4YvFa1S90uO0rRc2QvtYxD2W+ovpd9ffMYyJYzCaCDx7foEt
         5eGcju5dk+fAos25HRyXtaNnmLf+3yI9aH2b4sBayqVv9UbBv0kXgGq2W/dswHeYu9cM
         KvTtHiECGZZqHbWIjbfGR0AU9OqYwaBoZahWp9J8gLvC3eT9HVsMNPRse78/8Obf8ko0
         pT3sauGtQKaxKX6ZWAyw8j1k1M3AoaFfXlkJpYRAsPqNlHSLf0ECF28VE6AU/d4qHMpq
         QDGA==
X-Gm-Message-State: AOAM533eYAFKxxNWoZYCZMyC6SzOl3GwG4P2zQ//tPNg2qApWNANYgeo
        xAQXOy5FAMOKPaN2Ki06TJ+O/3l8a0GuZ66uYe4Ny7QzFqHO6Ln7ue8h/6zXs/j7bsd9nNqtfRP
        6eYbtPvM2FZmL9Eyyth/i7OvXnhDOaNHaBGi3gsn2nMQEPjZj+408skTOEy9SddIPiQWG0jo=
X-Received: by 2002:a1c:4b16:: with SMTP id y22mr70129wma.99.1614203004514;
        Wed, 24 Feb 2021 13:43:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQrm94OE4gktDwJmD9lXCVRl7Y5DhuJ0o949hXlKfs4y8a4wnw8xXqJHqFtH1Pph9oJYFMgA==
X-Received: by 2002:a1c:4b16:: with SMTP id y22mr70116wma.99.1614203004265;
        Wed, 24 Feb 2021 13:43:24 -0800 (PST)
Received: from localhost.localdomain.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id x13sm4477251wrt.75.2021.02.24.13.43.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 13:43:23 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: Skip repetitive warnings about mount options
Date:   Wed, 24 Feb 2021 22:43:20 +0100
Message-Id: <20210224214323.394286-1-preichl@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At least some version of mount will look in /proc/mounts and send in all of the 
options that it finds as part of a remount command. We also /do/ still emit
"attr2" in /proc/mounts (as we probably should), so remount passes that back
in, and we emit a warning, which is not great.

In other words mount passes in "attr2" and the kernel emits a deprecation
warning for attr2, even though the user/admin never explicitly asked for the
option.

So, lets skip the warning if (we are remounting && deprecated option
state is not changing).

I also attached test for xfstests that I used for testing (the test
will be proposed on xfstests-list after/if this patch is merged).

V2 vs. V1
Kernel:
* Added new patch that renames mp to parsing_mp in xfs_fs_parse_param()
* Added new function xfs_fs_warn_deprecated() to encapsulate the logic for displaying the deprecation warning.
* Fixed some white space issues.

Test:
* Skip test on old kernels that don't print any deprecation warning. 

Pavel Reichl (2):
  xfs: rename variable mp to parsing_mp
  xfs: Skip repetitive warnings about mount options

 fs/xfs/xfs_super.c | 118 +++++++++++++++++++++++++--------------------
 1 file changed, 67 insertions(+), 51 deletions(-)

-- 
2.29.2

