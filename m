Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CC4C43603
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71EB3227BF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 23:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fUAychA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLRX1e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:27:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20885 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725948AbfLRX1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 18:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576711651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mpSaJVSX4XKQ4wL4+KPDCmMl7z+w79rKVRg+Z5xn20I=;
        b=fUAychA6h/1qM+Uui8VP0SvKSw/xphfqgUYKAMD+O6gJgwgDJw9rUSNuc4sGPmMROkM568
        d6HrbRD+wF33wfvccN8Lx3KU7dqwVAc6rtlgERWyAbXe8f9tvYjO1zhwj79wl6nmWkYa4f
        Uopr04e0SOzwp2GNw01nrkm7HP924DU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-hrJQC3SnMIeSSTSUx6SVtg-1; Wed, 18 Dec 2019 18:27:30 -0500
X-MC-Unique: hrJQC3SnMIeSSTSUx6SVtg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB040189CD02;
        Wed, 18 Dec 2019 23:27:29 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 530E468899;
        Wed, 18 Dec 2019 23:27:29 +0000 (UTC)
Subject: Re: [PATCH] xfs: fix sparse checker warnings on kmem tracepoints
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <7c2af866-5a8e-3f48-ac07-041c3085c545@redhat.com>
 <20191218231152.GL7489@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <91759bbe-2256-92da-249b-751aac997d82@redhat.com>
Date:   Wed, 18 Dec 2019 17:27:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191218231152.GL7489@magnolia>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/18/19 5:11 PM, Darrick J. Wong wrote:
> On Wed, Dec 18, 2019 at 04:18:16PM -0600, Eric Sandeen wrote:
>> Sparse checker doesn't like kmem.c tracepoints:
>>
>> kmem.c:18:32: warning: incorrect type in argument 2 (different base types)
>> kmem.c:18:32:    expected int [signed] flags
>> kmem.c:18:32:    got restricted xfs_km_flags_t [usertype] flags
>>
>> So take an xfs_km_flags_t, and cast it to an int when we print it.
>>
>> Fixes: 0ad95687c3ad ("xfs: add kmem allocation trace points")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks ok insofar as cem will eventually kill these off, right?
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Oh, I guess so - if you want to just wait for that and drop this
patch, it's fine.

-Eric

