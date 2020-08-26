Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9351EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72883208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 15:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3d4RDe/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgHZPUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 11:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbgHZPUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 11:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598455204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8LaBTe+96iLOfaUqivgu3SP3vurldILXL5R9hEV3gc=;
        b=R3d4RDe/9lc65MDyPOErK2C27w6FAXfYsc6FijzwnmxioGFBWA4/J/iHhl7Xe66FD4XWD+
        sv7Lr12s0TqkvSt6rGkRRzImCPNbcKByGi9rMrR5Tm9PN42VfLH7HwUWKQrED32IoAI/f9
        j9o3OOUaLCuPWrpPiBGwvg0iSltE8UQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-iVogn5YKN52cfsnKT60_nQ-1; Wed, 26 Aug 2020 11:20:01 -0400
X-MC-Unique: iVogn5YKN52cfsnKT60_nQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 847FF6C582;
        Wed, 26 Aug 2020 15:20:00 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20BA57191C;
        Wed, 26 Aug 2020 15:20:00 +0000 (UTC)
Date:   Wed, 26 Aug 2020 11:19:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 208805] New: XFS: iozone possible memory allocation deadlock
Message-ID: <20200826151958.GB355692@bfoster>
References: <bug-208805-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bug-208805-201763@https.bugzilla.kernel.org/>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 04, 2020 at 09:52:48AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=208805
> 
>             Bug ID: 208805
>            Summary: XFS: iozone possible memory allocation deadlock
>            Product: File System
>            Version: 2.5
>     Kernel Version: Linux 5.4
>           Hardware: x86-64
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: jjzuming@outlook.com
>         Regression: No
> 
> When I ran iozone to test XFS in a memory insufficient situation，I found that
> iozone was blocked and The log "XFS: iozone possible memory allocation
> deadlock" was printed.
> 
> Reviewing the XFS code, I found that kmem_alloc(), xfs_buf_allocate_memory(),
> kmem_zone_alloc() and kmem_realloc() were implemented with "while" loops. These
> functions kept trying to get memory while the memory was insufficient, as a
> result of which "memory allocation deadlock" happened.
> 
> I think it may be a little unreasonable, although it can guarantee that the
> memory allocation succeed. Maybe using error handling code to handle the memory
> allocation failures is better.
> 

I think some of this memory allocation code is currently being reworked,
but that aside most of the above cases do break the retry loop if the
caller passes KM_MAYFAIL. So it's a case by case basis as to whether a
particular allocation should be allowed to fail and potentially return
an error to userspace or should continue to retry.

A more useful approach to this bug would be to describe your test, the
specific system/memory conditions, and provide the full log output
(stack trace?) associated with the issue. Then perhaps we can analyze
the cause and determine whether it's something that can be addressed or
improved, or if you just need more memory. ;)

Brian

> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
> 

