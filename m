Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD5FC433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE1B611AD
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhECVfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 17:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhECVfh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 17:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B36BB611AC;
        Mon,  3 May 2021 21:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620077683;
        bh=hdQIHs8nrpDNGWZsZN9AjoZpYqo/1+65XHSGADYtoMg=;
        h=Subject:From:To:Cc:Date:From;
        b=bHEHoCNNAXL3/n4c75SKv8wmJKV7tJlU33bFBo1QbMpyjrlGYMcD1p4vV7tNK5pqz
         AxPhPrT/0jqdMnPGX7GuqP21FVUHAfFDULuRRt6PITlOvo2rjs6NAwyHIbyvpPZzx5
         0KlD4cSstEM1FCpB3yNvdHBZ1Gnugi1yvdsGzS/dsVFcb7++UepS+1xX1/docUiCs3
         +DCaTkllPqmWT9XoFnO7WAl5NjBkcJkVLnFg2CVtJrZ92xUsCOtk7dj5JSiKhPBhsb
         LMSPNBOtcx9wTonKzsJhIUXvGyBWHnvjYMoCCKozZt2+ytmvTguEd94kSusyOOdxih
         fEtZifJTYq33w==
Subject: [PATCHSET 0/2] xfs: realtime allocator fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 03 May 2021 14:34:43 -0700
Message-ID: <162007768318.836421.15582644026342097489.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains two fixes for bugs I saw in the realtime allocator.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
---
 fs/xfs/xfs_bmap_util.c |   96 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 70 insertions(+), 26 deletions(-)

