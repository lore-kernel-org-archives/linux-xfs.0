Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1266BC77B73
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 01:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjEWBCB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 May 2023 21:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbjEWBBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2023 21:01:36 -0400
Received: from out28-38.mail.aliyun.com (out28-38.mail.aliyun.com [115.124.28.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAABE78;
        Mon, 22 May 2023 17:59:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1252176|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0240655-4.02396e-05-0.975894;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.T9RQ-uT_1684803569;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.T9RQ-uT_1684803569)
          by smtp.aliyun-inc.com;
          Tue, 23 May 2023 08:59:30 +0800
Date:   Tue, 23 May 2023 08:59:30 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     cluster-devel@redhat.com
Subject: gfs2 write bandwidth regression on 6.4-rc3 compareto 5.15.y
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-Id: <20230523085929.614A.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

gfs2 write bandwidth regression on 6.4-rc3 compare to 5.15.y.

we added  linux-xfs@ and linux-fsdevel@ because some related problem[1]
and related patches[2].

we compared 6.4-rc3(rather than 6.1.y) to 5.15.y becasue some related patches[2]
work only for 6.4 now.

[1] https://lore.kernel.org/linux-xfs/20230508172406.1CF3.409509F4@e16-tech.com/
[2] https://lore.kernel.org/linux-xfs/20230520163603.1794256-1-willy@infradead.org/


test case:
1) PCIe3 SSD *4 with LVM
2) gfs2 lock_nolock
    gfs2 attr(T) GFS2_AF_ORLOV
   # chattr +T /mnt/test
3) fio
fio --name=global --rw=write -bs=1024Ki -size=32Gi -runtime=30 -iodepth 1
-ioengine sync -zero_buffers=1 -direct=0 -end_fsync=1 -numjobs=1 \
	-name write-bandwidth-1 -filename=/mnt/test/sub1/1.txt \
	-name write-bandwidth-2 -filename=/mnt/test/sub2/1.txt \
	-name write-bandwidth-3 -filename=/mnt/test/sub3/1.txt \
	-name write-bandwidth-4 -filename=/mnt/test/sub4/1.txt
4) patches[2] are applied to 6.4-rc3.


5.15.y result
	fio WRITE: bw=5139MiB/s (5389MB/s),
6.4-rc3 result
	fio  WRITE: bw=2599MiB/s (2725MB/s)

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/05/23


