Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbdLAWbF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 17:31:05 -0500
Subject: Re: [PATCH 1/4] xfs: add scrub to XFS_BUILD_OPTIONS
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
 <f5769e20-970a-53f5-4fc7-2afd11304ce2@sandeen.net>
 <20171201222922.GZ21412@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ad19d44f-87bc-0db7-f890-38de214d8acc@redhat.com>
Date: Fri, 1 Dec 2017 16:31:04 -0600
MIME-Version: 1.0
In-Reply-To: <20171201222922.GZ21412@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 12/1/17 4:29 PM, Darrick J. Wong wrote:
> On Fri, Dec 01, 2017 at 04:12:34PM -0600, Eric Sandeen wrote:
>> Advertise this config option along with the others.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
>> index fcc5dfc..8cee8e8 100644
>> --- a/fs/xfs/xfs_super.h
>> +++ b/fs/xfs/xfs_super.h
>> @@ -44,6 +44,12 @@
>>  # define XFS_REALTIME_STRING
>>  #endif
>>  
>> +#ifdef CONFIG_XFS_ONLINE_SCRUB
>> +# define XFS_SCRUB_STRING	"scrub, "
>> +#else
>> +# define XFS_SCRUB_STRING
>> +#endif
> 
> I don't mind this addition to the build options, though I had pictured
> scrub becoming an integral part of xfs some day and not remaining a
> configurable option.

It could be removed at that time, unless it's considered an API?

I'm not hung up on this, if there's no reason for it that's OK.

> That said I haven't evaluated how much scrub bloats up xfs nor do I know
> if the kernel tinyfication people would actually want to turn it off??
> 
> (For my part I prefer it some day not be Kconfig option so that it won't
> bitrot ala CONFIG_XFS_RT=y.)

I'd imagine that it'd be turned on more often than RT but that's just a guess.

-Eric
 
