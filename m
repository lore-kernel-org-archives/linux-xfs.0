Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA81C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 06:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiEXG3T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 02:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiEXG3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 02:29:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD96695DDD
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 23:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653373753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QqprHMR4J1N37LkxbIvmjg3ysuuBkqBVL3+ix+BlY1g=;
        b=gI66RQoR1vd5ckzAs1s+Q8JqaBRNNjCp8ZQt7tEaQRO7xx8ScqDWZ32YP196aEdMNWqn4r
        dOAy2FA1beRN9YwNcHxxFJmBkJEzZUrqgwco3TeVuvLjUyryBK8CG/eQ5OAzSsniieyt3v
        U3OdgiJTB/E1Zok/2MK+SE5V8Kj2ifo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-PDEnsvwLNzSxGqeuekoxkA-1; Tue, 24 May 2022 02:29:10 -0400
X-MC-Unique: PDEnsvwLNzSxGqeuekoxkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB09C80159B;
        Tue, 24 May 2022 06:29:09 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAF8A1121315;
        Tue, 24 May 2022 06:29:04 +0000 (UTC)
Date:   Tue, 24 May 2022 14:28:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <Yox7Kp2N1NzSes0C@T590>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
 <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
 <YowpjtLfZPld1H6T@T590>
 <YoxKz51EAu3j2qwK@kbusch-mbp.dhcp.thefacebook.com>
 <YoxgU5/P460FZ3rl@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoxgU5/P460FZ3rl@kbusch-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 10:34:27PM -0600, Keith Busch wrote:
> On Mon, May 23, 2022 at 09:02:39PM -0600, Keith Busch wrote:
> > Here's a bandaid, though I assume it'll break something...
> 
> On second thought, maybe this is okay! The encoded hctx doesn't change after
> this call, which is the only thing polling cares about. The tag portion doesn't
> matter.

I guess it still may change in case that nvme mpath bio is requeued.


Thanks,
Ming

