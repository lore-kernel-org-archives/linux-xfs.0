Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C4BC77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 12:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjDLMI6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 08:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjDLMI5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 08:08:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B07B8
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 05:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dQALt2TUpuguY6TVWwmLZq4GAesRGQZ59jXt9M7m1X0=; b=fVvi3SggefBooUGoZ3l8IEMuN2
        9OcEYZPo3LkrB/6H2HpvGx8uLLg9sPNEsTVG9S2VYLxa8w6sPDpL2kxgddRxXhvpF0oEYvEjYm91r
        6dFPHxxXX8QjlGk0VJrKYXbAkWbRznlQ9nqZMh5+Xo0I3IND9TEAiqCX00oeXwsYalsYFJIhpFgRv
        WLm9T4DWbhW0LBr+mnlY/z2/hgPyx5m4uNwmVYwLbHYdcGQMG9rAM812BBQtJcW+fTWGxDE5Tsaz8
        O7qZhmY1ubnIsfpJQS65sicYx4WQnPmz1t7BpbzamI9sm8iDLOqZuRtSLaSWu5DBrHPqHKLwoDXFA
        uErz/iGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmZHU-0032Nm-1Z
        for linux-xfs@vger.kernel.org;
        Wed, 12 Apr 2023 12:08:56 +0000
Date:   Wed, 12 Apr 2023 05:08:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: Replacing the external log device
Message-ID: <ZDafWCuO8iZB1Vev@infradead.org>
References: <ZDZb/PtvFlyIMKDG@aeszter.mpibpc.intern>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDZb/PtvFlyIMKDG@aeszter.mpibpc.intern>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 09:21:32AM +0200, Ansgar Esztermann-Kirchner wrote:
> However, I've been bitten by a nasty problem twice in recent weeks: in
> the first instance, I wanted to replace a bunch of disks in a machine
> (something like 4x10TB to 4x16TB). Usually, we do that by setting up a
> new machine, rsyncing all the data, and then swap the machines. In
> this instance, I refrained from swapping the machines (due to lack of
> hardware), and merely swapped the disks. Initially, the kernel refused
> to mount the new disks (this was expected: the UUID of the log was
> incorrect, as I only swapped the HDDs, not the log device).

Let me restate that:  you created a new XFS file system, but then tried
to reuse an existing log device for it?

How did you format the new file system?  XFS either expects and internal
log, or a log device?  For the above error it must have been formatted
with a different external log?  And then you just switched the mount
option to the log device of the previous file system?

If so that can't work, and I'm surprised you got so far.
