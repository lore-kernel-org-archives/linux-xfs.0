Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A15C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B6FF206E6
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hifD1oFJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgEKQAt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 12:00:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29171 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729550AbgEKQAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 12:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589212848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zYkoZExKyvCcHdBmejCg4k8guvH/Tz5NrEZH1+evYtc=;
        b=hifD1oFJHKkZ6oDc1LQw+0Waz38k7InshHihRMxMpXy9XuCMjnTONjEq0FIBCGnIY1F8Bw
        RAO3lrw9C0YMzN3KksxJDJXdbKJpwkvUBhQhxwIPxOw+oK5ZRN2LWBQJ6JF3dXQ/EPGJxF
        /P7k2FRSOKGQ35N1TLwx8IMeKm+mLWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-gVHA4JFgOSu8nht_XQ0yfg-1; Mon, 11 May 2020 12:00:44 -0400
X-MC-Unique: gVHA4JFgOSu8nht_XQ0yfg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 751178730B2;
        Mon, 11 May 2020 16:00:43 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7A960BF4;
        Mon, 11 May 2020 16:00:43 +0000 (UTC)
Subject: Re: [PATCH] xfs_quota: refactor code to generate id from name
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <8b4b7edb-94b2-3bb1-9ede-73674db82330@redhat.com>
 <20200511153249.GA11320@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <4b3f4a0c-d04d-756d-8558-0f83e612bc2e@redhat.com>
Date:   Mon, 11 May 2020 11:00:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511153249.GA11320@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/11/20 10:32 AM, Christoph Hellwig wrote:
> On Sat, May 09, 2020 at 12:18:42PM -0500, Eric Sandeen wrote:

...

>> @@ -101,6 +101,42 @@ warn_help(void)
>>  "\n"));
>>  }
>>  
>> +static uint32_t
>> +id_from_string(
>> +	char	*name,
>> +	int	type)
>> +{
>> +	uint32_t	id = -1;
>> +
>> +	switch (type) {
>> +	case XFS_USER_QUOTA:
>> +		id = uid_from_string(name);
>> +		if (id == -1)
>> +			fprintf(stderr, _("%s: invalid user name: %s\n"),
>> +				progname, name);
>> +		break;
>> +	case XFS_GROUP_QUOTA:
>> +		id = gid_from_string(name);
>> +		if (id == -1)
>> +			fprintf(stderr, _("%s: invalid group name: %s\n"),
>> +				progname, name);
>> +		break;
>> +	case XFS_PROJ_QUOTA:
>> +		id = prid_from_string(name);
>> +		if (id == -1)
>> +			fprintf(stderr, _("%s: invalid project name: %s\n"),
>> +				progname, name);
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		break;
>> +	}
>> +
>> +	if (id == -1)
>> +		exitcode = 1;
>> +	return id;
> 
> What about de-duplicating the error printk as well?

Oh yeah, good idea, I'll do that and send V2.

for some reason I always forget about handling things like this in
this way.  :)

Thanks,
-Eric

