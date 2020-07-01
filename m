Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5F7C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 18:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C86420760
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 18:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+qH9l5u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgGAStG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 14:49:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58604 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726009AbgGAStG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 14:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593629343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TN/nxRsadnDgynU0Vz0HaIEVsUduOsCFWWAv63hpkI4=;
        b=K+qH9l5uTdq6bBXEOsD+kkwRi2ZJqUi7lL04VHeBLk1Wzq4Grfb4IHVaUT/mr65v5np0Jo
        mGfvK8R7sLweu0yfyRnS3GyYIedOb6ShKmaIwLqEJa27fH+5/sFD33Qy0amK1arMD3SiZZ
        EzCIB4VUUCqN41ZiPZcBk622C1OELh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-ZUTRldzcMkOVVjHUXY09vQ-1; Wed, 01 Jul 2020 14:49:00 -0400
X-MC-Unique: ZUTRldzcMkOVVjHUXY09vQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FC28800C60;
        Wed,  1 Jul 2020 18:48:59 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EB4873FC1;
        Wed,  1 Jul 2020 18:48:59 +0000 (UTC)
Subject: Re: [PATCH 14/18] xfs: refactor quota exceeded test
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353180004.2864738.3571543752803090361.stgit@magnolia>
 <20200701085621.GN25171@infradead.org> <20200701175134.GU7606@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <113694f7-5695-e245-5531-e8534d44a476@redhat.com>
Date:   Wed, 1 Jul 2020 13:48:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701175134.GU7606@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/1/20 12:51 PM, Darrick J. Wong wrote:
> On Wed, Jul 01, 2020 at 09:56:21AM +0100, Christoph Hellwig wrote:
>> On Tue, Jun 30, 2020 at 08:43:20AM -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Refactor the open-coded test for whether or not we're over quota.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>  fs/xfs/xfs_dquot.c |   95 ++++++++++++++++------------------------------------
>>>  1 file changed, 30 insertions(+), 65 deletions(-)
>>>
>>>
>>> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
>>> index 35a113d1b42b..ef34c82c28a0 100644
>>> --- a/fs/xfs/xfs_dquot.c
>>> +++ b/fs/xfs/xfs_dquot.c
>>> @@ -97,6 +97,33 @@ xfs_qm_adjust_dqlimits(
>>>  		xfs_dquot_set_prealloc_limits(dq);
>>>  }
>>>  
>>> +/*
>>> + * Determine if this quota counter is over either limit and set the quota
>>> + * timers as appropriate.
>>> + */
>>> +static inline void
>>> +xfs_qm_adjust_res_timer(
>>> +	struct xfs_dquot_res	*res,
>>> +	struct xfs_def_qres	*dres)
>>> +{
>>> +	bool			over;
>>> +
>>> +#ifdef DEBUG
>>> +	if (res->hardlimit)
>>> +		ASSERT(res->softlimit <= res->hardlimit);
>>> +#endif
>>
>> Maybe:
>> 	ASSERRT(!res->hardlimit || res->softlimit <= res->hardlimit);
> 
> Changed.
> 
>>
>>> +
>>> +	over = (res->softlimit && res->count > res->softlimit) ||
>>> +	       (res->hardlimit && res->count > res->hardlimit);
>>> +
>>> +	if (over && res->timer == 0)
>>> +		res->timer = ktime_get_real_seconds() + dres->timelimit;
>>> +	else if (!over && res->timer != 0)
>>> +		res->timer = 0;
>>> +	else if (!over && res->timer == 0)
>>> +		res->warnings = 0;
>>
>> What about:
>>
>> 	if ((res->softlimit && res->count > res->softlimit) ||
>> 	    (res->hardlimit && res->count > res->hardlimit)) {
>> 		if (res->timer == 0)	
>> 			res->timer = ktime_get_real_seconds() + dres->timelimit;
>> 	} else {
>> 		if (res->timer)
>> 			res->timer = 0;
>> 		else
>> 			res->warnings = 0;
>> 	}
> 
> I don't care either way, but the last time I sent this patch out, Eric
> and Amir seemed to want a flatter if structure:
> 
> https://lore.kernel.org/linux-xfs/b979d33d-361b-88cd-699c-7e5f1c621698@sandeen.net/
> https://lore.kernel.org/linux-xfs/CAOQ4uxiveTQu8_7UOvN07=P4o9hBBZTCyu4sSw5UpbrNPQL2pQ@mail.gmail.com/
> 
> Granted that was before I pulled the whole thing into a separate helper
> function, so maybe the context is different here...?

I think it is different.  I'm not too hung up about either way and
can't promise to dedicate time to thinking about it soon, so -
as you wish.  :)

-Eric

