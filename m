Return-Path: <SRS0=vvgS=W4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FB1C3A5A4
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 07:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A14B32173E
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Sep 2019 07:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g8Zka32y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfIAHel (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Sep 2019 03:34:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfIAHek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Sep 2019 03:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3KXMqDjyJ/c6oIGynh9c600vsqBH05BrTEQQ9K4GdNY=; b=g8Zka32yF8WrCxLU1xO645WTI
        5YY01nYmHWn9tTsB6YjMDBAdTndLSLcA0r3gH4iFv44l9Lr5wp4y6ndRDz42zyOMnF00pSETnOicQ
        96SnYZwbHa42GElM0DeXvvxvcirNoqKg3yfupi62+sxHi3JkvqfEaHK3Jqbn1l5MSKht642Qt2RB0
        RmKKPdjgExXUhP9fhM24G9nuF1l25y/I7wgEjNIJpAbGkpt3u8rvVHImz2POFVUgRjE51iRPKpjyM
        t9cZ3ytecF2Y14O+oCsXBRmjZeJ+dj9xZZTgvEOms9WCWZsLyw+8O+rTVXNzRKZqfiXi1cmmvSAaX
        wqknZmzNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i4KNk-00041Y-5q; Sun, 01 Sep 2019 07:34:40 +0000
Date:   Sun, 1 Sep 2019 00:34:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        agruenba@redhat.com
Subject: Re: [PATCH v4 0/6] iomap: lift the xfs writepage code into iomap
Message-ID: <20190901073440.GB13954@infradead.org>
References: <156444945993.2682261.3926017251626679029.stgit@magnolia>
 <20190816065229.GA28744@infradead.org>
 <20190817014633.GE752159@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817014633.GE752159@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 06:46:33PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 15, 2019 at 11:52:29PM -0700, Christoph Hellwig wrote:
> > Darrick,
> > 
> > are you going to queue this up?
> 
> Yes, I'll go promote the iomap writeback branch to iomap-for-next.  I
> haven't 100% convinced myself that it's a good idea to hook up xfs to it
> yet, if nothing else because of all the other problems I've had getting
> 5.3 testing to run to completion reliably...

So what is the current status?  We are going to get an -rc8 to give
you some more time, and I'd really hate to miss the second merge window
for the change, espececially as things tend to get out of sync, and I
have various bits touching the code planned for the 5.5 merge window.
