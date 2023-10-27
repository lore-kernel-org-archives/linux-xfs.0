Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9B3C25B6F
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 22:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjJ0WaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 18:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjJ0WaI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 18:30:08 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D5C9C
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 15:30:05 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwVL9-0049Fh-0l; Fri, 27 Oct 2023 22:30:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: Philip Hands <phil@hands.com>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <871qdgccs5.fsf@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <20231027154505.GL3195650@frogsfrogsfrogs> <ZTvjFZPn7KH6euyT@technoir> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698445660987278
          (code B ref 1054644); Fri, 27 Oct 2023 22:30:01 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 22:27:40 +0000
Received: from free.hands.com ([78.129.164.123]:51400)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <phil@hands.com>)
        id 1qwVIq-0048pC-2A
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 22:27:40 +0000
Received: from nimble.hk.hands.com (p5b08cc82.dip0.t-ipconnect.de [91.8.204.130])
        by free.hands.com (Postfix) with ESMTPSA id C74B02A75F
        for <1054644@bugs.debian.org>; Fri, 27 Oct 2023 23:27:31 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hands.com;
        s=202202.hands; t=1698445651;
        bh=S+G2YouMyJ7txLLHlwGrrdStyAHHQzNLOQiwN1/5FUs=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=Fb8E7Ne5kjuWSnqdpMaKQFaMNs2sY6sf7iQEvsjidqzerZffglTcgzUlKR4Fhs17Q
         R3eCAJ/aksulp/W3ICgkE8R3DIoCrG4hrb998Ql2KUewLJIgDCjAhPSmThrGxXnCAS
         4xfbLdvZ5UdUKOlT35tdPNqgP+yXGWB3mKpPuPBw13P9hWNdKcQk8jgONSmI9WAfwo
         RQ2lHT9ZrPR6EmNehyUpeQrxlpn5Feog5yAusd0wr4JkaqKYfkjfciblKl1OPvAFH6
         +412WXGaN94Zwxtw3nJSQBBvw6XUhTUGVdCndKHH9TK8+3el/7nn+lU1Wyp0aPgDSK
         M3q7vPHebgvPg==
Received: from phil (uid 1000)
        (envelope-from phil@hands.com)
        id 10e829
        by nimble.hk.hands.com (DragonFly Mail Agent v0.13 on nimble);
        Sat, 28 Oct 2023 00:27:31 +0200
From:   Philip Hands <phil@hands.com>
To:     Anthony Iliopoulos <ailiop@suse.com>,
        "Darrick J. Wong" <djwong@kernel.org>, 1054644@bugs.debian.org
In-Reply-To: <ZTvjFZPn7KH6euyT@technoir>
Date:   Sat, 28 Oct 2023 00:27:31 +0200
Message-ID: <87v8arbt0s.fsf@nimble.hk.hands.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Anthony Iliopoulos <ailiop@suse.com> writes:
...
> Yeap it is due to nrext64, I've submitted a patch to grub (should have
> cc'ed linux-xfs..)
>
> https://lore.kernel.org/grub-devel/20231026095339.31802-1-ailiop@suse.com/

That certainly seems to fix this bug.

I tested it by applying that patch to grub, and then getting that
version of grub installed into the target just after the initial attempt
to run grub had failed, which then allows a retry of the grub install
step to succeed.

Also, with the patched version: `grub-probe -d /dev/vda1` produces 'xfs'

Cheers, Phil.
-- 
Philip Hands -- https://hands.com/~phil
