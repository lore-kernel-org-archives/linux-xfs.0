Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B011CCDB482
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbjJSQUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjJSQUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:20:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E06130
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:20:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750B1C433C8;
        Thu, 19 Oct 2023 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732445;
        bh=tu0wbYFg9KSL92AKBeHo+bcGiJx/XFKmOS6QBs5XCHw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Wt1gRLqiKJQHt7dyEOL9XSgHwzHQpZpuVXxx6XQROK/n5+ciQy//J/9sXkT129DRn
         ddb4DlkYBDpx3RXAQMuZR4oLSzRtl431soAr8vYCBNOP9LenDTHoDXTrn1cQuNwuhJ
         PwLMNiiM4mDmdGih4ZtJ6ky9rpnhCz5wK9FDuDV1lZsEn+q5ywxVmPgTheVsAXEP+x
         QRDlJwvaYfmcU8ET/lCsFa7uo8z4f9YIYi+ouq7/nn5sPcL0XYyRemu6DmQCIZAJSo
         zPtyRQaNpJYhg7HmtCO81pbc0Y5lVyQlYZL7BebHrHThKowSnujuBVN/qTKpxOW5cQ
         uqcdxLOywBiIQ==
Date:   Thu, 19 Oct 2023 09:20:45 -0700
Subject: [PATCHSET v1.1 0/5] xfs: refactor rtbitmap/summary macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210961.225536.12900854938759335651.stgit@frogsfrogsfrogs>
In-Reply-To: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
References: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In preparation for adding block headers and enforcing endian order in
rtbitmap and rtsummary blocks, replace open-coded geometry computations
and fugly macros with proper helper functions that can be typechecked.
Soon we'll be needing to add more complex logic to the helpers.

v1.1: various cleanups suggested by hch

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rtbitmap-macros-6.7
---
 fs/xfs/libxfs/xfs_format.h     |   16 -----
 fs/xfs/libxfs/xfs_rtbitmap.c   |  142 +++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_rtbitmap.h   |  100 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    9 +--
 fs/xfs/libxfs/xfs_types.h      |    2 +
 fs/xfs/scrub/rtsummary.c       |   23 +++---
 fs/xfs/xfs_rtalloc.c           |   22 +++---
 7 files changed, 218 insertions(+), 96 deletions(-)

