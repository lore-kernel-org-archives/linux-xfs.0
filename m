Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FADEC77B7A
	for <linux-xfs@archiver.kernel.org>; Tue, 30 May 2023 17:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjE3RCf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 May 2023 13:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjE3RCe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 May 2023 13:02:34 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6C44115
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 10:02:11 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPS id 15F6A5CC102
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 12:02:05 -0500 (CDT)
Message-ID: <2777daf5-42e0-4350-9e0e-96a1fe68a039@sandeen.net>
Date:   Tue, 30 May 2023 12:02:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Content-Language: en-US
To:     linux-xfs@vger.kernel.org
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: XFS_AG_MIN_BLOCKS vs XFS_MIN_AG_BLOCKS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I got a bug report that REAR was trying to recreate an xfs filesystem 
geometry by looking at the xfs_info from the original filesystem.

In this case, the original fs was:

meta-data=/dev/mapper/vg-lv_srv  isize=512    agcount=400, agsize=6144 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=0
          =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=2453504, imaxpct=25
          =                       sunit=16     swidth=16 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1872, version=2
          =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

(horribly pessimal, almost certainly the result of xfs_growfs)

But the point is, the last AG is only 8MB. However, mkfs.xfs refuses to 
make an AG less than 16MB. So, this fails, because agcount was specified 
and mkfs won't reduce it to fix the too-small AG:

# truncate --size=10049552384 fsfile
# mkfs.xfs -f -m uuid=23ce7347-fce3-48b4-9854-60a6db155b16 -i size=512 
-d agcount=400 -s size=512 -i attr=2 -i projid32bit=1 -m crc=1 -m 
finobt=1 -b size=4096 -i maxpct=25 -d sunit=128 -d swidth=128 -l 
version=2 -l sunit=128 -l lazy-count=1 -n size=4096 -n version=2 -r 
extsize=4096 fsfile
mkfs.xfs: xfs_mkfs.c:3016: align_ag_geometry: Assertion 
`!cli_opt_set(&dopts, D_AGCOUNT)' failed.

I think this is the result of mkfs.xfs using 16MB as a limit on last AG 
size:

#define XFS_AG_MIN_BYTES                ((XFS_AG_BYTES(15)))    /* 16 MB */
#define XFS_AG_MIN_BLOCKS(blog)         (XFS_AG_MIN_BYTES >> (blog))

But growfs uses this:

#define XFS_MIN_AG_BLOCKS       64

(which is much smaller than 16MB).

This should almost certainly be consistent between mkfs and growfs, and 
my guess is that growfs should start using the larger XFS_AG_MIN_BLOCKS 
requirement that mkfs.xfs uses?

Thanks,
-Eric
