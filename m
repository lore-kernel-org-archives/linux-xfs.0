Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA4D37F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 07:59:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 99CDB8F8040
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 05:59:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YrOdz2VTrePY6BlR for <xfs@oss.sgi.com>;
	Fri, 22 Jan 2016 05:58:57 -0800 (PST)
Subject: Re: [PATCH 3/7] quota: add new quotactl Q_GETNEXTQUOTA
References: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
	<1453435644-32261-4-git-send-email-sandeen@redhat.com>
	<20160122092822.GC16898@quack.suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A235A0.7060100@sandeen.net>
Date: Fri, 22 Jan 2016 07:58:56 -0600
MIME-Version: 1.0
In-Reply-To: <20160122092822.GC16898@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com


On 1/22/16 3:28 AM, Jan Kara wrote:
> On Thu 21-01-16 22:07:20, Eric Sandeen wrote:

...

> Same comments as for XFS version apply here. 

*nod*

> Furthermore:
> 
>> diff --git a/fs/quota/compat.c b/fs/quota/compat.c
>> index fb1892f..80773a4 100644
>> --- a/fs/quota/compat.c
>> +++ b/fs/quota/compat.c
>> @@ -19,6 +19,19 @@ struct compat_if_dqblk {
>>  	compat_uint_t dqb_valid;
>>  };
>>  
>> +struct compat_if_nextdqblk {
>> +	compat_u64 dqb_bhardlimit;
>> +	compat_u64 dqb_bsoftlimit;
>> +	compat_u64 dqb_curspace;
>> +	compat_u64 dqb_ihardlimit;
>> +	compat_u64 dqb_isoftlimit;
>> +	compat_u64 dqb_curinodes;
>> +	compat_u64 dqb_btime;
>> +	compat_u64 dqb_itime;
>> +	compat_uint_t dqb_valid;
>> +	compat_uint_t dqb_id;
>> +};
>> +
> 
> Is there a need for compat version of this structure? Everything is
> naturally aligned and the size is a multiple of 8 bytes. But these things
> keep surprising me... Added CC to linux-api in a hope that there's someone
> who definitely knows.

Ok, yeah, I wasn't sure.  I'll take all the compat stuff out of this one,
and can do a separate patch if needed, but I bet you're right, it's probably
not.  I did set up to test 32-compat calls, so I'll just test w/o this.

I'd be perfectly happy to drop it.  :)

Thanks for the review, Jan.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
