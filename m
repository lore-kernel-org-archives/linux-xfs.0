Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC553EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 14:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjF1OOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 10:14:47 -0400
Received: from dfw.source.kernel.org ([139.178.84.217]:47070 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjF1OOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 10:14:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B8B160DDF
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 14:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92902C433C0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687961685;
        bh=OwVtLQknFDK0dMfdE5+FrHmY2a9/m3szYO0B3VLEJcQ=;
        h=Date:From:To:Subject:From;
        b=CvbfgLpsQzXaVl/gbu+wRWcAb+RAwmtBEbeb0PkcnQtNF+3069IblaA6dSFujPkDX
         9pVUP58t4bwIkF6nBoC0U3S3D3cpFkurNpfPdLskidShDXISEAhHQX957TzhVwguDx
         XVMP4cqw6EH81h4DT0LDNnILTwmQWcKVjrY+mk7flfN3aM2hzvUnvJH+VrB4KBr0TE
         YO32Gc+9mrr5AfDU6XeqXuQeiOxNySba3/bAdmAfbF0hwetB5tW06K3PH/zA7EWoKF
         V1j9Uy3lEfHvn6PPQ2xecRfnUKB6eJGY53Ypnunes05ZAIwq7+PQ/WZFvfbwHrFCnK
         ctHHTZJPVdPqA==
Date:   Wed, 28 Jun 2023 16:14:41 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to e05d65121
Message-ID: <20230628141441.j6n7anpsxamw5pay@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

e05d65121e7dc97a2b010d87514187fec28e4eb4

10 new commits:

Darrick J. Wong (10):
      [5a9c316e3] xfs_repair: don't spray correcting imap all by itself
      [61872b1b2] xfs_repair: don't log inode problems without printing resolution
      [3668ccd82] xfs_repair: fix messaging when shortform_dir2_junk is called
      [42453d22a] xfs_repair: fix messaging in longform_dir2_entry_check_data
      [54f51a36c] xfs_repair: fix messaging when fixing imap due to sparse cluster
      [ceec18a22] xfs_repair: don't add junked entries to the rebuilt directory
      [3f734ce4c] xfs_repair: always perform extended xattr checks on uncertain inodes
      [36f558c4f] xfs_repair: check low keys of rmap btrees
      [144a92750] xfs_repair: warn about unwritten bits set in rmap btree keys
      [e05d65121] xfs_db: expose the unwritten flag in rmapbt keys

Code Diffstat:

 db/btblock.c         |  4 ++++
 repair/dino_chunks.c | 14 ++++++------
 repair/phase6.c      | 46 ++++++++++++++++++----------------------
 repair/scan.c        | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 90 insertions(+), 34 deletions(-)

-- 
Carlos
