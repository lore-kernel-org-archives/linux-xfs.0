Return-Path: <SRS0=/boU=7L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4AAC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 20:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1DCF206C3
	for <linux-xfs@archiver.kernel.org>; Fri, 29 May 2020 20:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XqOxZivM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgE2U1e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 May 2020 16:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgE2U1e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 May 2020 16:27:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0137C03E969;
        Fri, 29 May 2020 13:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zPMXHGinvpmbOO2uHJoJ8DYwUQB9G7uW/4dEVS7cJ0I=; b=XqOxZivMEezkHFFqWL9Ubo1yCp
        jYuOb6sadXa65JFn7RehjWvI6opK1yjZQNHP+FDKbzLYVhzNUNA0D7wftRwkHW+pgbPcxnB0sEqaL
        sJhErbLN7ury7gOpdmM/R/bMc1mCd5cQQnOMfSMcdISKzShPzjyGTcZUh+Ep89jaovMmp1tWEn9ct
        kRirdyfCQoBe/cDzS1Xc/MQRw4h5hxdPUopYIEJ0glXskivBMitIDKEJj39t9CkkbIZdGp+f9dJXh
        +2HTf7n8uxWwyxrZuZN981ukwk2fuHPhi1ap6J+VubHIq6FfJrVSsQf4pMRUdII6H59MXDlDUQOJd
        a14fe67A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jelaz-0008Ci-I1; Fri, 29 May 2020 20:27:13 +0000
Date:   Fri, 29 May 2020 13:27:13 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Kaitao Cheng <pilgrimtao@gmail.com>
Cc:     axboe@kernel.dk, hch@lst.de, sth@linux.ibm.com,
        viro@zeniv.linux.org.uk, clm@fb.com, jaegeuk@kernel.org,
        hch@infradead.org, mark@fasheh.com, dhowells@redhat.com,
        balbi@kernel.org, damien.lemoal@wdc.com, bvanassche@acm.org,
        ming.lei@redhat.com, martin.petersen@oracle.com, satyat@google.com,
        chaitanya.kulkarni@wdc.com, houtao1@huawei.com,
        asml.silence@gmail.com, ajay.joshi@wdc.com,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        hoeppner@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, sagi@grimberg.me,
        linux-nvme@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, chao@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        ocfs2-devel@oss.oracle.com, deepa.kernel@gmail.com
Subject: Re: [PATCH v2] blkdev: Replace blksize_bits() with ilog2()
Message-ID: <20200529202713.GC19604@bombadil.infradead.org>
References: <20200529141100.37519-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529141100.37519-1-pilgrimtao@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 29, 2020 at 10:11:00PM +0800, Kaitao Cheng wrote:
> There is a function named ilog2() exist which can replace blksize.
> The generated code will be shorter and more efficient on some
> architecture, such as arm64. And ilog2() can be optimized according
> to different architecture.

We'd get the same benefit from a smaller patch with just:

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1502,15 +1502,9 @@ static inline int blk_rq_aligned(struct request_queue *q, unsigned long addr,
 	return !(addr & alignment) && !(len & alignment);
 }
 
-/* assumes size > 256 */
 static inline unsigned int blksize_bits(unsigned int size)
 {
-	unsigned int bits = 8;
-	do {
-		bits++;
-		size >>= 1;
-	} while (size > 256);
-	return bits;
+	return ilog2(size);
 }
 
 static inline unsigned int block_size(struct block_device *bdev)
