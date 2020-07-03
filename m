Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0869C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 03:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B8C920781
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 03:05:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XTuzQY6/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGCDFU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 23:05:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44632 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726065AbgGCDFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 23:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593745519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nT5nUdX/XIXMp0SEBuIisefVG98qior59Pb7SabULTU=;
        b=XTuzQY6/AwCBPgMjLylAFwmB6wLqvfstaxNdLyFXTHFafO7WR07pOjsJsUSXZ0xhnneB2s
        uO4LtMmP+Ts68RUScq8SVb7oqbT5PhzZ2wCud4GT6oimv7fUnPfdPvmDOJyScR9cny9gnJ
        ubleCbUUIAsvgifkmCAXy3W3bWjrYgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-1z8sNEliMLCBosM8IsGV_g-1; Thu, 02 Jul 2020 23:05:17 -0400
X-MC-Unique: 1z8sNEliMLCBosM8IsGV_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CE07BFC0;
        Fri,  3 Jul 2020 03:05:15 +0000 (UTC)
Received: from llong.remote.csb (ovpn-112-82.rdu2.redhat.com [10.10.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D402612BA;
        Fri,  3 Jul 2020 03:05:11 +0000 (UTC)
Subject: Re: [PATCH v5] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
References: <20200702005923.10064-1-longman@redhat.com>
 <20200703010720.GH5369@dread.disaster.area>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <85cbaacf-6986-d363-5c80-530be9a6fa63@redhat.com>
Date:   Thu, 2 Jul 2020 23:05:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200703010720.GH5369@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/2/20 9:07 PM, Dave Chinner wrote:
> On Wed, Jul 01, 2020 at 08:59:23PM -0400, Waiman Long wrote:
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   fs/xfs/xfs_super.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 379cbff438bc..dcc97bad950a 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -913,11 +913,21 @@ xfs_fs_freeze(
>>   	struct super_block	*sb)
>>   {
>>   	struct xfs_mount	*mp = XFS_M(sb);
>> +	unsigned long		pflags;
>> +	int			ret;
>>   
>> +	/*
>> +	 * Disable fs reclaim in memory allocation for fs freeze to avoid
>> +	 * causing a possible circular locking dependency lockdep splat
>> +	 * relating to fs reclaim.
>> +	 */
> 	/*
> 	 * The filesystem is now frozen far enough that memory reclaim
> 	 * cannot safely operate on the filesystem. Hence we need to
> 	 * set a GFP_NOFS context here to avoid recursion deadlocks.
> 	 */
>
>> +	current_set_flags_nested(&pflags, PF_MEMALLOC_NOFS);
> memalloc_nofs_save/restore(), please.

Thanks for the comments, I will make the suggested change.

Cheers,
Longman

