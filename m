Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB89C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 00:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiEXAlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 20:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiEXAlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 20:41:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C49F3140DB
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 17:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653352871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=idPCA1Ojor4LlTh+O1e95QR6iGVjUCXmp+mNYdObBb0=;
        b=e8dfWbhXc9HWRAIN9YhmsBUfj+rb07+Cp8mKmtpGRrzAg3nUW6YZkh2mIwtk883x6tVb7P
        6bEuhOyjq150XrgEw+UThSKNAic/yVDrj9k5Wzhc+97mIavjHjtrfnqAE7j0B6hRu/HJrL
        p15F09ELEU/h9+d0DA+WnD4Ov8/r43Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-erIJ1uDUOEqeqNxZvElaCA-1; Mon, 23 May 2022 20:41:09 -0400
X-MC-Unique: erIJ1uDUOEqeqNxZvElaCA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC140101A52C;
        Tue, 24 May 2022 00:41:08 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B63D7492C14;
        Tue, 24 May 2022 00:40:55 +0000 (UTC)
Date:   Tue, 24 May 2022 08:40:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <YowpjtLfZPld1H6T@T590>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
 <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 04:36:04PM -0600, Keith Busch wrote:
> On Wed, Apr 20, 2022 at 10:31:10PM +0800, Ming Lei wrote:
> > So far bio is marked as REQ_POLLED if RWF_HIPRI/IOCB_HIPRI is passed
> > from userspace sync io interface, then block layer tries to poll until
> > the bio is completed. But the current implementation calls
> > blk_io_schedule() if bio_poll() returns 0, and this way causes io hang or
> > timeout easily.
> 
> Wait a second. The task's current state is TASK_RUNNING when bio_poll() returns
> zero, so calling blk_io_schedule() isn't supposed to hang.

void __sched io_schedule(void)
{
        int token;

        token = io_schedule_prepare();
        schedule();
        io_schedule_finish(token);
}

But who can wakeup this task after scheduling out? There can't be irq
handler for POLLED request.

The hang can be triggered on nvme/qemu reliably:

fio --bs=4k --size=1G --ioengine=pvsync2 --norandommap --hipri=1 --iodepth=64 \
	--slat_percentiles=1 --nowait=0 --filename=/dev/nvme0n1 --direct=1 \
	--runtime=10 --numjobs=1 --rw=rw --name=test --group_reporting

Thanks, 
Ming

