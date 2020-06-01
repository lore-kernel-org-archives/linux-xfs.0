Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3DCC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 141512065C
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 14:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iHcYPnne"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgFAOgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 10:36:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726073AbgFAOgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 10:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591022199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uv7AaPwWs8EdPhW2HxHx+aAutiasF6EyoQAK7Tq3G9I=;
        b=iHcYPnneqb0LIcixWxxK7C82jOJoqzJLMVspKOCyD/2e9g+/yG3nHxZ7ZEi6E6Ez4Cmnqp
        Xhmkd0xLx5HRJYHjtzJrmGwJ+Wx/UcAvjh960H4BjmwGt18u4Qj04iUhIVxaJhnNJpoC+W
        g5bGX7BpqkwxuymuHuln7/fdyvYxVNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-8xidFskNM8Ok98BvM_nhzQ-1; Mon, 01 Jun 2020 10:36:37 -0400
X-MC-Unique: 8xidFskNM8Ok98BvM_nhzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A63128005AA;
        Mon,  1 Jun 2020 14:36:36 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28A605D9DD;
        Mon,  1 Jun 2020 14:36:36 +0000 (UTC)
Subject: Re: [PATCH 2/4] generic: test per-type quota softlimit enforcement
 timeout
To:     Eryu Guan <guan@eryu.me>, linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
 <7102e1e3-bee6-7aa2-dce6-c0e7e0ce2983@redhat.com>
 <20200531161517.GC3363@desktop>
 <20200601124844.GI1938@dhcp-12-102.nay.redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <7d3fcdc7-8c00-8218-60e8-9d35c7f0bf1b@redhat.com>
Date:   Mon, 1 Jun 2020 09:36:35 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200601124844.GI1938@dhcp-12-102.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/1/20 7:48 AM, Zorro Lang wrote:
> On Mon, Jun 01, 2020 at 12:15:17AM +0800, Eryu Guan wrote:
>> On Mon, May 18, 2020 at 03:00:11PM -0500, Eric Sandeen wrote:
>>> From: Zorro Lang <zlang@redhat.com>
>>>
>>> Set different block & inode grace timers for user, group and project
>>> quotas, then test softlimit enforcement timeout, make sure different
>>> grace timers as expected.
>>>
>>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>
>> I saw the following failure as well on xfs (as Zorro mentioned in his v3
>> patch)
>>
>>      -pwrite: Disk quota exceeded
>>      +pwrite: No space left on device
>>
>> So this is an xfs issue that needs to be fixed? Just want to make sure
>> the current expected test result.
> 
> Hmm.... I think I'd better to filter ENOSPC|EDQUOT. I can't be sure all
> filesystems will return EDQUOT or ENOSPC 100%, especially for group and project
> quota.
> 
> But I think Eric's trying to change a return value of XFS quota. I don't know the
> current status.

This test will need to be updated, it sounds like ext4 does not plan to switch
to ENOSPC for project quota, so we'll need modify it to accept either one.

Zorro, didn't you do that for another test?  Maybe you can do the same here?

Thanks,
-Eric

