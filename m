Return-Path: <SRS0=drEG=3Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92D5C2D0DB
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 15:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2716214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 15:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODR8m+kq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgA0P2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 10:28:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729146AbgA0P2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 10:28:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580138909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DDGe7pcM57j040T6nx+tiqHwk2XHEY2VlPzIDxTHZ6A=;
        b=ODR8m+kqXaPb5U+pghi9MByybM8TOhDsbpf9aEwi7ewRT83VKyLP7Ha1JTOLPL4AM734J0
        joXKK6gZZS+YNf1Md+KkXhZrTlBxQ2RieruE06Ejtz0Tl/Dl5GYQ5Nv8l9Ba2jhbP/Uj9x
        w7q/jOLSOkSV2RGYFv2jVSqlEIRr3eI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-UcNoMKR-ONiWzYz1JQJC6A-1; Mon, 27 Jan 2020 10:28:25 -0500
X-MC-Unique: UcNoMKR-ONiWzYz1JQJC6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9630E141F;
        Mon, 27 Jan 2020 15:28:24 +0000 (UTC)
Received: from Lucys-MacBook-Air.local (ovpn-117-14.phx2.redhat.com [10.3.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B15786E3F;
        Mon, 27 Jan 2020 15:28:20 +0000 (UTC)
Subject: Re: [PATCH 1/2] xfsprogs: alphabetize libxfs_api_defs.h
To:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
 <5660a718-54b8-2139-8bcf-ae362d09ee5e@redhat.com>
 <20200125231443.GC15222@infradead.org>
From:   Eric Sandeen <esandeen@redhat.com>
Message-ID: <804c4d02-3f9e-6bef-4149-9c61d90d74a6@redhat.com>
Date:   Mon, 27 Jan 2020 09:28:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200125231443.GC15222@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/25/20 5:14 PM, Christoph Hellwig wrote:
> On Wed, Jan 22, 2020 at 10:41:05AM -0600, Eric Sandeen wrote:
>> Rather than randomly choosing locations for new #defines in the
>> future, alphabetize the file now for consistency.
> 
> This looks ok, but can we just kill off the stupid libxfs_ aliases
> instead?  They add absolutely no value.  I volunteer to do the work.

No disagreement from me but dchinner may have thoughts.

I don't see any benefit either, and it's definitely additional cost.

-Eric

