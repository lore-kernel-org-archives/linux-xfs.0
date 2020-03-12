Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE48C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 15:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F682067C
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 15:46:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBxb2/l9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgCLPqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 11:46:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35525 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727493AbgCLPqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 11:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584028011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSCHtX/DdIu7Nj4innDShhViiLkeLYk4qb7bkl1oWCU=;
        b=eBxb2/l9W1W8b6hgHTulx8zFNjLH3DHmT8PYLsg1AP35tsJ1lTDYwkiZLiOS+tJzdYwWRA
        Uwy8A5cEtvK/QemkNPO4+HNcx1q5EF9IuD8zVe9E7kxGMBMwF5fpkeXIpcFCrBd0cDUf3N
        ukCJ3UgwUktTDFHjqCf+61vQZOk/DW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-aFM2G3yqM2-zQdP1GpzGBQ-1; Thu, 12 Mar 2020 11:46:49 -0400
X-MC-Unique: aFM2G3yqM2-zQdP1GpzGBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C44038C4321;
        Thu, 12 Mar 2020 15:46:48 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 87B3292F8D;
        Thu, 12 Mar 2020 15:46:48 +0000 (UTC)
Subject: Re: xfsprogs process question
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20200312141351.GA30388@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <244a8391-77c4-94a1-3bd4-b78c7a1f39ad@redhat.com>
Date:   Thu, 12 Mar 2020 10:46:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312141351.GA30388@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/12/20 9:13 AM, Christoph Hellwig wrote:
> Hi Eric and others,
> 
> I've recently tried to port my attr cleanups to xfsprogs, but noticed
> that a lot of patches from others are missing before I could apply
> my ptches.  Any chance we could try to have a real xfsprogs for-next
> branch that everyone can submit their ports to in a timely fashion?
> Without that I'm not sure how to handle the porting in a distributed
> way.

I guess the problem is that libxfs/ is behind, right.  I have indeed
always been late with that but it's mostly only affected me so far.

Would it help to open a libxfs-sync-$VERSION branch as soon as the kernel
starts on a new version?

I've never quite understood what the common expectation for a "for-next"
branch behavior is, though I recognize that my use of it right now is a bit
unconventional.

-Eric

