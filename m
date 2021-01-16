Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D0BC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54CC23A5E
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbhAPJYf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbhAPJYd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 04:24:33 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFBEC061757
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:53 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id n26so16706206eju.6
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4DifXRNJliro+SAyS3KOZQIlpR1pTMo34i21VYSGR58=;
        b=mVTqv44tcpEb8nn7TUAVwbo1aD09AmPw+GEu3yI3+lfcXF9UTOqY9q9Og5POTq25wu
         Vs0xJz5qTHD+QFdpWaoqjoXBbcdL+ltxU1kgGjAIbjfhIpRJ8bzZYC0QaKdSCrt58CaX
         fuaV6AUBHLRkuX1UbZHs5RidnHgL3ic8GGd6GlilM5NM+fRi89up+12W5a67eXCyPrEv
         dIt4NJ/UEZUg5dgPZwWwbeptG6nu5cLBT4PWmtEEdutnVW7vm2jtmqXN+olScXU1Mbu/
         UvNqyOOWpY2czxy2JxC2VodN/jVxo4Tp6rmLIrY6diqWbA05/Q5u67A87KpnxdwqPpc3
         mU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4DifXRNJliro+SAyS3KOZQIlpR1pTMo34i21VYSGR58=;
        b=ErXF1ZclevmYv9M8j9v+yeNICRvEA6Qeqhm2TF4cKGv53K1quHxOA5qkcPVH4+QCoG
         MebfxzwH/UC2V6j7euZbeauPrgDXuufGx4wg8+oIb8au03oyQk2YfnOP+QAwDisSkjMP
         RZfmhpajsKEhgYs9UgKbMGhXDX/Ewaf8mlam3BPch6mLdj1Sw3S1iR6rlwPrvUX6fV2u
         ADd5r4Uh+dJP0uB0icUnrj3F+T6jaAh6YY21Mnv6VkklvkTnpeOKzuwz9knD2JZPKWOk
         I7woN1wC58xZHU8AiUT3tRud+gJfSRPwqL9vyyUHVFRVZOu6Ob0/9BQ7GjNn9MRkKCPW
         YJDQ==
X-Gm-Message-State: AOAM533maTqtmSdEo5Q22JqA/UW2/16oeNKAeFJlLHNxFHZnfDPFkwSe
        4fWr/1usYTCozlMFJ+8VGHdXdrPyuKE23YXQ
X-Google-Smtp-Source: ABdhPJzlzWjqN2BfqUJfCbHMp5zl2dphZNCDTkS/cImDP3GAX48HyyBgGNSChJVPVRcUdrAukZbMmQ==
X-Received: by 2002:a17:906:dbf2:: with SMTP id yd18mr7080455ejb.45.1610789031529;
        Sat, 16 Jan 2021 01:23:51 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id j25sm6166851edy.13.2021.01.16.01.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 01:23:50 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH v2 0/6] debian: xfsprogs package clean-up
Date:   Sat, 16 Jan 2021 10:23:22 +0100
Message-Id: <20210116092328.2667-1-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Apply some minor changes to the xfsprogs debian packages, including
missing copyright notices that are required by Debian Policy.

v2:
  resend with Reviewed-by annotations applied, Nathan actually sent:
  "Signed-off-by: Nathan Scott <nathans@debian.org>"

Bastian Germann (6):
  debian: cryptographically verify upstream tarball
  debian: remove dependency on essential util-linux
  debian: remove "Priority: extra"
  debian: use Package-Type over its predecessor
  debian: add missing copyright info
  debian: new changelog entry

 debian/changelog                |  11 ++++
 debian/control                  |   5 +-
 debian/copyright                | 111 ++++++++++++++++++++++++++++----
 debian/upstream/signing-key.asc |  63 ++++++++++++++++++
 debian/watch                    |   2 +-
 5 files changed, 175 insertions(+), 17 deletions(-)
 create mode 100644 debian/upstream/signing-key.asc

-- 
2.30.0

