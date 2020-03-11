Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B298C10F25
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B625208C4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgCKF7e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:59:34 -0400
Received: from verein.lst.de ([213.95.11.211]:57297 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKF7d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Mar 2020 01:59:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B695968C4E; Wed, 11 Mar 2020 06:59:31 +0100 (CET)
Date:   Wed, 11 Mar 2020 06:59:31 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: remove the unused return value from
 xfs_log_unmount_write
Message-ID: <20200311055931.GA10699@lst.de>
References: <20200306143137.236478-1-hch@lst.de> <20200306143137.236478-2-hch@lst.de> <20200306160917.GD2773@bfoster> <20200309080252.GA31481@lst.de> <20200310222856.GR10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310222856.GR10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 09:28:56AM +1100, Dave Chinner wrote:
> FWIW, I'm typing limited at the moment because of a finger injury.
> 
> I was planning to rebase mine on the first 6 patches of this series
> (i.e. all but the IOERROR removal patch) a couple of days ago, but
> I'm really slow at getting stuff done at the moment. So if Darrick
> is happy with this patchset, don't let my cleanup hold it up.

Get better soon.  I'll resend just the trivial cleanups for now.
