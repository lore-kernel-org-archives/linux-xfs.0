Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E124BC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 18:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB55623AA9
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 18:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAOSbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 13:31:45 -0500
Received: from sandeen.net ([63.231.237.45]:59304 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAOSbp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 13:31:45 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8FEA279C0;
        Fri, 15 Jan 2021 12:29:25 -0600 (CST)
Subject: Re: [PATCH 0/6] debian: xfsprogs package clean-up
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Nathan Scott <nathans@redhat.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Bastian Germann <bastiangermann@fishpost.de>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com>
 <20210115041445.GI1164248@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <352a0d56-b63a-2523-5e1a-762965179517@sandeen.net>
Date:   Fri, 15 Jan 2021 12:31:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210115041445.GI1164248@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/14/21 10:14 PM, Darrick J. Wong wrote:
> On Fri, Jan 15, 2021 at 02:40:39PM +1100, Nathan Scott wrote:
>> Heya,
>>
>> On Fri, Jan 15, 2021 at 5:39 AM Bastian Germann
>> <bastiangermann@fishpost.de> wrote:
>>>
>>> Apply some minor changes to the xfsprogs debian packages, including
>>> missing copyright notices that are required by Debian Policy.
>>>
>>> Bastian Germann (6):
>>>   debian: cryptographically verify upstream tarball
>>>   debian: remove dependency on essential util-linux
>>>   debian: remove "Priority: extra"
>>>   debian: use Package-Type over its predecessor
>>>   debian: add missing copyright info
>>>   debian: new changelog entry
>>
>> Having reviewed each of these, please add for each:
>>
>> Signed-off-by: Nathan Scott <nathans@debian.org>
> 
> Assuming that SOB also applies to the patch below, someone please add a
> commit message, and:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Will do.  Nathan, it's easier if you send a proper patch ;)

Thanks,
-Eric
