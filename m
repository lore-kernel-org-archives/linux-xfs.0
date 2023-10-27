Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615B3C25B48
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 19:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjJ0TXN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 15:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjJ0TXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 15:23:12 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC136192
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 12:23:09 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwSQ5-003lDx-5B; Fri, 27 Oct 2023 19:22:57 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: Philip Hands <phil@hands.com>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <871qdgccs5.fsf@nimble.hk.hands.com> <20231027154505.GL3195650@frogsfrogsfrogs> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698434335894591
          (code B ref 1054644); Fri, 27 Oct 2023 19:22:56 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 19:18:55 +0000
Received: from free.hands.com ([78.129.164.123]:54734)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <phil@hands.com>)
        id 1qwSM8-003kbL-QK
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 19:18:54 +0000
Received: from nimble.hk.hands.com (p5b08cc82.dip0.t-ipconnect.de [91.8.204.130])
        by free.hands.com (Postfix) with ESMTPSA id 0CF3A2A720
        for <1054644@bugs.debian.org>; Fri, 27 Oct 2023 20:18:48 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hands.com;
        s=202202.hands; t=1698434328;
        bh=4zE2LR3H2kk/m75PQ41trOWWUGSDp6plMqfikdGHVDg=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=kHH8JDeRFQC8KpnUWcuB9ODL/0KwuPDy1TOkIlHS7q0poVotvUlcpbO243bcZbmjP
         FR5tBX3GaL5AOZrPkdiMPB6VbjfGjztMr2+9Tq7nZiqvV1m2/xIlhzUodZDkwzkggl
         UK/Yo2ThHJGNbRa9Fqp95h7RFfhxjt8THbj1pTaOmqIY7brE8T7ZEsgdxrmdtrrirM
         OS1wpa4lsBuwO4yu0OzCw2SszNEisFDm4I4ZVcb2s356D2ocJnA/wjYBOQ7cmbObvP
         1KXRKOLI7XagewfipThVnat6vjGMC9wBA92XPnytm/ai/2Ct9bflVRobFykHghf8EY
         Bm4d3FtbzrwhQ==
Received: from phil (uid 1000)
        (envelope-from phil@hands.com)
        id 10c9a5
        by nimble.hk.hands.com (DragonFly Mail Agent v0.13 on nimble);
        Fri, 27 Oct 2023 21:18:47 +0200
From:   Philip Hands <phil@hands.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, 1054644@bugs.debian.org
In-Reply-To: <20231027154505.GL3195650@frogsfrogsfrogs>
Date:   Fri, 27 Oct 2023 21:18:47 +0200
Message-ID: <87y1fnc1rc.fsf@nimble.hk.hands.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Greylist: delayed 14284 seconds by postgrey-1.36 at buxtehude; Fri, 27 Oct 2023 19:18:52 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:
...
> Curiously, this log says:
>
> Oct 24 05:35:32 in-target: Setting up xfsprogs (6.4.0-1) ...^M
>
> So ... is it running 6.4 and not 6.5?

The daily test versions of Debian-Installer draw components from
"unstable", which is where the 6.5 version is at present, which then
creates the file system with problematic flags.

However, the test images normally install "testing" onto the target, to
avoid pointless breakage caused by the potential for "unstable" to be,
well ... unstable, hence the 6.4 version that gets put in-target.

Having 6.4 in the target system doesn't help in this case, because the
damage has already been done while creating the file system, by the 6.5
version of the udeb.

One can confirm that this is the case by looking for xfsprogs in here:

  https://openqa.debian.net/tests/198911/logfile?filename=complete_install-DI-installed-pkgs.txt

which lists the installed components (udebs) of the installer that's running:

  xfsprogs-udeb                            6.5.0-1

Cheers, Phil.
-- 
Philip Hands -- https://hands.com/~phil
