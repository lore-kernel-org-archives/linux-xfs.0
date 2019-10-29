Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E6CCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8CFF2086A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rqe/jchq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388193AbfJ2Ner (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 09:34:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387890AbfJ2Ner (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 09:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572356085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vY3Rpc7NAgktb20mCVSUJ3cbmS5Kspb5T/Ov2HRPfLg=;
        b=Rqe/jchqevs8kbqJFvgErusiHdppU9/gJaCvHH1nSTMulrtR/h6PcB3Stnm+PICzeMypVM
        1NL7W7/azbsBV+Ln0kEySX5HTU2vuobtdI/74zcOQHIxeDIjS8TeQfRb/jLEXlGaKalUun
        EQbf0Inl6dMW36ns0fL3Zzh7dbSQB8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-rEkwv9G7OgOU2EIKNe86Kw-1; Tue, 29 Oct 2019 09:34:42 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F92F1005500;
        Tue, 29 Oct 2019 13:34:41 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 368511001DD7;
        Tue, 29 Oct 2019 13:34:41 +0000 (UTC)
Subject: Re: [PATCH] xfs_growfs: allow mounted device node as argument
To:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <0283f073-88d8-977f-249c-f813dabd9390@redhat.com>
 <20191029071536.GA31501@infradead.org>
 <6a30d8d1-8786-f7cd-f897-d4d6d6f517f5@sandeen.net>
 <20191029132646.GA5180@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <74d87741-fc37-1810-3999-e6a6f196590d@redhat.com>
Date:   Tue, 29 Oct 2019 08:34:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191029132646.GA5180@infradead.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: rEkwv9G7OgOU2EIKNe86Kw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/29/19 8:26 AM, Christoph Hellwig wrote:
> On Tue, Oct 29, 2019 at 08:24:50AM -0500, Eric Sandeen wrote:
>>
>>
>> On 10/29/19 2:15 AM, Christoph Hellwig wrote:
>>> On Mon, Oct 28, 2019 at 10:23:51PM -0500, Eric Sandeen wrote:
>>>> I can clone tests/xfs/289 to do tests of similar permutations for
>>>> device names.
>>>
>>> Can we just add the device name based tests to xfs/289?
>>
>> Could do, I was hesitant to make a once-passing test start failing on ol=
der
>> userspace. (maybe we should formalize a policy for this sort of thing)
>=20
> Well, it is supposed to work for all but one release, right?

Pointing it at a device has been broken since 4.12, so broken for about
a dozen releases / ~2+ years.

-Eric


