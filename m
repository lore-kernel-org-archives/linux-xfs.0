Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224DDC433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 11:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E456A6113B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 11:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhDGLgw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 07:36:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233809AbhDGLgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 07:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617795402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1No6H2e3Dzv3w+EwqV3boPJHxQeY2rzf7Do63c4NAXA=;
        b=hFykeoBmoAg/S5XY/lmubOnERRzjI0r1Zc6Qkn1BGZwgWBN7DGnoq4nJbpMpPfX7fG8wlw
        SQR8ntCyRnZh6C7ddKOHBQfI2zgGVGZlaMlZSfrrN99uHr9DFxoaNHAdhNALiGRyKt8nWi
        yMqSFXn8sTqDtSfqUrQKTTd51q3phZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-214hz3BWM7mR2FSrTCDX8w-1; Wed, 07 Apr 2021 07:36:40 -0400
X-MC-Unique: 214hz3BWM7mR2FSrTCDX8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A62A10CE782;
        Wed,  7 Apr 2021 11:36:39 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD3955C5E1;
        Wed,  7 Apr 2021 11:36:38 +0000 (UTC)
Date:   Wed, 7 Apr 2021 07:36:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: transaction subsystem quiesce mechanism
Message-ID: <YG2ZRXp/vPXlvpcB@bfoster>
References: <20210406144238.814558-1-bfoster@redhat.com>
 <20210406144238.814558-3-bfoster@redhat.com>
 <20210407080041.GB3363884@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407080041.GB3363884@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 09:00:41AM +0100, Christoph Hellwig wrote:
> On Tue, Apr 06, 2021 at 10:42:37AM -0400, Brian Foster wrote:
> > The updated quotaoff logging algorithm depends on a runtime quiesce
> > of the transaction subsystem to guarantee all transactions after a
> > certain point detect quota subsystem changes. Implement this
> > mechanism using an internal lock, similar to the external filesystem
> > freeze mechanism. This is also somewhat analogous to the old percpu
> > transaction counter mechanism, but we don't actually need a counter.
> 
> Stupid question that already came up when seeing the replies to my
> s_inodes patch:  Why do we even care about quotaoff?  Is there any
> real life use case for quotaoff, at least the kind that disables
> accounting (vs enforcement)?  IMHO we spend a lot of effort on this
> corner case that has no practical value, and just removing support
> for quotaoff might serve us much better in the long run.
> 

Hm, fair point. I think the historical fragility and complexity makes it
reasonable to question whether it's worth continued support. Looking
back through my notes, ISTM that the original report of the log
reservation deadlock came from fstests, so not necessarily an end user
report. I'm not aware of any real user reports around quotaoff, but then
again it's fairly boring functionality that probably just works most of
the time. It's kind of hard to surmise external dependencies from that
alone.

Personally, I'd probably have to think about it some more, but initially
I don't have any strong objection to removing quotaoff support. More
practically, I suspect we'd have to deprecate it for some period of time
given that it's a generic interface, has userspace tools, regression
tests, etc., and may or may not have real users who might want the
opportunity to object (or adjust).

Though perhaps potentially avoiding that mess is what you mean by "...
disables accounting vs.  enforcement." I.e., retain the interface and
general ability to turn off enforcement, but require a mount cycle in
the future to disable accounting..? Hmm... that seems like a potentially
nicer/easier path forward and a less disruptive change. I wonder even if
we could just (eventually) ignore the accounting disablement flags from
userspace and if any users would have reason to care about that change
in behavior.

Brian

