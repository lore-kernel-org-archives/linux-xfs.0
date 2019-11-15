Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9879C43141
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 14:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A294320733
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 14:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9gXLVhn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfKOOQf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 09:16:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55359 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727588AbfKOOQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 09:16:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573827392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z2e5+UW0tK//TE2S4dwCVwmhkXMhlbynSTZrZr8XjC8=;
        b=a9gXLVhnm/99H37z9pPRS5L0tAtOURTcvhOz7+5GHvYkT71OWeFoKpO1i1bEhJ9GeCorpT
        Idr8jVnJ6uWGo9PJR7uVMm7bLhLAu/bPE3KUljcpFa9AnHb3+VT3uT97UnYZ5VON5k8jvc
        sJETnONwOu5D06rW/biqUEim06TCUTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-J0vUecp5NuK4wnoKV_yKsw-1; Fri, 15 Nov 2019 09:16:29 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40F3E102C86E;
        Fri, 15 Nov 2019 14:16:27 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5C157BF99;
        Fri, 15 Nov 2019 14:16:15 +0000 (UTC)
Date:   Fri, 15 Nov 2019 22:16:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: single aio thread is migrated crazily by scheduler
Message-ID: <20191115141610.GA3283@ming.t460p>
References: <20191114113153.GB4213@ming.t460p>
 <20191114131434.GQ4114@hirez.programming.kicks-ass.net>
 <20191115000925.GB4847@ming.t460p>
MIME-Version: 1.0
In-Reply-To: <20191115000925.GB4847@ming.t460p>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: J0vUecp5NuK4wnoKV_yKsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 08:09:25AM +0800, Ming Lei wrote:
> On Thu, Nov 14, 2019 at 02:14:34PM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 14, 2019 at 07:31:53PM +0800, Ming Lei wrote:
> > > Hi Guys,
> > >=20
> > > It is found that single AIO thread is migrated crazely by scheduler, =
and
> > > the migrate period can be < 10ms. Follows the test a):
> >=20
> > What does crazy mean? Does it cycle through the L3 mask?
> >=20
>=20
> The single thread AIO thread is migrated in several milliseconds once.

Today I found the migrate rate of single fio IO thread can reach
11~12K/sec when I run './xfs_complete 512' on another real machine
(single numa node, 8 cores).

And the number is very close to IOPS of the test, that said the fio
IO thread can be migrated once just when completing one IO on the
scsi_debug device.


Thanks,
Ming

