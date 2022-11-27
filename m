Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2381CC43217
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Nov 2022 18:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiK0Sa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Nov 2022 13:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiK0Sa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2022 13:30:28 -0500
X-Greylist: delayed 1642 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Nov 2022 10:30:27 PST
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5907DF64
        for <linux-xfs@vger.kernel.org>; Sun, 27 Nov 2022 10:30:27 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1ozLzb-003cEZ-C7; Sun, 27 Nov 2022 18:03:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#924307: xfsprogs: xfs_fsr needlessly defragments fully defragmented files
Reply-To: Marc Lehmann <schmorp@schmorp.de>, 924307@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 924307
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <155230535650.755.1614381112413278305.reportbug@cerebro.laendle>
X-Debian-PR-Source: xfsprogs
Received: via spool by 924307-submit@bugs.debian.org id=B924307.1669571967861280
          (code B ref 924307); Sun, 27 Nov 2022 18:03:02 +0000
Received: (at 924307) by bugs.debian.org; 27 Nov 2022 17:59:27 +0000
Received: from mail.nethype.de ([5.9.56.24]:43045)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <schmorp@schmorp.de>)
        id 1ozLw7-003c3N-JM
        for 924307@bugs.debian.org; Sun, 27 Nov 2022 17:59:27 +0000
Received: from [10.0.0.5] (helo=doom.schmorp.de)
        by mail.nethype.de with esmtp (Exim 4.94.2)
        (envelope-from <schmorp@schmorp.de>)
        id 1ozLgy-001OmP-Bd
        for 924307@bugs.debian.org; Sun, 27 Nov 2022 17:43:48 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
        by doom.schmorp.de with esmtp (Exim 4.94.2)
        (envelope-from <schmorp@schmorp.de>)
        id 1ozLgy-00BQPP-02
        for 924307@bugs.debian.org; Sun, 27 Nov 2022 17:43:48 +0000
Received: from root by cerebro.laendle with local (Exim 4.94.2)
        (envelope-from <root@schmorp.de>)
        id 1ozLgx-0001R5-PL
        for 924307@bugs.debian.org; Sun, 27 Nov 2022 18:43:47 +0100
Date:   Sun, 27 Nov 2022 18:43:47 +0100
From:   Marc Lehmann <schmorp@schmorp.de>
To:     924307@bugs.debian.org
Message-ID: <Y4Oh0y9gHZ77iwl/@schmorp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
OpenPGP: id=904ad2f81fb16978e7536f726dea2ba30bc39eb6;
 url=http://pgp.schmorp.de/schmorp-pgpkey.txt; preference=signencrypt
X-Greylist: delayed 933 seconds by postgrey-1.36 at buxtehude; Sun, 27 Nov 2022 17:59:27 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Seems that current versions of e2fsprogs have improved filefrag, which now
reports one "extent" for these files, even though it has two extents:

   File size of 014798 is 87556096 (21376 blocks of 4096 bytes)
    ext:     logical_offset:        physical_offset: length:   expected: flags:
      0:        0..   21373:  352550127.. 352571500:  21374:            
      1:    21374..   21375:  352571501.. 352571502:      2:             last,unwritten,eof
   014798: 1 extent found

not quite correct, but arguably more useful (2 _extents_ vs. 1
_fragment_, just a wording issue).

xfs_fsr still considers these files fragmented, though:

   014798
   extents before:2 after:1 DONE 014798

-- 
