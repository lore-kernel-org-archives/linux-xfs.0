Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08276CA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D802F205ED
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 17:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hnSzyLvc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgELRUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 13:20:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726287AbgELRUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 13:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589304021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7FchGEQ91A0wj2P47gni+3T63SF72TigpTaGYiA+5mg=;
        b=hnSzyLvclskQh3JrnOdUZ875KulRp1g9GsXUgEaci5ojotWCDwVTdfXiGQvrU0K/YzxdzM
        1ytWxJxH1Xaxl+PUQOCeGu98Ly47YKHxQrFZEglx+O2XjubVDEn9xSg636cHWL3q9VP+Mo
        Fic1wc5Ias25tAbOU9e0bod0D5YiYXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-BkxRH8T0N0SB2utPIXBdng-1; Tue, 12 May 2020 13:20:20 -0400
X-MC-Unique: BkxRH8T0N0SB2utPIXBdng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 086F81B18BC0;
        Tue, 12 May 2020 17:20:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 75D9D60C80;
        Tue, 12 May 2020 17:20:18 +0000 (UTC)
Date:   Tue, 12 May 2020 13:20:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: warn instead of fail verifier on empty attr3
 leaf block
Message-ID: <20200512172016.GJ37029@bfoster>
References: <20200511185016.33684-1-bfoster@redhat.com>
 <20200512081037.GB28206@infradead.org>
 <20200512155320.GD6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512155320.GD6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 08:53:20AM -0700, Darrick J. Wong wrote:
> On Tue, May 12, 2020 at 01:10:37AM -0700, Christoph Hellwig wrote:
> > On Mon, May 11, 2020 at 02:50:16PM -0400, Brian Foster wrote:
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > What do folks think of something like this? We have a user report of a
> > > corresponding read verifier failure while processing unlinked inodes.
> > > This presumably means the attr fork was put in this state because the
> > > format conversion and xattr set are not atomic. For example, the
> > > filesystem crashed after the format conversion transaction hit the log
> > > but before the xattr set transaction. The subsequent recovery succeeds
> > > according to the logic below, but if the attr didn't hit the log the
> > > leaf block remains empty and sets a landmine for the next read attempt.
> > > This either prevents further xattr operations on the inode or prevents
> > > the inode from being removed from the unlinked list due to xattr
> > > inactivation failure.
> > > 
> > > I've not confirmed that this is how the user got into this state, but
> > > I've confirmed that it's possible. We have a couple band aids now (this
> > > and the writeback variant) that intend to deal with this problem and
> > > still haven't quite got it right, so personally I'm inclined to accept
> > > the reality that an empty attr leaf block is an expected state based on
> > > our current xattr implementation and just remove the check from the
> > > verifier (at least until we have atomic sets). I turned it into a
> > > warning/comment for the purpose of discussion. Thoughts?
> > 
> > If the transaction is not atomic I don't think we should even
> > warn in this case, even if it is unlikely to happen..
> 
> I was gonna say, I think we've messed this up enough that I think we
> just have to accept empty attr leaf blocks. :/
> 

That makes at least 3 votes (including me) to drop the check so I'll
send a real patch after some regression testing. Thanks.

Brian

> I also think we should improve the ability to scan for and invalidate
> incore buffers so that we can invalidate and truncate the attr fork
> extents directly from an extent walk loop.  It seems a little silly that
> we have to walk the dabtree just to find out where multiblock remote
> attr value structures might be hiding.
> 
> --D
> 

