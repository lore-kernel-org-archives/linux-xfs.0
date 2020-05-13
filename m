Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CAAC2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 06:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C1C206F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 06:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JHrEAGTF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgEMGWW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 02:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgEMGWW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 02:22:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D79EC061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 23:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OmjbLnqpzhHHYtk2/cRvhX5+DT3kE3tehQMfKZhfjfE=; b=JHrEAGTF6suIQEvxQCQfku7T9F
        3RMa/Hum1MY18yuspqv4SViwaGv1LEMcySlDYpW46Ab7Sh96v2tKkh+csBKk5OkIOW4D8/uuqQ1kQ
        +zbvA5PWVMuGJlk2IHH8ruEkdNimDsLtyqIWMayxvBfqYJ4jd4U3JPmA/vO3dq+anlEWM1W62NHFP
        BX9ODewJd0Hm4WciAR8PcHlSUQM8AZSC9zWocpQE/KFSUALqGoaAeXDuUSpD5iVLtpRbB4aCcqLi7
        bXXq5KFbZ1lA//ldLy4Q77cHoShytGTdqlFRNGrbLb2hGHLOsj0efgqL+r3a1svMKKnX/+nzdnpVK
        Vxti4RFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkmW-0000pp-2q; Wed, 13 May 2020 06:22:16 +0000
Date:   Tue, 12 May 2020 23:22:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 01/16] xfs_repair: fix missing dir buffer corruption
 checks
Message-ID: <20200513062216.GA24213@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904179840.982941.17275782452712518850.stgit@magnolia>
 <20200512172925.GJ6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512172925.GJ6714@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks ok, but it seems like da_read_buf should just return
the error instead of the b_error mess, at whih point we'd basically
have xfs_da_read_buf + the salvage flag.  But I guess we can apply
your patch first to let you make progress first and sort that
out later:

Reviewed-by: Christoph Hellwig <hch@lst.de>
