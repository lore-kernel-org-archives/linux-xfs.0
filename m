Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1475CC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D198B20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CZiAYiEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYA6Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:58:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37443 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727696AbgBYA6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:58:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582592304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CPxO742Yg2htipAZnGp09mYX5mYzlET/AFjMh0MMQoY=;
        b=CZiAYiEwrWRyZrY2zaAXVnqaLN5xHsDOMToH588/iXIeA920GlmJP1NtaUaUtJ1K48rNzw
        nCwnHulgNcs3UpOK31a/wEhmAur5gV2PRc2t1UO5XXPtLAkkYdXX6nhAKv0Eok+djxt4uu
        zRafnVyepF9jV/sJyyhrSRCQCDYFDAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-REDMlangMR28id7Q-aRZEw-1; Mon, 24 Feb 2020 19:58:22 -0500
X-MC-Unique: REDMlangMR28id7Q-aRZEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4206D800D53;
        Tue, 25 Feb 2020 00:58:21 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0865D393;
        Tue, 25 Feb 2020 00:58:20 +0000 (UTC)
Subject: Re: [PATCH] xfs: mark ARM OABI as incompatible in Kconfig
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <ee78c5dd-5ee4-994c-47e2-209e38a9e986@redhat.com>
 <20200225005553.GD6740@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <79faa339-d6b8-d8eb-0857-7d755a780805@redhat.com>
Date:   Mon, 24 Feb 2020 16:58:20 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225005553.GD6740@magnolia>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/24/20 4:55 PM, Darrick J. Wong wrote:
> On Mon, Feb 24, 2020 at 04:49:12PM -0800, Eric Sandeen wrote:
>> The old ARM OABI's structure alignment quirks break xfs disk structures,
>> let's just move on and disallow it rather than playing whack-a-mole
>> for the infrequent times someone selects this old config, which is
>> usually during "make randconfig" tests.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
>> index e685299eb3d2..043624bd4ab2 100644
>> --- a/fs/xfs/Kconfig
>> +++ b/fs/xfs/Kconfig
>> @@ -2,6 +2,8 @@
>>  config XFS_FS
>>  	tristate "XFS filesystem support"
>>  	depends on BLOCK
>> +	# We don't support OABI structure alignment on ARM
> 
> Should this limitation be documented in the help screen?

Yeah probably.

But now looking at

aa2dd0ad4d6d xfs: remove __arch_pack

hch indicates that some non-arm architectures have similar problems,
so is there any point to excluding this one config on this one arch?

-Eric

