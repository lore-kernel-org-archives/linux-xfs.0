Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8D8C33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7721B20708
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 06:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o603kApm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgA2GqX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 01:46:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43010 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgA2GqW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 01:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uCkUrIIj0v0xwuhcOdgKy+vFRkoC83HpCWkt8oKaAgs=; b=o603kApm0QbfD2jDa5vk+ltJp
        gl0vQ7IpiAGO4zZ7L5axIh2n21RN6kpNxoplnooVNq0MWJk53+M+WzEZF3uXIRp4FdLfEHxPRXi7L
        5/EdFXos55wRhB3glaA2EV7CYUEBzL69oFV8vMXSUAiXLZMzPdmO5FthN6QAsXKlCwDkm8HeiA3NY
        7p7jMISHQ/zTLnsKMuQU3V4ctOKSDGypgS4dkqDlOloivKyU7WzjdFTQiFYNTWrH6P6UrpL/+1Esk
        ZY//A7qSt8O1GwZ3lAdYuiWdbRYtas52zNHoI5QlC0MsX8DtSwVoeJXaRxkljwBn8sJ1AmbdmkzrL
        HwefLkdkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwh7F-00018w-PW; Wed, 29 Jan 2020 06:46:21 +0000
Date:   Tue, 28 Jan 2020 22:46:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
Message-ID: <20200129064621.GA4263@infradead.org>
References: <20191216215245.13666-1-david@fromorbit.com>
 <20200126110212.GA23829@infradead.org>
 <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 27, 2020 at 11:43:02AM -0600, Eric Sandeen wrote:
> On 1/26/20 5:02 AM, Christoph Hellwig wrote:
> > Eric, can you pick this one up?  The warnings are fairly annoying..
> > 
> 
> Sorry, I had missed this one and/or the feedback on the original patch
> wasn't resolved.  I tend to agree that turning off the warning globally
> because we know /this/ one is OK seems somewhat suboptimal.
> 
> Let me take a look again.

Well, the kernel certainly runs with this warning disabled, mostly
because it really isn't a very useful warning to start with.
