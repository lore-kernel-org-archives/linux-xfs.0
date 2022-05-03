Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A7FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 07:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiECHzJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 03:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiECHzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 03:55:09 -0400
Received: from sender11-of-o53.zoho.eu (sender11-of-o53.zoho.eu [31.186.226.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAB5DF80
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 00:51:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1651564282; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Zzg25sy8msN6LvS2D6m8s5a/fbKNNdPzmmfwZk2LiYruGreSR94PKhVmYGEo6P5Ws36oJ+MwISBSCYmXA2Dk5PpqwpP2MxfTzghPmGC1mHB9oNjYgfbptMrJ9SrBqkqTIx+lXrkKebLOQ3kHqnc0zkzPWhwNDa6lxnhxf/ngVOo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1651564282; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=0KaPKaisfDzF9VrX5Zj47/b81/SnXk3rE/Fn9wNLyyo=; 
        b=kq5uTb0VcL7OliYO7somUVvoH3hScFTVQqgwl90leSEKJpD6e7BpvMvZXxM0ouTssLAwrIu8JiN2Jhv6u7oiwfsrWSKNKlpNIvbVuWaL7PZOS1UaTVhnIh12f3Qge7Qmkzd6jaWMPMGLjB1EGn1NtoUe7cKqBQQdZ+8pvrM2FT0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from [192.168.1.118] (port-92-194-239-176.dynamic.as20676.net [92.194.239.176]) by mx.zoho.eu
        with SMTPS id 1651564280244705.8633774298872; Tue, 3 May 2022 09:51:20 +0200 (CEST)
Message-ID: <361170e0-c05e-4c49-61bc-226bbad681d2@debian.org>
Date:   Tue, 3 May 2022 09:51:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 1/1] debian: Generate .gitcensus instead of .census
 (Closes: #999743)
Content-Language: de-DE-frami
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
References: <20211207122110.1448-1-bage@debian.org>
 <20211207122110.1448-2-bage@debian.org>
 <b51a775f-5fcd-a569-6a23-e9c91ab43c5f@debian.org>
 <1730046a-b76d-ea71-687d-1c6b57a9b14c@sandeen.net>
From:   Bastian Germann <bage@debian.org>
In-Reply-To: <1730046a-b76d-ea71-687d-1c6b57a9b14c@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 03.05.22 um 01:25 schrieb Eric Sandeen:
> On 4/17/22 5:00 AM, Bastian Germann wrote:
>> Hi!
>>
>> Am 07.12.21 um 13:21 schrieb Bastian Germann:
>>> Fix the Debian build outside a git tree (e.g., Debian archive builds) by
>>> creating an empty .gitcensus instead of .census file on config.
>>>
>>> Signed-off-by: Bastian Germann <bage@debian.org>
>>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>> 2nd friendly ping on this.
>> For the last few Debian releases, I applied this.
> 
> Very sorry for the delay. Does this need magic in debian/changelog
> to auto-close the bug?

When the "Closes: #999743" is contained in the changelog, it triggers an auto-close.
But I can also close it manually.

Thanks!
