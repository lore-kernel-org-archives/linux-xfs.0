Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfFYAoM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 20:44:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D210F3091851
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 00:44:12 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FB475C231
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 00:44:12 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: don't fragment files with ZERO_RANGE calls
Message-ID: <ace9a6b9-3833-ec15-e3df-b9d88985685e@redhat.com>
Date: Mon, 24 Jun 2019 19:44:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

the ZERO_RANGE fallocate mode currently punches out
the requested range, then reallocates it as unwritten extents.

This is fine, but the re-allocation fragments the file when we could
be converting in place:

$ rm -rf moo ; fallocate -l 16m moo ; xfs_io -c "bmap -vp" -c 'fzero 1m 64k' -c "bmap -vp"  moo
moo:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL FLAGS
   0: [0..32767]:      187007640..187040407  2 (52789912..52822679) 32768 10000
moo:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL FLAGS
   0: [0..2047]:       187007640..187009687  2 (52789912..52791959)  2048 10000
   1: [2048..2175]:    187040408..187040535  2 (52822680..52822807)   128 10000
   2: [2176..32767]:   187009816..187040407  2 (52792088..52822679) 30592 10000


$ rm -rf moo ; xfs_io -f -c "pwrite 0 16m" -c "bmap -vp"  -c 'fzero 1m 64k' -c "bmap -vp" moo
wrote 16777216/16777216 bytes at offset 0
16 MiB, 4096 ops; 0.0000 sec (124.504 MiB/sec and 31873.0060 ops/sec)
moo:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL FLAGS
   0: [0..32767]:      187605400..187638167  2 (53387672..53420439) 32768 00000
moo:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL FLAGS
   0: [0..2047]:       187605400..187607447  2 (53387672..53389719)  2048 00000
   1: [2048..2175]:    187670808..187670935  2 (53453080..53453207)   128 10000
   2: [2176..65407]:   187607576..187670807  2 (53389848..53453079) 63232 00000

We did it this way in part to utilize xfs_free_file_space's partial block 
zeroing capabilities, so factor that out, then use it + xfs_alloc_file_space
to convert in place.
