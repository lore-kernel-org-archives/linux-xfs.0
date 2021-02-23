Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C75C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16F8664DD3
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhBWSLX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 13:11:23 -0500
Received: from sandeen.net ([63.231.237.45]:41364 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231591AbhBWSLX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 13:11:23 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DA480611F0F;
        Tue, 23 Feb 2021 12:10:27 -0600 (CST)
To:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-3-preichl@redhat.com>
 <61f66b91-4343-f28e-dd47-6b6c70ee8b96@sandeen.net>
 <e29b3877-385b-3e0a-5761-51bb1265b302@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
Message-ID: <a5a94542-750c-0741-f95d-799e34656ca0@sandeen.net>
Date:   Tue, 23 Feb 2021 12:10:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <e29b3877-385b-3e0a-5761-51bb1265b302@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/23/21 11:53 AM, Pavel Reichl wrot
> 
> On 2/22/21 11:19 PM, Eric Sandeen wrote:
>>
>> On 2/20/21 4:15 PM, Pavel Reichl wrote:
>>> Skip the warnings about mount option being deprecated if we are
>>> remounting and deprecated option state is not changing.
>>>
>>> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
>>> Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
>>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>>> ---
>>>  fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
>>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index 813be879a5e5..6724a7018d1f 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -1169,6 +1169,13 @@ xfs_fs_parse_param(
>>>  	struct fs_parse_result	result;
>>>  	int			size = 0;
>>>  	int			opt;
>>> +	uint64_t                prev_m_flags = 0; /* Mount flags of prev. mount */
>>> +	bool			remounting = fc->purpose & FS_CONTEXT_FOR_RECONFIGURE;
>>> +
>>> +	/* if reconfiguring then get mount flags of previous flags */
>>> +	if (remounting) {
>>> +		prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
>>
>> I wonder, does mp->m_flags work just as well for this purpose? I do get lost
>> in how the mount api stashes things. I /think/ that the above is just a
>> long way of getting to mp->m_flags.
> 
> Hi Eric, I'm sorry to disagree, but I think that mp->m_flags is newly allocated for this mount and it's not populated with previous mount's mount options.

No need to be sorry ;) And in any case, you're corrrect here.

> 
> static int xfs_init_fs_context(
>         struct fs_context       *fc)
> {
>         struct xfs_mount        *mp;
> 
> So here it's allocated and zeroed
> 
>         mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
>         if (!mp)
>                 return -ENOMEM;
>                 
> ...

and eventually:

	fc->s_fs_info = mp;

Ok, yup, I see.  so I guess we kind of have:

*parsing_mp = fc->s_fs_info;

and 

*current_mp = XFS_M(fc->root->d_sb);

(variable names not actually in the code, just used for example)

Sorry for the noise, my mistake!

-Eric
