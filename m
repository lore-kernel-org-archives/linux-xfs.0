Return-Path: <SRS0=DzrB=EM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B215C5517A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 07:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3F7121707
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Nov 2020 07:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgKFHp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:45:26 -0500
Received: from verein.lst.de ([213.95.11.211]:50382 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgKFHpZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Nov 2020 02:45:25 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 53DC468B02; Fri,  6 Nov 2020 08:45:22 +0100 (CET)
Date:   Fri, 6 Nov 2020 08:45:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        fdmanana@kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: remove lockdep bogosity in __sb_start_write
Message-ID: <20201106074521.GA31133@lst.de>
References: <160463582157.1669281.13010940328517200152.stgit@magnolia> <160463582800.1669281.17833985365149618163.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160463582800.1669281.17833985365149618163.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
