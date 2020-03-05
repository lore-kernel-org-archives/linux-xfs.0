Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36899C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 050CD2073D
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 15:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wrr45uLG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCEPVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:21:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgCEPVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 10:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HLwxK3Byx5cff+xYD80QVmdg3Idojn8MtGtoWuDq1t8=; b=Wrr45uLGoF77XmF+v5whSd6kE9
        Ey6bmJXWs1tB3I5dXV8cKpCWq/kZMUl/5v/IbrarrQ1Ygo2pRCvcHYdfGMsW4oD1T0G1brFaBUuE/
        uY0xACjQF+t/PzSdYdntF+bWCghLPkxxcOZrNQknIa1Gm9P0l/fHV29yB5hv/sr+00JsD7VQGYR/j
        rfOQMQMPCW/1oBQc9IVKfEJ3rEvLn2OLG3CVXR5HC0CEal2P7ScGrFYY2asZUWnafiaVDaLnh8AXh
        YBaT353HPGyeI1siDhgBLygFgRWOwnJGwymCBwOG4cF6D/qlxE6mAYSy1ouQUiQ/J2q7fS44mycW6
        bszXqQ3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9sJO-0002ND-8P; Thu, 05 Mar 2020 15:21:22 +0000
Date:   Thu, 5 Mar 2020 07:21:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: move xlog_state_ioerror()
Message-ID: <20200305152122.GD8974@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-7-david@fromorbit.com>
 <20200304155140.GE17565@infradead.org>
 <20200304214115.GC10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304214115.GC10776@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 08:41:15AM +1100, Dave Chinner wrote:
> On Wed, Mar 04, 2020 at 07:51:40AM -0800, Christoph Hellwig wrote:
> > On Wed, Mar 04, 2020 at 06:53:56PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > To clean up unmount record writing error handling, we need to move
> > > xlog_state_ioerror() higher up in the file. Also move the setting of
> > > the XLOG_IO_ERROR state to inside the function.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > FYI, I have a pending series that kills xlog_state_ioerror and
> > XLOG_IO_ERROR.  Let me send that out now that Brians fix is in for-next.
> 
> Can you rebase that on top of this? removing IOERROR is a much more
> invasive and riskier set of state machine changes compared to what
> this patchset does. This patchset simplifies some of the error
> handling that handles IOERROR, too...

I find this lipstick on the pig here a little pointless, especially
moving things around that are planned to be removed..
