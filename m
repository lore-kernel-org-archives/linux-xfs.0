Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12573C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC72123102
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 15:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbhAMPbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 10:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbhAMPbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 10:31:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947BEC061575
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 07:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E6DIFoE2dk1btjiba6Tgysy25Jium0pjLsuRYDWNqOw=; b=PcufTmbAVuhiTg1fdht+8OytMr
        n56aHmfjHD5bIdMSIDpokdax2pCcVcsATfy8SEoxfcgWIKsWStrJu+p0vHAnZGJJicZnr6rHq7vCV
        oRuJKQySljsGjmjCk2/FiYzsIs1i0A79cvLZRy9K5x0X7H14OSzcMnD/owM27K8Ens8/tvBpzWVly
        6CDSDxRT6oKosthXzrjfy7g//9kukFgE6OUVaZOxrdcXWhzy7XZ9NYQ2RaNqRWetrRJhg5xmrTfDe
        N27uf17ymDLh/99apdkowamTyVQ6FI8eujex2CEADIuRi3BvOYg17jaV+pXhvYx9nX32Ggmzi+eNW
        xa2s+O4A==;
Received: from 213-225-33-181.nat.highway.a1.net ([213.225.33.181] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzi6T-006PmR-Tj; Wed, 13 Jan 2021 15:30:46 +0000
Date:   Wed, 13 Jan 2021 16:30:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: separate log cleaning from log quiesce
Message-ID: <X/8SGAWPfeQuK7P1@infradead.org>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:21PM -0500, Brian Foster wrote:
> Log quiesce is currently associated with cleaning the log, which is
> accomplished by writing an unmount record as the last step of the
> quiesce sequence. The quiesce codepath is a bit convoluted in this
> regard due to how it is reused from various contexts. In preparation
> to create separate log cleaning and log covering interfaces, lift
> the write of the unmount record into a new cleaning helper and call
> that wherever xfs_log_quiesce() is currently invoked. No functional
> changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
