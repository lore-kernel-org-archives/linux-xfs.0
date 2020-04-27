Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B01C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D962063A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:11:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="afl2S2rC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgD0LL7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 07:11:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43898 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726589AbgD0LL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 07:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587985918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ko8wOKAz8S/jATrgPirgpObwuJparpcbuwsR5eO2Rvk=;
        b=afl2S2rCIg1ndjdBbc3N2KLmqlxyvo6MuAH08mztmb9+cLejGn8s65IU8EppfCDMYL2Ygz
        wDatd5UFnHLX0kN+Z07I2ZE3x4f7G9kR/XuEmCVG2UTwdZBzxyCWSGhuv9G3WzzWK1/219
        lT8kME9HfVikrmTAc9ek57itAkBP3OE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-6ABNxrrPOeGDgoO7DBe-zA-1; Mon, 27 Apr 2020 07:11:56 -0400
X-MC-Unique: 6ABNxrrPOeGDgoO7DBe-zA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93CEC45F;
        Mon, 27 Apr 2020 11:11:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D5A460C80;
        Mon, 27 Apr 2020 11:11:55 +0000 (UTC)
Date:   Mon, 27 Apr 2020 07:11:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 02/13] xfs: factor out buffer I/O failure simulation
 code
Message-ID: <20200427111153.GB4577@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-3-bfoster@redhat.com>
 <20200425172339.GB30534@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425172339.GB30534@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 10:23:39AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 22, 2020 at 01:54:18PM -0400, Brian Foster wrote:
> > We use the same buffer I/O failure simulation code in a few
> > different places. It's not much code, but it's not necessarily
> > self-explanatory. Factor it into a helper and document it in one
> > place.
> 
> The code looks good, but the term simularion sounds rather strange in
> this context.  We don't really simulate an I/O failure, but we fail the
> buffer with -EIO due to a file system shutdown.
> 

I was just using the terminology in the existing code. I've updated the
commit log to refer to it as "I/O failure code," but note that the
comments in the code still use the original terminology (unless you want
to suggest alternative wording..).

> I'd also just keep the ORing of XBF_ASYNC into b_flags in the two
> callers, as that keeps the function a little more "compact".
> 

Ok, fine by me.

Brian

