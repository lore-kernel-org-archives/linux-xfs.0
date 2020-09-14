Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EC9C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 22:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C482065E
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 22:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CcBp+EMS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgINW3X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 18:29:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53665 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725926AbgINW3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 18:29:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600122561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSZdDDsW5T5YkD+ZVbDEe4jSk8RbDEUltE0D7vdsqdo=;
        b=CcBp+EMSb6IJ5b7KdKq7fGZ9BJSp2+655N8vlFC2RQOeNzFNke5PPnuZIjn4eu5m+LjihT
        BUoa2vEuHsah1wYUfMxV4bDYUtgtntidmNbnR0ye4xu4qLqta3NC4x63P8yxqoXXDBK81K
        AgpPPv8GrqeuE+4gytib87Gc6cDmexk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-IbLpicHoMcS5g-846bFJpg-1; Mon, 14 Sep 2020 18:29:19 -0400
X-MC-Unique: IbLpicHoMcS5g-846bFJpg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1901393B5;
        Mon, 14 Sep 2020 22:29:17 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9540A5DAA8;
        Mon, 14 Sep 2020 22:29:17 +0000 (UTC)
Subject: Re: [PATCH] mkfs.xfs: fix ASSERT on too-small device with stripe
 geometry
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Zdenek Kabelac <zkabelac@redhat.com>
References: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
 <20200914221201.GW12131@dread.disaster.area>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <48fb5c2a-8db0-3a57-2b0f-0f5f35864e53@redhat.com>
Date:   Mon, 14 Sep 2020 17:29:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200914221201.GW12131@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/14/20 5:12 PM, Dave Chinner wrote:
> On Mon, Sep 14, 2020 at 01:26:01PM -0500, Eric Sandeen wrote:
>> When a too-small device is created with stripe geometry, we hit an
>> assert in align_ag_geometry():
>>
>> # truncate --size=10444800 testfile
>> # mkfs.xfs -dsu=65536,sw=1 testfile 
>> mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.
>>
>> This is because align_ag_geometry() finds that the size of the last
>> (only) AG is too small, and attempts to trim it off.  Obviously 0
>> AGs is invalid, and we hit the ASSERT.
>>
>> Fix this by skipping the last-ag-trim if there is only one AG, and
>> add a new test to validate_ag_geometry() which offers a very specific,
>> clear warning if the device (in dblocks) is smaller than the minimum
>> allowed AG size.
>>
>> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index a687f385..da8c5986 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -1038,6 +1038,15 @@ validate_ag_geometry(
>>  	uint64_t	agsize,
>>  	uint64_t	agcount)
>>  {
>> +	/* Is this device simply too small? */
>> +	if (dblocks < XFS_AG_MIN_BLOCKS(blocklog)) {
>> +		fprintf(stderr,
>> +	_("device (%lld blocks) too small, need at least %lld blocks\n"),
>> +			(long long)dblocks,
>> +			(long long)XFS_AG_MIN_BLOCKS(blocklog));
>> +		usage();
>> +	}
> 
> Ummm, shouldn't this be caught two checks later down by this:
> 
> 	if (agsize > dblocks) {
>                fprintf(stderr,
>         _("agsize (%lld blocks) too big, data area is %lld blocks\n"),
>                         (long long)agsize, (long long)dblocks);
>                         usage();
>         }

No, because we hit an ASSERT before we ever called this validation
function.

The error this is trying to fix is essentially: Do not attempt to
trim off the last/only AG in the filesystem.

-Eric


