Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91B4C11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77708207FD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N6EnieyG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgBTOZ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 09:25:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727761AbgBTOZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 09:25:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582208727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H9fKYCAmsRjYL/GAYxTQFIcus6taael5GOBCd7BDNcs=;
        b=N6EnieyGTZ6iFA0vjMDT3bHhGLLCFm7BoStFUPRoShU2X4xIoMbTs1kV8NXrR3HqcSzQNu
        2F404NKoJtYwKEvD0zA4kLhjZ07JUJRPBe6/kZf0k59Hjo9GbuLQSNcBB1D8GBdzB/PDpm
        tKYJluxI1vN3FjNQrWDdeLg4xAnLzok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-_oxmAejJPTqNmUnylZwAvQ-1; Thu, 20 Feb 2020 09:25:23 -0500
X-MC-Unique: _oxmAejJPTqNmUnylZwAvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6CC2DB88;
        Thu, 20 Feb 2020 14:25:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B0A2863A5;
        Thu, 20 Feb 2020 14:25:22 +0000 (UTC)
Date:   Thu, 20 Feb 2020 09:25:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200220142520.GF48977@bfoster>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200220034106.GO10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220034106.GO10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 02:41:06PM +1100, Dave Chinner wrote:
> On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > actual modern typical use case for it. I thought this was somewhat
> > realted to DAX use but upon a quick code inspection I see direct
> > realtionship.
> 
> Facebook use it in production systems to separate large file data
> from metadata and small files. i.e. they use a small SSD based
> partition for the filesytem metadata and a spinning disk for
> the large scale data storage. Essentially simple teired storage.
> 

Didn't this involve custom functionality? I thought they had posted
something at one point that wasn't seen through to merge, but I could be
misremembering (or maybe that was something else RT related). It doesn't
matter that much as there are probably other users out there, but I'm
not sure this serves as a great example use case if it did require
downstream customizations that aren't going to be generalized/supported
for the community.. Richard..?

Brian

> It's also commonly still used in multi-stream DVRs (think
> multi-camera security systems), and other similar sequential access
> data applications...
> 
> That's just a couple off the top of my head...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

