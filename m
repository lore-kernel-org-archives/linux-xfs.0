Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A901DC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B7420EDD
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e62Fn9NO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHaNhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:37:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21990 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726167AbgHaNhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 09:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598881031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2UQlaaQbEqJq0JnauzBl0tDMMFva0ELTV14u3iIxOpI=;
        b=e62Fn9NOxS6u+DMGca7evh/LgxaX+d3zNRlKBMqejxeuMSPvjX2N/+MKE/YAvo+VlkAh4h
        BxVvZlUOgVAFVq4vWxqNIBPJHRkTTdK6hjHdLuAXtb4z/AQrdJslZ+1t04IkTNc3OToXvq
        bm0dbTwZ5jqU3sW2VnFBsUmUABijvzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-VMijLeYRO3aRH-8REPjg3g-1; Mon, 31 Aug 2020 09:37:07 -0400
X-MC-Unique: VMijLeYRO3aRH-8REPjg3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D3C51006705;
        Mon, 31 Aug 2020 13:37:06 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97DA65C22D;
        Mon, 31 Aug 2020 13:37:05 +0000 (UTC)
Date:   Mon, 31 Aug 2020 09:37:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200831133703.GA2667@bfoster>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org>
 <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
 <20200827073700.GA30374@infradead.org>
 <c59a4ed6-2698-ab61-6a73-143e273d9e22@toxicpanda.com>
 <20200827170242.GA16905@infradead.org>
 <20200827183507.GB434083@bfoster>
 <20200829064659.GB29069@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829064659.GB29069@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 29, 2020 at 07:46:59AM +0100, Christoph Hellwig wrote:
> On Thu, Aug 27, 2020 at 02:35:07PM -0400, Brian Foster wrote:
> > OTOH, perhaps the thinp behavior could be internal, but conditional
> > based on XFS. It's not really clear to me if this problem is more of an
> > XFS phenomenon or just that XFS happens to have some unique recovery
> > checking logic that explicitly detects it. It seems more like the
> > latter, but I don't know enough about ext4 or btrfs to say..
> 
> The way I understand the tests (and Josefs mail seems to confirm that)
> is that it uses discards to ensure data disappears.  Unfortunately
> that's only how discard sometimes work, but not all the time.
> 

I think Amir's followup describes how the infrastructure uses discard
better than I could. I'm not intimately familiar with how it works, so
my goal was to take the same approach as generic/482 and update the
tests to provide the predictable behavior expected by the
infrastructure. If folks want to revisit all of that to improve the
tests to not rely on discard and break that dependency, that seems like
a fine direction, but it also seems that can come later as improvements
to the broader infrastructure.

> > > We have a write zeroes operation in the block layer.  For some devices
> > > this is as efficient as discard, and that should (I think) dm.
> > > 
> > 
> > Do you mean BLKZEROOUT? I see that is more efficient than writing zeroes
> > from userspace, but I don't think it's efficient enough to solve this
> > problem. It takes about 3m to manually zero my 15GB lvm (dm-linear)
> > scratch device on my test vm via dd using sync writes. A 'blkdiscard -z'
> > saves me about half that time, but IIRC this is an operation that would
> > occur every time the logwrites device is replayed to a particular
> > recovery point (which can happen many times per test).
> 
> Are we talking about the block layer interface or the userspace syscall
> one?  I though it was the former, in which case REQ_OP_WRITE_ZEROES
> is the interface.  User interface is harder - you need to use fallocate
> on the block device, but the flags are mapped kinda weird:
> 
> FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE guarantees you a
> REQ_OP_WRITE_ZEROES, but there is a bunch of other variants that include
> fallbacks.
> 

I was using the BLKZEROOUT ioctl in my previous test because
fallocate(PUNCH_HOLE|KEEP_SIZE) (zeroing offload) isn't supported on
this device. I see similar results as above with
fallocate(PUNCH_HOLE|KEEP_SIZE) though, which seems to fall back to
__blkdev_issue_zero_pages() in that case.

Brian

