Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E94C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 22:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C536021974
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 22:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MXA0a5PY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgINWMs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 18:12:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725926AbgINWMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 18:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600121565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrljUwaC/GnqYIpUD8OwNMQRLx0HGBEMmfgYnsSDoGc=;
        b=MXA0a5PY36XjdLF+65gRQh5VaBXO09/j1n6k+thuc5OMXkUS/dRNTRiv1JV6EL12vltA8g
        a4kk16o0s8Gtt8+BjQv3MoOaaqL1RU6KeL3+GdWx496ph8eApxstxCTwPvTaK9skoFZO01
        yxaU0AVLp1r3+2VvDNZYZGWdXeKVnaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-1i_4u_LhPJ6kAtWZeW-qBA-1; Mon, 14 Sep 2020 18:12:43 -0400
X-MC-Unique: 1i_4u_LhPJ6kAtWZeW-qBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53F021005E67;
        Mon, 14 Sep 2020 22:12:42 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D65457BE76;
        Mon, 14 Sep 2020 22:12:41 +0000 (UTC)
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>
References: <20200911164311.GU7955@magnolia>
 <20200914072909.GC29046@infradead.org> <20200914211241.GA7955@magnolia>
 <20200914215442.GV12131@dread.disaster.area>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <424e2645-8130-4331-eb73-4187645a02ce@redhat.com>
Date:   Mon, 14 Sep 2020 17:12:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200914215442.GV12131@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/14/20 4:54 PM, Dave Chinner wrote:
> On Mon, Sep 14, 2020 at 02:12:41PM -0700, Darrick J. Wong wrote:
>> On Mon, Sep 14, 2020 at 08:29:09AM +0100, Christoph Hellwig wrote:
>>> On Fri, Sep 11, 2020 at 09:43:11AM -0700, Darrick J. Wong wrote:
>>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>>
>>>> The V4 filesystem format contains known weaknesses in the on-disk format
>>>> that make metadata verification diffiult.  In addition, the format will
>>>> does not support dates past 2038 and will not be upgraded to do so.
>>>> Therefore, we should start the process of retiring the old format to
>>>> close off attack surfaces and to encourage users to migrate onto V5.
>>>>
>>>> Therefore, make XFS V4 support a configurable option.  For the first
>>>> period it will be default Y in case some distributors want to withdraw
>>>> support early; for the second period it will be default N so that anyone
>>>> who wishes to continue support can do so; and after that, support will
>>>> be removed from the kernel.
>>>>
>>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>>> ---
>>>> v3: be a little more helpful about old xfsprogs and warn more loudly
>>>> about deprecation
>>>> v2: define what is a V4 filesystem, update the administrator guide
>>>
>>> Whie this patch itself looks good, I think the ifdef as is is rather
>>> silly as it just prevents mounting v4 file systems without reaping any
>>> benefits from that.
>>>
>>> So at very least we should add a little helper like this:
>>>
>>> static inline bool xfs_sb_is_v4(truct xfs_sb *sbp)
>>> {
>>> 	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
>>> 		return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
>>> 	return false;
>>> }
>>>
>>> and use it in all the feature test macros to let the compile eliminate
>>> all the dead code.
>>
>> Oh, wait, you meant as a means for future patches to make various bits
>> of code disappear, not just as a weird one-off thing for this particular
>> patch?
>>
>> I mean... maybe we should just stuff that into the hascrc predicate,
>> like Eric sort of implied on irc.  Hmm, I'll look into that.
> 
> Killing dead code is not the goal of this patch, getting the policy
> in place and documenting it sufficiently is the goal of this patch.
> 
> Optimise the implementation in follow-on patches, don't obfuscate
> this one by commingling it with wide-spread code changes...

Agreed - 

To be clear, the (messy) patch I sent was supposed to be a follow on
patch, not something to merge with the original.

-Eric

