Return-Path: <SRS0=drEG=3Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A698C2D0DB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 15:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F20B9215A4
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 15:29:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYFuqkHO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgA0P3s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 10:29:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729146AbgA0P3s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 10:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580138987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G8J484q6SSLIesN3KHWY2Epyson3zD+3WrmNkxcP8fE=;
        b=AYFuqkHOUU1egz0Apdu9GoHX9y2cCoao6cBOx/j5ubsJDuPkddbORfz8R5xgTK98wPnw3x
        p9cUIlx8a9PJKdpOUlSLxXzmoaYEFQ1kChc90ltXmMinTWJ2DWXgfBo7o0V8Z/1AGIEXnn
        0czt5OAMjAVthIVi8eXfRzcaZYVQmus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-cbrHzUlBOtOuAPl1eOiXhQ-1; Mon, 27 Jan 2020 10:29:45 -0500
X-MC-Unique: cbrHzUlBOtOuAPl1eOiXhQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92F198017CC;
        Mon, 27 Jan 2020 15:29:44 +0000 (UTC)
Received: from Lucys-MacBook-Air.local (ovpn-117-14.phx2.redhat.com [10.3.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D15B591821;
        Mon, 27 Jan 2020 15:29:37 +0000 (UTC)
Subject: Re: [PATCH 2/2] libxfs: move header includes closer to kernelspace
To:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
 <4d8501f5-4db1-9f46-bbf8-e2a7ae5726b6@redhat.com>
 <20200125231532.GD15222@infradead.org>
From:   Eric Sandeen <esandeen@redhat.com>
Message-ID: <49936549-03d7-7228-157c-93d8d4424665@redhat.com>
Date:   Mon, 27 Jan 2020 09:29:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200125231532.GD15222@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/25/20 5:15 PM, Christoph Hellwig wrote:
> On Wed, Jan 22, 2020 at 10:48:51AM -0600, Eric Sandeen wrote:
>> Aid application of future kernel patches which change #includes;
>> not all headers exist in userspace so this is not a 1:1 match, but
>> it brings userspace files a bit closer to kernelspace by adding all
>> #includes which do match, and putting them in the same order.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Given how our headers are such a mess I wonder if we should reduce them
> to something like just a handful.  Life would become a lot simpler..

IIRC we explicitly moved away from that at one point.  *shrug* not sure
what the best approach is but I don't want to keep oscillating.

-Eric

