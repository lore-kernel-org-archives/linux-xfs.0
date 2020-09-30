Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61B2C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 13:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FCA02076B
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 13:31:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AIAuQ2vS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgI3NbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 09:31:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728043AbgI3NbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 09:31:04 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601472662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nxkuc0XuLBcAvAnjp6c5ILintuowQpEq3iw+iX/zw6g=;
        b=AIAuQ2vSZqtYcB3RZ6I1f0A+MiqPSpyLPZKKoUayqkAjY7y5rTKBYCsJF5S+qOqPWHROGg
        cfaK+0tSYSiOHdlx2fuMOV9zR8yGDtDurmU4zZM+Rekw/wXCRkbswrXrSPOcQhgVdXcISG
        JCARnjolnMe25tWFtpePc9pKvKSPch8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-IC01X2fuPLmi4pDQyq6-vw-1; Wed, 30 Sep 2020 09:30:59 -0400
X-MC-Unique: IC01X2fuPLmi4pDQyq6-vw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C1321019629;
        Wed, 30 Sep 2020 13:30:58 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 464A65C1C4;
        Wed, 30 Sep 2020 13:30:58 +0000 (UTC)
Date:   Wed, 30 Sep 2020 09:30:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] xfs: temporary transaction subsystem freeze hack
Message-ID: <20200930133056.GB2649@bfoster>
References: <20200929141228.108688-1-bfoster@redhat.com>
 <20200929141228.108688-3-bfoster@redhat.com>
 <20200929205011.GJ14422@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929205011.GJ14422@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 06:50:11AM +1000, Dave Chinner wrote:
> On Tue, Sep 29, 2020 at 10:12:27AM -0400, Brian Foster wrote:
> > Implement a quick hack to abuse the superblock freeze mechanism to
> > freeze the XFS transaction subsystem.
> > 
> > XXX: to be replaced
> 
> What was wrong with the per-cpu counter that I used in the prototype
> I sent? Why re-invent the wheel?
> 

We discussed this in the original thread. See [1] (the tail end of my
mail is where we switch from general relogging discussion to the
quotaoff prototype) and your immediate reply for reference. The synopsis
is that I think a percpu rwsem around transaction allocation (what I've
replaced this patch with) is far more straightforward to audit, test and
maintain than annotating quota modifying transactions purely for the
purpose of quotaoff.

> Also, can we call this a pause/resume operation so it doesn't get
> confused with filesystem freezing? Freezing as operation name is way
> too overloaded already...
> 

Sure, pause/resume seems fine to me.

Brian

[1] https://lore.kernel.org/linux-xfs/20200702185209.GA58137@bfoster/

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

