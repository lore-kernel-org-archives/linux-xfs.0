Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9CEC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Dec 2022 11:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLPLCP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Dec 2022 06:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLPLCN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2022 06:02:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9B1656F
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 03:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB88A62053
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 11:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952F5C433D2
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2022 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671188527;
        bh=wWF+0HjUEXTIwtENKmcAmMcAqL8Q41SHKDKS2OiXGDc=;
        h=Date:From:To:Subject:From;
        b=milzhD0cwkRCxZ1G+APwIpKDd57cc+bF9kXiGkGp3tF/JEVWG5yz+kvLH5FMf0ybd
         eMY8IxbQ/QVnBx2aPDNbxXqElbChh7ZG5iEttMa//sRx/uSE/Bd0563/MPY+y/OIcn
         B02lnAQVrd+G37SAmL66Bd+t4zkY4iggJRnc2QAxae8bHqaT8NQQf7r/+5j8To0+mL
         dYII3c5YwN1Puc41QnQpYbViiMm/aVmF7/v1qygZwz6R0lYr+YhVm9+VjARe8qIx7a
         5qqzTSdbX5wAuLlOLFo53gY6swQgoPEJEJqKEoOGGaTIjNDfB8egwBBNbwJ93uFo3k
         7dSZu3O0OLNWw==
Date:   Fri, 16 Dec 2022 12:02:03 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump: Release 3.1.12
Message-ID: <20221216110203.f4q3asbudhtva3er@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

acb8083 xfsdump: Release 3.1.12

New Commits:

Carlos Maiolino (1):
      [acb8083] xfsdump: Release 3.1.12

Donald Douwsma (4):
      [06dd184] xfsrestore: fix on-media inventory media unpacking
      [6503407] xfsrestore: fix on-media inventory stream unpacking
      [7b843fd] xfsdump: fix on-media inventory stream packing
      [aaaa57f] xfsrestore: untangle inventory unpacking logic


Diffstat:

 VERSION               |  2 +-
 configure.ac          |  2 +-
 debian/changelog      |  6 ++++++
 doc/CHANGES           |  3 +++
 inventory/inv_stobj.c | 42 +++++++++++++++---------------------------
 restore/content.c     | 13 +++++--------
 6 files changed, 31 insertions(+), 37 deletions(-)


-- 
Carlos Maiolino
