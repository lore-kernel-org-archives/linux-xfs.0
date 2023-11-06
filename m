Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49866C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 21:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbjKFVa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 16:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbjKFVaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 16:30:25 -0500
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CFDD57
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 13:30:20 -0800 (PST)
Received: from fews01-sea.riseup.net (fews01-sea-pn.riseup.net [10.0.1.109])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx1.riseup.net (Postfix) with ESMTPS id 4SPPdX5m5zzDqxS
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1699306219; bh=iBHGHOM0y28g4Bmng7xkw97u43Helzb3otVwwqFwPSQ=;
        h=Date:From:To:Subject:From;
        b=TETf6JPyyXy3Vm6OW9tG98D3bs8O0FQGPl45uDgmDkVrcCDuILex9Z6tTt4wlSPNl
         ny3b4uqahkzIgv7lW52ByWtII+eVRVfg5tfut43JA4PPDmnfwgetknWjSdmYAnSa8S
         SO6aXjKdPFJvUT5zj2jNUdbZsOB/EuwuAnxDQQyE=
X-Riseup-User-ID: 0FE9D4E78CAC1D3110BCCC53CF95A701B61FF004BCBFE880A869C2C6762A1B4A
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews01-sea.riseup.net (Postfix) with ESMTPSA id 4SPPdX16R2zJnB6
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 21:30:07 +0000 (UTC)
Date:   Mon, 6 Nov 2023 21:30:04 -0000
From:   Helle Vaanzinn <glitsj16@riseup.net>
To:     linux-xfs@vger.kernel.org
Subject: Using User/Group `nobody` in systemd units is discouraged
Message-ID: <20231106213004.45a1e105.glitsj16@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

The xfsprogs userspace utilities have a systemd unit called
xfs_scrub@.service that references "User=nobody" [1]. Ever since
systemd version 246 using User/Group `nobody` in
systemd units is discouraged [2]. It is advised to use the more secure
`DynamicUser` concept [3] instead.

I couldn't find an easy way to report an issue / offer a PR for this,
hence this message to the mailing list. If there's a better way to
report, please advise.

Regards,

Helle

/--


[1]
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub@.service.in#n15

[2] https://github.com/systemd/systemd/blob/v246/NEWS#L106

[3] https://0pointer.net/blog/dynamic-users-with-systemd.html
