Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5414BC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 16:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2317921707
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 16:07:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MvWTaWo6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391400AbgFSQHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 12:07:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55150 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391245AbgFSPIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 11:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592579311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ekfNBp4LhaeldweXzxt1Y3e5nQyJLwRxW69/ByaQ7Fw=;
        b=MvWTaWo6paaDnLvaHrAP97jUioum45Jea/wfS8vjgsL5FkMfb4H8A7NjASd/55U1ien164
        lw4muElyDXmz9frRAJ34OzFq93rM8pf0ha8n22J7n2F6YPEO3TibJshAF3jt6lOjlMuG2O
        oNBccwk6wcPzWOVB6d/UyxRuHfzuw5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-GAiLBo89OQ-_9mut8R-4Ow-1; Fri, 19 Jun 2020 11:08:27 -0400
X-MC-Unique: GAiLBo89OQ-_9mut8R-4Ow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8E488018D9;
        Fri, 19 Jun 2020 15:08:25 +0000 (UTC)
Received: from llong.remote.csb (ovpn-117-31.rdu2.redhat.com [10.10.117.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D56755D9E8;
        Fri, 19 Jun 2020 15:08:17 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Qian Cai <cai@lca.pw>,
        Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200617175310.20912-1-longman@redhat.com>
 <20200617175310.20912-3-longman@redhat.com>
 <20200619132155.GA27677@infradead.org>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <9ac58106-d7f5-fda2-2695-c68b5072f696@redhat.com>
Date:   Fri, 19 Jun 2020 11:08:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200619132155.GA27677@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/19/20 9:21 AM, Christoph Hellwig wrote:
> I find it really confusing that we record this in current->flags.
> per-thread state makes total sense for not dipping into fs reclaim.
> But for annotating something related to memory allocation passing flags
> seems a lot more descriptive to me, as it is about particular locks.
>
I am dropping this patchset as just using PF_MEMALLOC_NOFS is good enough.

Cheers,
Longman

