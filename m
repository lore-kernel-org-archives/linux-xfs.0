Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B05C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E8420874
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgJBHco (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:32:44 -0400
Received: from verein.lst.de ([213.95.11.211]:51353 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJBHco (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 03:32:44 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 99A3C67357; Fri,  2 Oct 2020 09:32:41 +0200 (CEST)
Date:   Fri, 2 Oct 2020 09:32:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH v4.2 5/5] xfs: xfs_defer_capture should absorb
 remaining transaction reservation
Message-ID: <20201002073241.GA10329@lst.de>
References: <160140139198.830233.3093053332257853111.stgit@magnolia> <160140142459.830233.7194402837807253154.stgit@magnolia> <20201002042103.GU49547@magnolia> <20201002072416.GD9900@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002072416.GD9900@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 09:24:16AM +0200, Christoph Hellwig wrote:
> What about just embedding the struct xfs_trans_res into
> struct xfs_defer_capture directly?  That probably also means merging
> this and the previous patch.

Strike that as it doesn't make a whole lot of sense.  More coffee..
