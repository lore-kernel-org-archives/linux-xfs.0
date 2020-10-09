Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA64C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 13:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C47222E8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 13:02:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VivilYUo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732699AbgJINCQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 09:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732468AbgJINCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 09:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602248534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXfZH6Xax8QBeX4SQG02qebjBEW6p+Tf3I4hPgZk+pA=;
        b=VivilYUoxdv44FFrSc3TU47T6/dUdMYay4K1nJwpXOldktSsfrAaisWs+A1VgGMbbvy6EZ
        PUYAxPc6vupfvQ6jpz/WLvcjQds8mMkYum+4JetYO7+OJRJ4w/Qucfi4FWbrpM6qzbQSg5
        fxeorsWktBqdB/WiWnURsawhJP97MF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-3tIS51YDPUyzPUJToguFww-1; Fri, 09 Oct 2020 09:02:11 -0400
X-MC-Unique: 3tIS51YDPUyzPUJToguFww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 376E4801FAE;
        Fri,  9 Oct 2020 13:02:10 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF5D05DA6B;
        Fri,  9 Oct 2020 13:02:02 +0000 (UTC)
Subject: Re: [PATCH v4 3/3] xfsprogs: make use of
 xfs_validate_stripe_factors()
To:     Gao Xiang <hsiangkao@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@aol.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-4-hsiangkao@aol.com> <20201007223044.GI6540@magnolia>
 <20201009005847.GB10631@xiangao.remote.csb>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <b00455fd-a017-8daf-2b15-d3062f0d6bef@redhat.com>
Date:   Fri, 9 Oct 2020 08:02:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201009005847.GB10631@xiangao.remote.csb>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/8/20 7:58 PM, Gao Xiang wrote:
>> Unless we get rid of the weird libxfs macro thing, you're supposed to
>> use prefixes in userspace.
> I vaguely remembered Christoph sent out a patch intending to get
> rid of xfsprogs libxfs_ prefix months ago, so I assumed there was
> no need to introduce any new libxfs_ userspace API wrappers anymore.

He did, and it's on my (perpetual) TODO list to get that finally reviewed,
sorry.

For now we still have libxfs*

-Eric

> But yeah, will add such libxfs_ marco wrapper in the next version.
> 
> Thanks,
> Gao Xiang
> 

