Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17766C433ED
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 11:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D26613CF
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 11:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhDGLYc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 07:24:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238501AbhDGLY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 07:24:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617794658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J8KugTAe2xi+eLD5IBg8XUVZzYA6rEZd1dVb63Mh3vI=;
        b=V85HchdwsvI+m2Erf2nhysbBDv9Iud/DQ1C6v1UXIlLSJZk7caN2tgr8rDmjWYwWyarCRV
        0blcpb+cN9mcCdrk5vIXPE33A0OtOeUfL4BhQy7TgaT+MYYD7X8FDQWIcPJDs6/BsU8j3J
        sCinjnnq4JE3vO6Kn42qXXC/y1Zbac8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-tE9uuRCBPzmiMz2MFmuAbg-1; Wed, 07 Apr 2021 07:24:17 -0400
X-MC-Unique: tE9uuRCBPzmiMz2MFmuAbg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39F3E189C441;
        Wed,  7 Apr 2021 11:24:16 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0A92100239A;
        Wed,  7 Apr 2021 11:24:15 +0000 (UTC)
Date:   Wed, 7 Apr 2021 07:24:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: open code ioend needs workqueue helper
Message-ID: <YG2WXd9lR908lK/1@bfoster>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-3-bfoster@redhat.com>
 <20210407063440.GC3339217@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407063440.GC3339217@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 07:34:40AM +0100, Christoph Hellwig wrote:
> On Mon, Apr 05, 2021 at 10:59:01AM -0400, Brian Foster wrote:
> > Open code xfs_ioend_needs_workqueue() into the only remaining
> > caller.
> 
> This description would all fit on a single line.
> 

I've used 68 character wide commit log descriptions for quite some time,
to which this seems to be wrapped accurately. This is the same as the
immediately previous patch for example, with the much longer
description. I don't care much about changing it, but is there a
canonical format defined somewhere? I've always just thought 68-72 was
acceptable.

Brian

> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

