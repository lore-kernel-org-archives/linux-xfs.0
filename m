Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OKfArX053930 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 15:41:10 -0500
Message-ID: <50885329.40408@sgi.com>
Date: Wed, 24 Oct 2012 15:44:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] 286: Test FITRIM where length is smaller than FSB
References: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
	<20121016201645.GJ2739@dastard> <50885216.1020201@sgi.com>
In-Reply-To: <50885216.1020201@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On 10/24/2012 03:39 PM, Rich Johnston wrote:
> Lukas,
>
> On 10/16/2012 03:16 PM, Dave Chinner wrote:
>> On Tue, Oct 16, 2012 at 11:41:33AM +0200, Lukas Czerner wrote:
>>> This tests corner case in FITRIM implementation where range size is
>>> smaller than file system block or zero. In this case FITRIM should fail
>>> with EINVAL.
>>>
>>> The problem was spotted in xfs and ext4 where in case of length = 0 the
>>> 'end' variable underflowed. In case of length smaller than 1 FSB FITRIM
>>> finished successfully, but we really should rather return EINVAL in both
>>> cases.
>>>
>>> (This patch has to be applied after 'Use upstream version of fstrim
>>> instead of the local one')
>>>
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>> ---
>>>   286     |   58
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   286.out |    6 ++++++
>>
>> We've already got 286 (and 287), so this should probably be 288...
>>
>> Otherwise, it looks good.
>>
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>>
>
> This has been committed to git://oss.sgi.com/xfs/xfs.git, master and
> for-next branches.
>
> Regards
> --Rich
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

My apologies, this has been committed to 
git://oss.sgi.com/xfs/cmds/xfstests, master and for-next branches.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
