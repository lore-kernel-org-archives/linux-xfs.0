Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40768C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  2 May 2022 16:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386213AbiEBQGe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 May 2022 12:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386282AbiEBQGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 May 2022 12:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD241BC32
        for <linux-xfs@vger.kernel.org>; Mon,  2 May 2022 09:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651507321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WhK13cyvvNRDof38Ohe7xb1LD8hR0AEE7GmDQBzTVTk=;
        b=HN8zCePoI/w+TaeSxW/0xg2k10vdZ/gKYKPQfQm8D+MwQdGANGj9kox7xAhA/GHSru402Z
        gdrYloZ5PB7QtKsYZmRTVFbm+hiXgEoTpUNxXSnQADTX9ietw0MrV6BHbKPBLnYmJ8UjuO
        x0ImVr/QGfod2D/eRVsC34DCde0B1HY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-mAuil42yM9qtlFOsLzx-lA-1; Mon, 02 May 2022 12:01:57 -0400
X-MC-Unique: mAuil42yM9qtlFOsLzx-lA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66E60811E78;
        Mon,  2 May 2022 16:01:57 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B7169404D2C2;
        Mon,  2 May 2022 16:01:53 +0000 (UTC)
Date:   Tue, 3 May 2022 00:01:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <YnAAbNdMwOR7FLlo@T590>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420143110.2679002-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 10:31:10PM +0800, Ming Lei wrote:
> So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
> from userspace sync io interface, then block layer tries to poll until
> the bio is completed. But the current implementation calls
> blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
> timeout easily.
> 
> But looks no one reports this kind of issue, which should have been
> triggered in normal io poll sanity test or blktests block/007 as
> observed by Changhui, that means it is very likely that no one uses it
> or no one cares it.
> 
> Also after io_uring is invented, io poll for sync dio becomes legacy
> interface.
> 
> So ignore RWF_HIPRI hint for sync dio.
> 
> CC: linux-mm@kvack.org
> Cc: linux-xfs@vger.kernel.org
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
> 	- avoid to break io_uring async polling as pointed by Chritoph

Hello Jens,

Can you take this patch if you are fine?


Thanks,
Ming

