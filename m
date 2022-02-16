Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAECAC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 17:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiBPRqt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 12:46:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbiBPRqr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 12:46:47 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDB7E1C11A
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 09:46:32 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BEDEF504E0B;
        Wed, 16 Feb 2022 11:45:50 -0600 (CST)
Message-ID: <c65ee741-662b-a112-b73c-a440552467ba@sandeen.net>
Date:   Wed, 16 Feb 2022 11:46:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <15b6f52f-a90b-7056-8b2e-e2d4dde1ef5d@redhat.com>
 <20220216171508.GL8313@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_admin: open with O_EXCL if we will be writing
In-Reply-To: <20220216171508.GL8313@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/16/22 11:15 AM, Darrick J. Wong wrote:
> On Tue, Feb 15, 2022 at 11:35:23PM -0600, Eric Sandeen wrote:
>> So, coreOS has a systemd unit which changes the UUID of a filesystem
>> on first boot, and they're currently racing that with mount.
>>
>> This leads to corruption and mount failures.
>>
>> If xfs_db is running as xfs_admin in a mode that can write to the
>> device, open that device exclusively.
>>
>> This might still lead to mount failures if xfs_admin wins the open race,
>> but at least it won't corrupt the filesystem along the way.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> (this opens plain files O_EXCL is well, which is undefined without O_CREAT.
>> I'm not sure if we need to worry about that.)
>>
>> diff --git a/db/init.c b/db/init.c
>> index eec65d0..f43be6e 100644
>> --- a/db/init.c
>> +++ b/db/init.c
>> @@ -97,6 +97,14 @@ init(
>>  	else
>>  		x.dname = fsdevice;
>>  
>> +	/*
>> +	 * If running as xfs_admin in RW mode, prevent concurrent
>> +	 * opens of a block device.
>> + 	 */
>> +	if (!strcmp(progname, "xfs_admin") &&
> 
> Hmm, it seems like sort of a hack to key this off the program name.
> Though Eric mentioned on IRC that Dave or someone expressed a preference
> for xfs_db not being gated on O_EXCL when a user is trying to run the
> program for *debugging*.
> 
> Perhaps "if (strcmp(progname, "xfs_db") &&" here?  Just in case we add
> more shell script wrappers for xfs_db in the future?  I prefer loosening
> restrictions as new functionality asks for them, rather than risk
> breaking scripts when we discover holes in new code later on.

I was just thinking about that last night. I agree, thanks.

> 
>> +	    (x.isreadonly != LIBXFS_ISREADONLY))
> 
> At first I wondered about the -i case where ISREADONLY and ISINACTIVE
> are set, but then I realized that -i ("do it even if mounted") isn't
> used by xfs_admin and expressly forbids the use of O_EXCL.  So I guess
> the equivalence test and the assignment below are ok, since x.isreadonly
> is zero at the start of xfs_db's init() function, and we'll never have
> to deal with other flags combinations that might've snuck in from
> somewhere else.  Right?

Hm, ok fair, let me give that more thought.

[ -i|r|x|F ] 

sounds exclusive but I don't think it's enforced. I think it was safe for
xfs_admin, but maybe not for db in general. I'll give it another look,
thanks.

>> +		x.isreadonly = LIBXFS_EXCLUSIVELY;
> 
> But this is still a mess.  Apparently libxfs_init_t.isdirect is for
> LIBXFS_DIRECT, but libxfs_init_t.isreadonly is for other four flags?
> But it doesn't really make much difference to libxfs_init() because it
> combines both fields?

yeah, ugly isn't it. :) I definitely cringed at "isreadonly = EXCLSUSIVELY" -
wut?

> Can we turn this into a single flags field?  Not necessarily here, but
> as a general cleanup?
> 
>> +
>>  	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
> 
> ...and maybe teach libxlog not to have this global variable?

And a pony. :) 

All good points, thanks.
-Eric
 
> --D
> 
>>  	if (!libxfs_init(&x)) {
>>  		fputs(_("\nfatal error -- couldn't initialize XFS library\n"),
>>
> 
