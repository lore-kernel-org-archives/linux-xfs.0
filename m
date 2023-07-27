Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1294C00528
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 18:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbjG0Sx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 14:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjG0SxV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 14:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D7619A7;
        Thu, 27 Jul 2023 11:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC8161E90;
        Thu, 27 Jul 2023 18:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B72EC433C7;
        Thu, 27 Jul 2023 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690483999;
        bh=6kbvoCzsReRC1xzMWYgr42KCQaZAqZUu3SukIu8Kwl0=;
        h=From:To:Cc:Subject:Date:From;
        b=ilKH8KUTg1pzGde6eqIFi+v6meI+Oq5rDsHCHyvJDIt/pMxHRTEloREaXJue3r9MY
         4ochyEXZdymSUsOmhIIouHL52UU/tMY9SmIFgnu0Fr7gzNxjm3mIXeC5j930BMY4sg
         ugGnb9XSJOIvIC0cOAxakAm6HYniHbtEZvUimWXtgKeOsyuYk5M3IMD7xXHLOcnqJo
         WlVwM16BmsrCmxBTk+fqiu1Rk0N4J1+NxcQfmQjpgPInMzgVJV7QmuAmWI7d0v8O2N
         KSjfc9SVln0T5X9ebCKwq7DYRO2fEzxMm48dvkXPKA5k5iXwXmnRUIRlD4XNrSGOuq
         P5K84B7wgx9OA==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     tytso@mit.edu, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] add smoketest group and try to provide template
Date:   Fri, 28 Jul 2023 02:53:13 +0800
Message-Id: <20230727185315.530134-1-zlang@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patch [1/2] is a general patch, please review it as usual.

The patch [2/2] is RFC, by talking with Darrick, we agree to split this
part from original [1/2], as RFC patch, to get separated review points.
If any of you feel it's good, feel free to give it RVB, or feel free to
share your review points.

More details refer to each patch commit log.


History:
https://lore.kernel.org/fstests/20230727153046.dl4palugnyidxoe7@zlang-mailbox/T/#m32ce9c4c316438074b068bd38c5e2dc6b0d53f42
https://lore.kernel.org/fstests/20230727030529.r4ivp6dmtrht5zo2@zlang-mailbox/T/#t

Thanks,
Zorro
