Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880A5C77B75
	for <linux-xfs@archiver.kernel.org>; Mon, 22 May 2023 10:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjEVKVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 May 2023 06:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjEVKVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2023 06:21:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF1510D
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 03:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2229360F01
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 10:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0158EC433D2
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 10:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684750880;
        bh=825A1lTzGX+UNCXXxf+qq/rx5BOEZXNCP5YsbcqSnAY=;
        h=Date:From:To:Subject:From;
        b=EoWbmL0oK63uXeNFHU2mB4CoiiCVn6LyuQd0pMU6sZVuyQTKsZHFvZfGpgAd+iB+A
         7URpD/YD3mchcLflucSjapaCusa7UDRtmnKIRwYI89A6yqMgB6XubIa1Em2A0rOkHf
         rG0TyIQEYYDOahkApOCZgBy/LoUTN1gsFU9VxS35G2jqm8gh2jJSpqn/KVTv3rt5VW
         TJUR0jSqG1DpS8gohmJARdj01DYg0B15re7WIkc9uusEJRo/LBKW7bRK/38PByblX1
         jetEI17iM9fwdWtu35kHb8Ef8P3YaIqPllVtBW5p8tcj4RQTZvGbooG3KU9MVglzh9
         oSbBKz4thTf1Q==
Date:   Mon, 22 May 2023 12:21:16 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs-6.3.0 released
Message-ID: <20230522102116.imbaxmxeucfbhfit@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

xfsprogs version 6.3 has just been released.
This is the latest stable version of xfsprogs.

The official xfsprogs repository, located at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

Has been updated to reflect this release with both master and for-next branches
updated to this release.

The new head of both branches is commit: f499ee5cf0aa520ed7489249e2e465587ae19c59

Any questions, please let me know.

-- 
Carlos Maiolino
