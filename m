Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B90CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 11:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C89CA64DE0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 11:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBPLUL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 06:20:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230081AbhBPLTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Feb 2021 06:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613474307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o502SusQ/VEabZ3Jb79gv77bHufENRAKQniPP2zan0o=;
        b=RgkDRhUYI27xRXZJ5Nb184V2meSCCn0IvQSwg1oaP7whitSwOGFKEaNJtH2CkvbfTzZ1Zv
        ZMXwL5KaeW5bm5rI7yoJ4afsiGdY1u8IGkgl6bZi5iIMrnL+v+FwgXqDrnj+fpOIUts2M4
        jwTkS+9QQvGGty5ct6OWs3yLUNr7Kkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-9TKQoWd2N_CGqJh0Y9c6LQ-1; Tue, 16 Feb 2021 06:18:25 -0500
X-MC-Unique: 9TKQoWd2N_CGqJh0Y9c6LQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD9F8195D566;
        Tue, 16 Feb 2021 11:18:23 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBDD019712;
        Tue, 16 Feb 2021 11:18:22 +0000 (UTC)
Date:   Tue, 16 Feb 2021 06:18:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20210216111820.GA534175@bfoster>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <20210104162353.GA254939@bfoster>
 <20210107215444.GG331610@dread.disaster.area>
 <20210108165657.GC893097@bfoster>
 <20210111163848.GC1091932@bfoster>
 <20210113215348.GI331610@dread.disaster.area>
 <8416da5f-e8e5-8ec6-df3e-5ca89339359c@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8416da5f-e8e5-8ec6-df3e-5ca89339359c@molgen.mpg.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 15, 2021 at 02:36:38PM +0100, Donald Buczek wrote:
> On 13.01.21 22:53, Dave Chinner wrote:
> > [...]
> > I agree that a throttling fix is needed, but I'm trying to
> > understand the scope and breadth of the problem first instead of
> > jumping the gun and making the wrong fix for the wrong reasons that
> > just papers over the underlying problems that the throttling bug has
> > made us aware of...
> 
> Are you still working on this?
> 
> If it takes more time to understand the potential underlying problem, the fix for the problem at hand should be applied.
> 
> This is a real world problem, accidentally found in the wild. It appears very rarely, but it freezes a filesystem or the whole system. It exists in 5.7 , 5.8 , 5.9 , 5.10 and 5.11 and is caused by c7f87f3984cf ("xfs: fix use-after-free on CIL context on shutdown") which silently added a condition to the wakeup. The condition is based on a wrong assumption.
> 
> Why is this "papering over"? If a reminder was needed, there were better ways than randomly hanging the system.
> 
> Why is
> 
>     if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
>         wake_up_all(&cil->xc_push_wait);
> 
> , which doesn't work reliably, preferable to
> 
>     if (waitqueue_active(&cil->xc_push_wait))
>         wake_up_all(&cil->xc_push_wait);
> 
> which does?
> 

JFYI, Dave followed up with a patch a couple weeks or so ago:

https://lore.kernel.org/linux-xfs/20210128044154.806715-5-david@fromorbit.com/

Brian

> Best
>   Donald
> 
> > Cheers,
> > 
> > Dave
> 

