Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3976C761A1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 782DA24672
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bTZ1QZ6Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBTEzq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:55:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45542 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727576AbgBTEzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 23:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582174544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C+TC8LymXeVcDTwPt8PlE9k8EzpEuPGxT2dYTaHDh+Y=;
        b=bTZ1QZ6QQ3DUbbdEOU/aKocwtNh+4edYTyuejArH5FulpaqanG4E5F2fH2RHsoJCY8tYs+
        hdnw8bAiBczYr3CqWnZKO5+1SEPHGu6m8i2Clv6c5KvzJf5baGkL+G4SwHXfKba0Y5GHhW
        87tXqqXH6d3mbOd615v9ZGoW44mF1Mc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-SYaqTUDeNTKONnMu8Y73PQ-1; Wed, 19 Feb 2020 23:55:40 -0500
X-MC-Unique: SYaqTUDeNTKONnMu8Y73PQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02DDF107ACC4;
        Thu, 20 Feb 2020 04:55:39 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73B435C28E;
        Thu, 20 Feb 2020 04:55:38 +0000 (UTC)
Date:   Thu, 20 Feb 2020 13:05:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] generic: per-type quota timers set/get test
Message-ID: <20200220050559.GG14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20200216181631.22560-1-zlang@redhat.com>
 <e54ae15f-6363-4486-0546-030e45ed50bb@sandeen.net>
 <20200220041539.GD14282@dhcp-12-102.nay.redhat.com>
 <605d6c45-9f52-ec84-df01-d5b7665d16dc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <605d6c45-9f52-ec84-df01-d5b7665d16dc@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 10:23:29PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/19/20 10:15 PM, Zorro Lang wrote:
> > On Wed, Feb 19, 2020 at 08:57:58PM -0600, Eric Sandeen wrote:
> >> On 2/16/20 12:16 PM, Zorro Lang wrote:
> >>> --- /dev/null
> >>> +++ b/tests/generic/593.out
> >>> @@ -0,0 +1,32 @@
> >>> +QA output created by 593
> >>> +1. set project quota timer
> >>> +*** Report for user quotas on device SCRATCH_DEV
> >>> +Block grace time: 7days; Inode grace time: 7days
> >>> +*** Report for group quotas on device SCRATCH_DEV
> >>> +Block grace time: 7days; Inode grace time: 7days
> >>> +*** Report for project quotas on device SCRATCH_DEV
> >>> +Block grace time: 00:10; Inode grace time: 00:20
> >>
> >> One other thing that might be an issue here, I'm not sure every
> >> filesystem will default to 7 days if no other grace period is set ...?
> > 
> > Make sense:) I just hope to test the default grace time by pass.
> > How about:
> > 1) Get the default quota timer $string.
> > 2) Filter above default timer "$string" to "default".
> > to avoid defferent default timer breaks the golden output.
> 
> Makes sense to me, at least after I fix the other xfs bugs ;)

Yeah, I just reviewed your patch:
  [PATCH] xfs: test that default grace periods init on first mount

I think my case hard to cover this situation, I have to filter the default
value, but if the default value is bad from beginning, it can't help :)

Thanks,
Zorro

> 
> -Eric
> 

