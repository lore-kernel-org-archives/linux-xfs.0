Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F453C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 16:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 224FA20679
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 16:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhEV8nmW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgBQQEF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 11:04:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52826 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726492AbgBQQEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 11:04:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581955444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHtcXsfNh7Dn/qroVk5s59t2+IJxEuCb9pqy7WLEOdM=;
        b=HhEV8nmWn69H2C1lxIm9p4lbRsxq267UQ0BT2WawQzzz9GwxZc1f5eQ+4T/NpSZCX82Ddx
        MNo2d6zioKuywpzuZpKp8lhJG5takRADxJt9IC5jwoY9NwOfZ8PWgiMDRUJ9OpTu9zu5HC
        CLG9jqcQL4nXnpfrN595ncY2RzM5Ccw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-Lcsl-HsaPPS21yTFmsH3RA-1; Mon, 17 Feb 2020 11:04:01 -0500
X-MC-Unique: Lcsl-HsaPPS21yTFmsH3RA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBEE118A8C86;
        Mon, 17 Feb 2020 16:04:00 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF7875C241;
        Mon, 17 Feb 2020 16:04:00 +0000 (UTC)
Subject: Re: [PATCH 4/4] xfs: per-type quota timers and warn limits
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <7a35e397-dbc7-b991-6277-5f9931d03950@redhat.com>
 <20200217134339.GI31012@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <0ed308e8-6a66-c43c-c94d-5ee782781aa3@redhat.com>
Date:   Mon, 17 Feb 2020 10:03:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200217134339.GI31012@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/17/20 7:43 AM, Christoph Hellwig wrote:
>>  	struct xfs_disk_dquot	*d = &dq->q_core;
>> +	struct xfs_def_quota	*defq;
>> +
>>  	ASSERT(d->d_id);
>> +	defq = xfs_get_defquota(dq);
> 
> Move up to the declaration line?

*shrug* ok

>> +	switch (type) {
>> +	case XFS_DQ_USER:
>> +		defq = &qinf->qi_usr_default;
>> +		break;
>> +	case XFS_DQ_GROUP:
>> +		defq = &qinf->qi_grp_default;
>> +		break;
>> +	case XFS_DQ_PROJ:
>> +		defq = &qinf->qi_prj_default;
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		/* fall through */
>> +	}
> 
> Should this go into a helper?  Or even better replace the
> qi_*default members with an array that the type can index into?

Like maybe xfs_get_defquota() ;)

Not sure what I was thinking here, whoops.

>> @@ -592,39 +609,31 @@ xfs_qm_init_timelimits(
>>  	 *
>>  	 * Since we may not have done a quotacheck by this point, just read
>>  	 * the dquot without attaching it to any hashtables or lists.
>> -	 *
>> -	 * Timers and warnings are globally set by the first timer found in
>> -	 * user/group/proj quota types, otherwise a default value is used.
>> -	 * This should be split into different fields per quota type.
>>  	 */
>> -	if (XFS_IS_UQUOTA_RUNNING(mp))
>> -		type = XFS_DQ_USER;
>> -	else if (XFS_IS_GQUOTA_RUNNING(mp))
>> -		type = XFS_DQ_GROUP;
>> -	else
>> -		type = XFS_DQ_PROJ;
>>  	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
>>  	if (error)
>>  		return;
>>  
>>  	ddqp = &dqp->q_core;
>> +	defq = xfs_get_defquota(dqp);
> 
> Isn't the defq variable already initialized earlier in the function?

Oh, uh ... whoops.  Not sure how I messed that up, thanks.

-Eric

