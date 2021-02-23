Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5F8C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 21:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD9764E60
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 21:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhBWVGb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 16:06:31 -0500
Received: from sandeen.net ([63.231.237.45]:50316 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhBWVGO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 16:06:14 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E4FDE6262A9;
        Tue, 23 Feb 2021 15:05:19 -0600 (CST)
Subject: Re: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-3-preichl@redhat.com>
 <61f66b91-4343-f28e-dd47-6b6c70ee8b96@sandeen.net>
 <e29b3877-385b-3e0a-5761-51bb1265b302@redhat.com>
 <a5a94542-750c-0741-f95d-799e34656ca0@sandeen.net>
 <20210223182517.GM7272@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3b9366a3-c4ee-a7a0-ea8e-2dc1b3b4c0aa@sandeen.net>
Date:   Tue, 23 Feb 2021 15:05:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223182517.GM7272@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/23/21 12:25 PM, Darrick J. Wong wrote:

>> Ok, yup, I see.  so I guess we kind of have:
>>
>> *parsing_mp = fc->s_fs_info;
>>
>> and 
>>
>> *current_mp = XFS_M(fc->root->d_sb);
>>
>> (variable names not actually in the code, just used for example)
> 
> Maybe they should be. ;)

Yup I almost suggested at least a comment. And since we do care about the
actual/live *mp now, maybe adding self-describing variable names would be a
help.

-Eric

> --D
> 
>> Sorry for the noise, my mistake!
>>
>> -Eric
> 
