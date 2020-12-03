Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415B9C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E56BC207B8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgLCUO2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:14:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731655AbgLCUO2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:14:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607026381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VnwkKJutwfvWOAJXroET5L+xpad5LCc85PA2QknDago=;
        b=d0vNT3a6woVC5h4tLoMdYUysKUC6+cxbuVq+kOKLpAqWiuCsKnZWV7uOBaGZtWEaW0P1kI
        xRvIG9KWaPB7899FUqnJ/39zbQFEa/T6MciCncq+b90hrSwLvD7rpIoQ1m23kmkFwnwnww
        urBtt+YKY5XI7BxkYzo3I7B9L/Rpyvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-UJc0soEhNqGyyJj5vy_DGQ-1; Thu, 03 Dec 2020 15:12:59 -0500
X-MC-Unique: UJc0soEhNqGyyJj5vy_DGQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3B90800050;
        Thu,  3 Dec 2020 20:12:58 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 814BC1A839;
        Thu,  3 Dec 2020 20:12:58 +0000 (UTC)
Subject: Re: [PATCH 1/3] xfs_quota: document how the default quota is stored
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <2e9b1d0f-7ad8-b42a-ac2b-b1fdd9a9fb45@redhat.com>
 <20201203200753.GJ106272@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <8e0e818a-4e39-6a9b-fe89-19d786b82f12@redhat.com>
Date:   Thu, 3 Dec 2020 14:12:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201203200753.GJ106272@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/3/20 2:07 PM, Darrick J. Wong wrote:
> On Thu, Dec 03, 2020 at 02:00:01PM -0600, Eric Sandeen wrote:
>> Nowhere in the man page is the default quota described; what it
>> does or where it is stored.  Add some brief information about this.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  man/man8/xfs_quota.8 | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
>> index dd0479cd..b3c4108e 100644
>> --- a/man/man8/xfs_quota.8
>> +++ b/man/man8/xfs_quota.8
>> @@ -178,6 +178,11 @@ to a file on
>>  where the user's quota has not been exceeded.
>>  Then after rectifying the quota situation, the file can be moved back to the
>>  filesystem it belongs on.
>> +.SS Default Quotas
>> +The XFS quota subsystem allows a default quota to be enforced for any user which
> 
> "user"?  Does this not apply to group or project quotas? ;)

I thought about that, but the overview section already refers to "users" as a
generic idea, i.e. "Quotas can be set for each individual user on any/all of the
local filesystems."

I mean, I guess I could s/user/ID/ to be more clear or rewrite the whole overview...

>> +does not have a quota limit explicitly set. These limits are stored in and
> 
> Usual complaint about starting sentences in column zero in manpage
> source. :)

grumble grumble random nonobvious rules grumble ok

-Eric

> --D
> 
>> +displayed as the "root" user's limits, although they do not actually limit the
>> +root user.
>>  .SH USER COMMANDS
>>  .TP
>>  .B print
>> -- 
>> 2.17.0
>>
>>
> 

