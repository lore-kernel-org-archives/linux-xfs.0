Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDC8C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E022396E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgIXRjI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:39:08 -0400
Received: from sandeen.net ([63.231.237.45]:56138 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgIXRjI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Sep 2020 13:39:08 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7A3B9EF1;
        Thu, 24 Sep 2020 12:38:31 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-2-preichl@redhat.com> <20200924172600.GG7955@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs: remove deprecated mount options
Message-ID: <be017461-6ce9-1d64-51d6-7e85a3e45055@sandeen.net>
Date:   Thu, 24 Sep 2020 12:39:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200924172600.GG7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/24/20 12:26 PM, Darrick J. Wong wrote:
> On Thu, Sep 24, 2020 at 07:07:46PM +0200, Pavel Reichl wrote:
>> ikeep/noikeep was a workaround for old DMAPI code which is no longer
>> relevant.
>>
>> attr2/noattr2 - is for controlling upgrade behaviour from fixed attribute
>> fork sizes in the inode (attr1) and dynamic attribute fork sizes (attr2).
>> mkfs has defaulted to setting attr2 since 2007, hence just about every
>> XFS filesystem out there in production right now uses attr2.
>>
>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> ---
>>  Documentation/admin-guide/xfs.rst |  2 ++
>>  fs/xfs/xfs_super.c                | 30 +++++++++++++++++-------------
>>  2 files changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
>> index f461d6c33534..413f68efccc0 100644
>> --- a/Documentation/admin-guide/xfs.rst
>> +++ b/Documentation/admin-guide/xfs.rst
>> @@ -217,6 +217,8 @@ Deprecated Mount Options
>>  ===========================     ================
>>    Name				Removal Schedule
>>  ===========================     ================
>> +  ikeep/noikeep			TBD
>> +  attr2/noattr2			TBD
> 
> Er... what date did you have in mind?
> 
>>  ===========================     ================
>>  
>>  
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 71ac6c1cdc36..4c26b283b7d8 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1234,25 +1234,12 @@ xfs_fc_parse_param(
>>  	case Opt_nouuid:
>>  		mp->m_flags |= XFS_MOUNT_NOUUID;
>>  		return 0;
>> -	case Opt_ikeep:
>> -		mp->m_flags |= XFS_MOUNT_IKEEP;
>> -		return 0;
>> -	case Opt_noikeep:
>> -		mp->m_flags &= ~XFS_MOUNT_IKEEP;
>> -		return 0;
>>  	case Opt_largeio:
>>  		mp->m_flags |= XFS_MOUNT_LARGEIO;
>>  		return 0;
>>  	case Opt_nolargeio:
>>  		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
>>  		return 0;
>> -	case Opt_attr2:
>> -		mp->m_flags |= XFS_MOUNT_ATTR2;
>> -		return 0;
>> -	case Opt_noattr2:
>> -		mp->m_flags &= ~XFS_MOUNT_ATTR2;
>> -		mp->m_flags |= XFS_MOUNT_NOATTR2;
>> -		return 0;
>>  	case Opt_filestreams:
>>  		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
>>  		return 0;
>> @@ -1304,6 +1291,23 @@ xfs_fc_parse_param(
>>  		xfs_mount_set_dax_mode(mp, result.uint_32);
>>  		return 0;
>>  #endif
>> +	case Opt_ikeep:
>> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		mp->m_flags |= XFS_MOUNT_IKEEP;
> 
> It's a little odd that you didn't then remove these XFS_MOUNT_ flags.
> It's strange to declare a mount option deprecated but still have it
> change behavior.

but ... this doesn't change behavior, right?  The flag is still set.

I think it makes sense to announce deprecation, with a date set for future
removal, but keep all other behavior the same.  That gives people who still
need it (if any exist) time to complain, right?

> In this case, I guess we should keep ikeep/noikeep in the mount options
> table so that scripts won't fail, but then we remove XFS_MOUNT_IKEEP and
> change the codebase to always take the IKEEP behavior and delete the
> code that handled the !IKEEP behavior.
> 
>> +		return 0;
>> +	case Opt_noikeep:
>> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
>> +		return 0;
>> +	case Opt_attr2:
>> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> 
> If the kernel /does/ encounter an attr1 filesystem, what will it do now?

The same as it did yesterday; the flag is still set for now.

> IIRC the default (if there is no attr2/noattr2 mount option) is to
> auto-upgrade the fs, right?  So will we stop doing that, or are we
> making the upgrade mandatory now?
> 
>> +		return 0;
>> +	case Opt_noattr2:
>> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
>> +		mp->m_flags |= XFS_MOUNT_NOATTR2;
> 
> Also, uh, why move these code hunks?

That's my fault, I had suggested moving all the deprecated options to the end.

Maybe with a comment, /* REMOVE ME 2089 */ or whatever we pick?

-Eric
