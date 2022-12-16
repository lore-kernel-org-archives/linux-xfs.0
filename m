Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3051C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Dec 2022 11:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiLPLRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Dec 2022 06:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiLPLQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2022 06:16:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5DBD2F0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 03:16:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB8D66206B
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 11:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8658AC433D2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 11:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671189415;
        bh=8HkXEeD+4hBhIpGAwDI71EGunqn0RFMPlIS2yF2sjak=;
        h=Date:From:To:Subject:From;
        b=jBd49SVfr0AYCkT/t2g3l/d46qf0Sr5Ja22b+q2IOm+IlOLufeKu406shoXZPB9cE
         XThryULaEvi/86/8qgMxXwWmNcfFp61mUjmdB86Tn6v7qgRxsOZO+1qbuZDGAtCaol
         +HzfJUWvsSWxRc2adQ2is7eSRuJlgLzrChLwAJ3rJWJmoIWn32c80iEtJI7QHsJaqO
         GSR6qGiBSVmQsPP5S1EWe1PUxe4pzayY6ppJFBHVkDM91eXrkyUyxjyq6ZXD3pD8wH
         VeyVrT1SaEpdKH/xDfo2jvwTMYfXlVU3ggNRHvGfAvgoM9CDLOqcUWsSp0aiQlHN+I
         SHTPOahHdgL7g==
Date:   Fri, 16 Dec 2022 12:16:51 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs for-next branch updated
Message-ID: <20221216111651.ylojopwze3f7bwae@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello folks.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/?h=for-next

has just been updated.

Unless any urgent bug fix appears during the next week, this is the last batch
of patches staged for release 6.1, scheduled to be released next Friday.



New head:

79ba1e15d fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair

New commits:

Darrick J. Wong (2):
      [f6fb1c078] xfs_io: don't display stripe alignment flags for realtime files
      [e229a59f0] xfs_db: create separate struct and field definitions for finobts

Srikanth C S (1):
      [79ba1e15d] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair



Cheers, and happy holidays.

-- 
Carlos Maiolino
