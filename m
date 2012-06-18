Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5IGmehp209495 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 11:48:40 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dJFjMFN2KFaq9L0b for
	<xfs@oss.sgi.com>; Mon, 18 Jun 2012 09:48:39 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5IGmdK4001342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 12:48:39 -0400
Message-ID: <4FDF5BE5.3000507@redhat.com>
Date: Mon, 18 Jun 2012 11:48:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: filter out latest xfsdump version messages
References: <1340034963-24932-1-git-send-email-bfoster@redhat.com>
	<4FDF54BB.1060902@redhat.com> <4FDF583A.2040403@redhat.com>
In-Reply-To: <4FDF583A.2040403@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 6/18/12 11:32 AM, Brian Foster wrote:
> On 06/18/2012 12:18 PM, Eric Sandeen wrote:
>> On 6/18/12 10:56 AM, Brian Foster wrote:
>>> The latest version of xfsdump/restore (3.1.0) causes dump tests
>>> to complain. Fix up the filter to include a wider selection of
>>> version numbers.
>>
>> Looks good to me, thanks - I'll merge it, but I think I'll
>> add a "^version" to it to make it a little more selective,
>> if that's ok with you.
>>
> 
> Fine by me, thanks.

actually that's wrong, because it puts executable name at the beginning!
Sorry.  I'll merge it as is, thanks.

-Eric

> Brian
> 
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>> ---
>>>  common.dump |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/common.dump b/common.dump
>>> index ca09ec1..61d3f43 100644
>>> --- a/common.dump
>>> +++ b/common.dump
>>> @@ -863,7 +863,7 @@ _dump_filter_main()
>>>        -e 's/1048576/BLOCKSZ/'				\
>>>        -e 's/2097152/BLOCKSZ/'				\
>>>        -e 's/(pid[	 ]*[1-9][0-9]*)/\(pid PID\)/'	\
>>> -      -e '/version 3\.0/d'				\
>>> +      -e '/version [3-9]\.[0-9]/d'				\
>>>        -e 's/\/hw\/module.*$/SCRATCH_DEV/'		\
>>>        -e 's/xfsdump: ino map phase 1: .*/xfsdump: ino map <PHASES>/' \
>>>        -e '/xfsdump: ino map phase [2]/,1d'		\
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
