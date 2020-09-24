Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CAFC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 00:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBEDB2176B
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 00:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZExYSVTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIXAjM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 20:39:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726731AbgIXAjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 20:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600907951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J6+erL0jIdE2OxF7ECOGrLfJbMDSWN2tZHISgxX8eZM=;
        b=ZExYSVTOj9Eij4xjuMtiQdPzviDCu7jB6cRf2jZzIs9xPOct0TnKquvpOmIzn2QjYWzK4p
        +8OSAmsnObOjhx4XRL0bVT38Sn1hSnS0zc/bJ07r50b08+/FFNy5o7Iu2GGk5BSsPD6Eon
        s3Gu8CBYg0iqIFflwaOrwdVnrVRPRPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-QM0LIqC6OvCjDORJMAKj-g-1; Wed, 23 Sep 2020 20:39:09 -0400
X-MC-Unique: QM0LIqC6OvCjDORJMAKj-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0D718027E2;
        Thu, 24 Sep 2020 00:39:07 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E6C45576A;
        Thu, 24 Sep 2020 00:39:03 +0000 (UTC)
Date:   Wed, 23 Sep 2020 20:39:02 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200924003902.GA10500@redhat.com>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625113122.7540-7-willy@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25 2020 at  7:31am -0400,
Matthew Wilcox (Oracle) <willy@infradead.org> wrote:

> Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> guarantees we will not sleep to reclaim memory.  Use it to simplify
> dm-bufio's allocations.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/md/dm-bufio.c    | 30 ++++++++----------------------
>  include/linux/sched.h    |  1 +
>  include/linux/sched/mm.h | 12 ++++++++----
>  3 files changed, 17 insertions(+), 26 deletions(-)


Hi,

Curious on the state of this patchset?  Not seeing it in next-20200923

The dm-bufio cleanup looks desirable.

Thanks,
Mike

