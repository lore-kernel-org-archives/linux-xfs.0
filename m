Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CADFC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 14:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiKCOOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 10:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiKCONo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 10:13:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B79B1402D
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 07:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cj1dbbZ4AJTxCmYzDOfjdAdaVz3PfhRhTZbkt1+9cFE=;
        b=UkswMlWbhr5hvDc/RbVjPm3fKrqgHeerZ6HGRfykcy4+qT8LoNID+0E7YXwoDFQEHr4MEE
        ORHoz3BCrvrjshdL0lUAl6vISEPOSqLVsqxY48E2Ut4Oy9rRGqtlyG3zrJvxHUv4sDvZ8m
        QL4gI9tcK+F4mq+iqhweKQjOLTUz6MA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-6diFqltBP1K2ItDiZxUPAw-1; Thu, 03 Nov 2022 10:12:40 -0400
X-MC-Unique: 6diFqltBP1K2ItDiZxUPAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0194F85A5A6;
        Thu,  3 Nov 2022 14:12:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E210E1401C22;
        Thu,  3 Nov 2022 14:12:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y19EXLfn8APg3adO@casper.infradead.org>
References: <Y19EXLfn8APg3adO@casper.infradead.org> <cover.1666928993.git.ritesh.list@gmail.com> <886076cfa6f547d22765c522177d33cf621013d2.1666928993.git.ritesh.list@gmail.com> <20221028210422.GC3600936@dread.disaster.area>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, Dave Chinner <david@fromorbit.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Aravinda Herle <araherle@in.ibm.com>
Subject: Re: [RFC 2/2] iomap: Support subpage size dirty tracking to improve write performance
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6821.1667484757.1@warthog.procyon.org.uk>
Date:   Thu, 03 Nov 2022 14:12:37 +0000
Message-ID: <6822.1667484757@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> ... His solution is a bit more complex than I really want to see, at least
> partially because he's trying to track dirtiness at byte granularity, no
> matter how much pain that causes to the server.

Actually, I'm looking at page-level granularity at the moment.

David

