Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEADC41513
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 15:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbjJLPKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347278AbjJLPKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 11:10:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8F0BE;
        Thu, 12 Oct 2023 08:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AHEAS3BlGvBcTUKNOms6qt/iO/
        G1728jJ+mT+DY1bMt6c5qSQmz0B5MioeIV0JKSq3E0OO5QHZs6VMwf/+g9p2U/tqVJFXFxfF0Sohc
        RaAaqmLcWOQorK0h+eJL4StdWlRbLwuTapfv+737lriTh86WpmKELds47d8MpJrzaRFVVfbeKPvnH
        OXrUSLZWYYRMkPHId/0x5vZVrfz7ZJWUzISbdqtttHshOx2d50chO7TJrs/eDTQPGw7wp5sWizqe6
        3KoJcfSCjHbKGcGf5T/yMVCRql7See8cWBL3s0XgiA2iDeq5dGmVYvK9X10oU9H5gcpvJkgGViYzF
        x3ewODNA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqxKL-001Fv8-2G;
        Thu, 12 Oct 2023 15:10:17 +0000
Date:   Thu, 12 Oct 2023 08:10:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH v2 1/3] xfs/178: don't fail when SCRATCH_DEV contains
 random xfs superblocks
Message-ID: <ZSgMWS61dTM0z+k8@infradead.org>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
 <20231012150922.GF21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012150922.GF21298@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
