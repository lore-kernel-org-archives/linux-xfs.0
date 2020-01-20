Return-Path: <SRS0=roPR=3J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1397C2D0DB
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93B5020678
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jan 2020 14:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QhA7l619"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATO3Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jan 2020 09:29:24 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29750 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726626AbgATO3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jan 2020 09:29:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579530562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sj01dYQGgtKILxU7DgDsGTEYv8tsP6S3m20/J3HxK7E=;
        b=QhA7l619beVvGGc0/4XNonPOFLjvH1o4JajVFQvOxtcVpyVlGWWMviabOJULxUZ3deDYh6
        mw8NolQytaxM/w66TV9Y1Lt2LyyHeP+aBmIF4eay4uTHvSa48tI5EiCYvs/e1QmFZTSNHU
        BTJP6xuGMM/26CgBNyK9y8HjeXDAqnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-7AL_AECFMaOyE1-Ta_xf4A-1; Mon, 20 Jan 2020 09:29:19 -0500
X-MC-Unique: 7AL_AECFMaOyE1-Ta_xf4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D79BDB62;
        Mon, 20 Jan 2020 14:29:18 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 516217DB5D;
        Mon, 20 Jan 2020 14:29:18 +0000 (UTC)
Subject: Re: [PATCH] xfs_repair: stop using ->data_entry_p()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <2cf1f45b-b3b2-f630-50d5-ff34c000b0c8@redhat.com>
 <20200118043947.GO8257@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <57ab702d-0a66-8323-5e87-08aa315cf9c7@redhat.com>
Date:   Mon, 20 Jan 2020 08:29:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200118043947.GO8257@magnolia>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/17/20 10:39 PM, Darrick J. Wong wrote:
> On Fri, Jan 17, 2020 at 05:17:11PM -0600, Eric Sandeen wrote:
>> The ->data_entry_p() op went away in v5.5 kernelspace, so rework
>> xfs_repair to use ->data_entry_offset instead, in preparation
>> for the v5.5 libxfs backport.
>>
>> This could later be cleaned up to use offsets as was done
>> in kernel commit 8073af5153c for example.
> 
> See, now that you've said that, I start wondering why not do that?

Because this is the fast/safe path to getting the libxfs merge done IMHO ;)

...


>> @@ -1834,7 +1834,7 @@ longform_dir2_entry_check_data(
>>  			       (dep->name[0] == '.' && dep->namelen == 1));
>>  			add_inode_ref(current_irec, current_ino_offset);
>>  			if (da_bno != 0 ||
>> -			    dep != M_DIROPS(mp)->data_entry_p(d)) {
>> +			    dep != (void *)d + M_DIROPS(mp)->data_entry_offset) {
> 
> Er.... void pointer arithmetic?

er, let me take another look at that.

-eric


