Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91005C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 09:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F99C20771
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 09:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgCRJin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 05:38:43 -0400
Received: from verein.lst.de ([213.95.11.211]:35879 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgCRJin (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Mar 2020 05:38:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C498968C65; Wed, 18 Mar 2020 10:38:41 +0100 (CET)
Date:   Wed, 18 Mar 2020 10:38:41 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/14] xfs: remove the aborted parameter to
 xlog_state_done_syncing
Message-ID: <20200318093841.GB6538@lst.de>
References: <20200316144233.900390-1-hch@lst.de> <20200316144233.900390-6-hch@lst.de> <20200316205041.GK256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200316205041.GK256767@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 01:50:41PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 16, 2020 at 03:42:24PM +0100, Christoph Hellwig wrote:
> > We can just check for a shut down log all the way down in
> > xlog_cil_committed instead of passing the parameter.  This means a
> > slight behavior change in that we now also abort log items if the
> > shutdown came in halfway into the I/O completion processing, which
> > actually is the right thing to do.
> 
> "if the shutdown came in halfway into the I/O completion..."
> 
> Does this refer to a shutdown triggered by some other thread?  As in:
> this thread is processing log IO completion; meanwhile someone on the
> front end cancels a dirty transaction and causes the fs/log to shut
> down; and so this thread now tells all the log items that they were
> aborted?  Whereas before, the only reason we'd tell the log items that
> they were aborted is if the IO completion itself signalled some kind of
> error?

No, before we also checked for XLOG_STATE_IOERROR in
ẋlog_ioend_work.  But the I/O end processing drops l_icloglock in
various places, in which case another thread could shut down the log
as well.
