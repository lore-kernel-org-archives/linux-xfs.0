Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B32C43457
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52137222EA
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iF7KCc5x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgJSQzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:55:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730690AbgJSQzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 12:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603126508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UIbgrH9eig0psNy0ASBb0vz+iWA/QXOrTGiB/ABhnmc=;
        b=iF7KCc5x2+Ns5CrWUq8Asiw4q+P8Jsl3YWiNks7ogQwKBuaAvD0WPfgVSOv4Q4tiFUAGXC
        Iykt/NCsvZcPYD2CNRLJ/zrIyQSn3hEA/ZrljdY6/ofqTY4FEDMs6Of5h4CO8LXpzQPNOS
        NdyxY11EnvLbJuqQ/855uN0H8FlDZEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-9iXIkeU7Pd6nvSlKqryVmg-1; Mon, 19 Oct 2020 12:55:04 -0400
X-MC-Unique: 9iXIkeU7Pd6nvSlKqryVmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AF5A425CF;
        Mon, 19 Oct 2020 16:55:03 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 08C8C5D9D2;
        Mon, 19 Oct 2020 16:55:02 +0000 (UTC)
Date:   Mon, 19 Oct 2020 12:55:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: use page dirty state to seek data over
 unwritten extents
Message-ID: <20201019165501.GA1232435@bfoster>
References: <20201012140350.950064-1-bfoster@redhat.com>
 <20201012140350.950064-2-bfoster@redhat.com>
 <20201015094700.GB21420@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015094700.GB21420@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 10:47:00AM +0100, Christoph Hellwig wrote:
> I don't think we can solve this properly.  Due to the racyness we can
> always err one side.  The beauty of treating all the uptodate pages
> as present data is that we err on the safe side, as applications
> expect holes to never have data, while "data" could always be zeroed.
> 

I don't think that's quite accurate. Nothing prevents a dirty page from
being written back and reclaimed between acquiring the (unwritten)
mapping and doing the pagecache scan, so it's possible to present valid
data (written to the kernel prior to a seek) as a hole with the current
code.

Brian

