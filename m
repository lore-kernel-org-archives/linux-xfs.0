Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1289C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 18:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9015422B4B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 18:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePzuS9mw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgH0SfO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 14:35:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29559 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgH0SfO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 14:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598553312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i+9Z+U+DBlX1CAUpshwN8AIXPGFFnkiX4Rttk+0Tfp4=;
        b=ePzuS9mwOUZrn4Si5J2qWB95jkRibu4aRg/lJhNMhVGC2oaKtAmPdL+tcLUGR4oLWEW+D3
        8vBy2YSnocn1QCgeb8YsJI/utYtCYR7WhUReBLWHYINGVt98LphamipvTqoiwme3iUyN+b
        txS7WWIZa7Y19vwkZqHj7h3c8/5qFmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-j715bJIeOqi-n_3-MX-yqg-1; Thu, 27 Aug 2020 14:35:10 -0400
X-MC-Unique: j715bJIeOqi-n_3-MX-yqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8794F802B6B;
        Thu, 27 Aug 2020 18:35:09 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEB0B7836D;
        Thu, 27 Aug 2020 18:35:08 +0000 (UTC)
Date:   Thu, 27 Aug 2020 14:35:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200827183507.GB434083@bfoster>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org>
 <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
 <20200827073700.GA30374@infradead.org>
 <c59a4ed6-2698-ab61-6a73-143e273d9e22@toxicpanda.com>
 <20200827170242.GA16905@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827170242.GA16905@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 06:02:42PM +0100, Christoph Hellwig wrote:
> On Thu, Aug 27, 2020 at 11:57:03AM -0400, Josef Bacik wrote:
> > This sort of brings up a good point, the whole point of DISCARD support in
> > log-writes was to expose problems where we may have been discarding real
> > data we cared about, hence adding the forced zero'ing stuff for devices that
> > didn't support discard.  But that made the incorrect assumption that a drive
> > with actual discard support would actually return 0's for discarded data.
> > That assumption was based on hardware that did actually do that, but now we
> > live in the brave new world of significantly shittier drives.  Does dm-thinp
> > reliably unmap the ranges we discard, and thus give us this zero'ing
> > behavior?  Because we might as well just use that for everything so
> > log-writes doesn't have to resort to pwrite()'ing zeros everywhere.  Thanks,
> 

That's pretty much what this series does. It only modifies the generic
tests because I didn't want to mess with the others (all btrfs, I think)
that might not have any issues, but I wouldn't be opposed to burying the
logic into the dmlogwrites bits so it just always creates a thin volume
behind the scenes. If we were going to do that, I'd prefer to do it as a
follow up to these patches (dropping patch 1, most likely) so at least
they can remain enabled on XFS for the time being.

OTOH, perhaps the thinp behavior could be internal, but conditional
based on XFS. It's not really clear to me if this problem is more of an
XFS phenomenon or just that XFS happens to have some unique recovery
checking logic that explicitly detects it. It seems more like the
latter, but I don't know enough about ext4 or btrfs to say..

> We have a write zeroes operation in the block layer.  For some devices
> this is as efficient as discard, and that should (I think) dm.
> 

Do you mean BLKZEROOUT? I see that is more efficient than writing zeroes
from userspace, but I don't think it's efficient enough to solve this
problem. It takes about 3m to manually zero my 15GB lvm (dm-linear)
scratch device on my test vm via dd using sync writes. A 'blkdiscard -z'
saves me about half that time, but IIRC this is an operation that would
occur every time the logwrites device is replayed to a particular
recovery point (which can happen many times per test).

Brian

