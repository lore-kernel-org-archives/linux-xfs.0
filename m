Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB48C2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 940CD20753
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bQ70X/zF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDFXYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 19:24:46 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39372 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgDFXYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 19:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586215485; x=1617751485;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PWXM5Vnf7Ub24JzZyhawbUoLMkQV0ReR39UaWLNsuFk=;
  b=bQ70X/zFpFOl6OEFXdHfJ/3TEN5h0WcMmWjBzWNGufF8hfpZSiAaeJQo
   zj0UgMkqLJegupuHwHR4BED/lcQcoTAPS72f9YxIt0tNlEWHlQoEBFVYF
   6st0R35HhuS4+hxCjxcFAY7GRkI3S93bdmNeezvVnn+FanIn2p6IJ46GD
   RHURWK0PFAMpHMUASdNnZ1c0Sk0XL8ipLn4ed49QmCbLcO8zG8HnLUcAJ
   VZAnB50cpNQfF/wNOtzqEOecyznziZOaAJSd2IkW1o/sivqrEOqqgJCeH
   B4lPqGMQ0EnZ/aSNoyJ6G9n8HsPuTV8XVL1v+qHEYpC3e3rmqM/Dd5esP
   g==;
IronPort-SDR: iKXtbDPNkepo8Ic6T5lTO/03xBvN1bqiO4P8ig6t9oc5VLSSZu3hJQCCUOPQpMdprlEiVCaBgk
 6RlzRt2OYiAyQiSSB6q7IzMev/OZg4VHUS06nCApCyX43ZGG0qo3a3muUEf2mb2mvLanU5LJOE
 RpoIzCIhWMaC5pzu9N4428UtqmYN24XgCPZyZHXfYYNuWtMocrpBFK4uNhT+5hTCO6oweAXxCd
 e+LthTsAfnkpV1hLie4rbcY7Qs9sGgI9Vy5qKeBmZVZB2Uf8pmKC7xgBoogyVmCcpefls/5IA3
 VT8=
X-IronPort-AV: E=Sophos;i="5.72,352,1580745600"; 
   d="scan'208";a="134723657"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2020 07:24:45 +0800
IronPort-SDR: jut2gkxciVHxFTVFST6gYIlXkCvouTJ/RzxZ0WwdeJidXSiLFcpVV4f7NXK2mcdROno0sH29Li
 hN8Z7Hg4Duxdmvv2tQ2XU1e1vnK+c4sJ9NO97sMllFwoMvRw8ZG0WesGlQuqNbZBZxSxVnnFGh
 hSAVpFsXU2wZg+1wm0EMLvI+EHAJZYK+NHfCsxZlT7uY0V7p5Bn/frewgFd2D3N5DmKHrDJkHL
 +sB65cDj32tr5xZvyFh+3d73JsvTpqsecOi3o9UnhyZAVq9WgXiB21OQwq/WyIeQOLvpIuHscf
 zgSnZEH5xEAZGEPtWAIg/KCC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 16:15:29 -0700
IronPort-SDR: vuitbyVpHpJm5Y18/far9MDEQ0NQhQCBQwSmMip/qDf8xeybiWqaK3pW1/2eNkSdV/c4GYxKX8
 uY5EZ9QmaLQ+5L6iyt58rTiap55MK2I07TgcIrk06ClUOrQZ/NU0+jBWi8ZUEV8eoomVDNhRIP
 AfxJ6Yjc2cCv/PltOGcHh0CrswNT6Nmv3MZoQqJKtFFApGOsK1jkRtMlaIfPKMmd4cj7x99ZuV
 H6z50Cb7nefneizQh/QsgSYStpep05hTKKUN7uZsGL3f0DeewidZ3kaZrEbOrOC7IBEs3JnXhH
 RPE=
WDCIronportException: Internal
Received: from iouring.labspan.wdc.com (HELO iouring.sc.wdc.com) ([10.6.138.107])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Apr 2020 16:24:45 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, danil.kipnis@cloud.ionos.com,
        jinpu.wang@cloud.ionos.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 0/2] block: add bio based read-write helper
Date:   Mon,  6 Apr 2020 16:24:38 -0700
Message-Id: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

With reference to the discussion [1] on the linux-block mailing list,
this patch series adds a helper to map the buffer to bio and provides
two variants for synchronous and asynchronous I/O submission.

Right now only XFS is the only user, once gets accepted block/rnbd [2]
code can re-use this helper and we can avoid code duplication. 

Please note that I've not tested the XFS patch yet, once I get some
feedback, I'll add a test for the same in the xfstests. It will be
great if XFS developers can provide some insight into testing log
related code which used this helper.

Regards,
Chaitanya

[1] Linux-Block Mailing list discussion on the same topic :-

https://www.spinics.net/lists/linux-block/msg51040.html
https://www.spinics.net/lists/linux-block/msg51462.html
https://www.spinics.net/lists/linux-block/msg51465.html
https://www.spinics.net/lists/linux-block/msg51480.html

Chaitanya Kulkarni (2):
  block: add bio based rw helper for data buffer
  xfs: use block layer helper for rw

 block/blk-lib.c        | 105 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bio_io.c    |  47 +-----------------
 include/linux/blkdev.h |   7 +++
 3 files changed, 114 insertions(+), 45 deletions(-)

-- 
2.22.1

