Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87511C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 18:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 669AF206F0
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 18:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IH5TznT5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGMSip (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 14:38:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54529 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbgGMSio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 14:38:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594665522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wJd/vUGee60BglI5/mI4bYutxPjX3dRZcg1GU13HU6U=;
        b=IH5TznT5FIRuZmp36y50WvS5RO23OAhQyvowZss1WQrLId2+xWkEbvHE+/92t3A+SzGC0D
        cfYUll53EwrTCT70fV83Bn0YTKaCPcZZ0pVJ+p/I2XQXeAOl73n8g5pnxGjwbwdPpgfwVR
        Sfq3oTxLFbkOWhqhIpxVhgWG6n4c9/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-KDObQ8HbOEaK5-QzEwOHVg-1; Mon, 13 Jul 2020 14:38:40 -0400
X-MC-Unique: KDObQ8HbOEaK5-QzEwOHVg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2E6419253C2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2020 18:38:39 +0000 (UTC)
Received: from Liberator.localdomain (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4332572E40
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2020 18:38:39 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [ANNOUNCE] xfsprogs for-next updated to 41865980
Message-ID: <9034a0e7-56a7-6cb6-afa1-8a8b1475ed61@redhat.com>
Date:   Mon, 13 Jul 2020 11:38:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Barring issues, this should soon get tagged as -rc1, and barring issues
there it should be 5.7.0 and maybe we'll get back on the release train
again...  That said if there's something you've sent that really should
make the 5.7.0 cut:

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

41865980 (HEAD -> for-next, origin/for-next, korg/for-next) xfs_repair: try to fill the AGFL before we fix the freelist

New Commits:

Darrick J. Wong (31):
      [eaa5b0b7] xfs_quota: fix unsigned int id comparisons
      [be752639] xfs_repair: fix missing dir buffer corruption checks
      [41f8fc57] xfs_repair: warn when we would have rebuilt a directory
      [cae4fd29] xfs_repair: check for AG btree records that would wrap around
      [2212e773] xfs_repair: fix bnobt and refcountbt record order checks
      [2a0f9efe] xfs_repair: check for out-of-order inobt records
      [db2a77d1] xfs_repair: fix rmapbt record order check
      [08280b4b] xfs_repair: tag inobt vs finobt errors properly
      [320cc3b2] xfs_repair: complain about bad interior btree pointers
      [dcd6c2e1] xfs_repair: convert to libxfs_verify_agbno
      [6271fa06] xfs_repair: refactor verify_dfsbno_range
      [a6bd55d3] xfs_repair: remove verify_dfsbno
      [04777511] xfs_repair: remove verify_aginum
      [15fd0ca2] xfs_repair: mark entire free space btree record as free1
      [f4cea8e8] xfs_repair: complain about free space only seen by one btree
      [32e11be9] xfs_repair: complain about extents in unknown state
      [0ce3577f] xfs_repair: complain about any nonzero inprogress value, not just 1
      [98206665] xfs_repair: drop lostblocks from build_agf_agfl
      [3acf0068] xfs_repair: rename the agfl index loop variable in build_agf_agfl
      [49031e66] xfs_repair: make container for btree bulkload root and block reservation
      [cca4dbfe] xfs_repair: inject lost blocks back into the fs no matter the owner
      [79f86c9d] xfs_repair: create a new class of btree rebuild cursors
      [7e5ec4e4] xfs_repair: rebuild free space btrees with bulk loader
      [7a21223c] xfs_repair: rebuild inode btrees with bulk loader
      [dc9f4f5e] xfs_repair: rebuild reverse mapping btrees with bulk loader
      [3c1ce0fc] xfs_repair: rebuild refcount btrees with bulk loader
      [e75cef63] xfs_repair: remove old btree rebuild support code
      [c94d40ce] xfs_repair: use bitmap to track blocks lost during btree construction
      [a891d871] xfs_repair: complain about ag header crc errors
      [6ffc9523] xfs_repair: simplify free space btree calculations in init_freespace_cursors
      [41865980] xfs_repair: try to fill the AGFL before we fix the freelist

Eric Sandeen (1):
      [e48f6fbc] xfs_repair: remove gratuitous code block in phase5

Gao Xiang (1):
      [6df28d12] xfs_repair: fix rebuilding btree block less than minrecs


Code Diffstat:

 include/libxfs.h         |    1 +
 libxfs/libxfs_api_defs.h |   12 +
 quota/edit.c             |   22 +-
 repair/Makefile          |    4 +-
 repair/agbtree.c         |  696 +++++++++++++
 repair/agbtree.h         |   62 ++
 repair/attr_repair.c     |    2 +-
 repair/bulkload.c        |  140 +++
 repair/bulkload.h        |   62 ++
 repair/da_util.c         |   25 +-
 repair/dino_chunks.c     |    6 +-
 repair/dinode.c          |  109 +-
 repair/dinode.h          |   14 -
 repair/dir2.c            |   21 +
 repair/phase4.c          |   11 +-
 repair/phase5.c          | 2577 ++++++----------------------------------------
 repair/phase6.c          |    3 +
 repair/prefetch.c        |    9 +-
 repair/sb.c              |    3 +-
 repair/scan.c            |  166 ++-
 repair/xfs_repair.c      |   17 +
 21 files changed, 1502 insertions(+), 2460 deletions(-)
 create mode 100644 repair/agbtree.c
 create mode 100644 repair/agbtree.h
 create mode 100644 repair/bulkload.c
 create mode 100644 repair/bulkload.h

