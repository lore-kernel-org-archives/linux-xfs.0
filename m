Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48D327F69
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 16:32:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3542D8F804C
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 14:32:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id szXwpFehOY2b4LiV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 14:32:27 -0800 (PST)
Message-ID: <54E66477.5060600@redhat.com>
Date: Thu, 19 Feb 2015 17:32:23 -0500
From: Don Dutile <ddutile@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] fs: xfs: Fix xfs_trans_read_buf event tracing
References: <7fb3278485ca5d8b48cd1ba980be6cc11dafc11b.1424352124.git.panand@redhat.com>
	<54E611BA.7010806@sandeen.net>
In-Reply-To: <54E611BA.7010806@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Pratyush Anand <panand@redhat.com>, david@fromorbit.com, xfs@oss.sgi.com
Cc: jbastian@redhat.com

On 02/19/2015 11:39 AM, Eric Sandeen wrote:
> On 2/19/15 7:24 AM, Pratyush Anand wrote:
>> My root file system is xfs. As soon as I enable event for
>> xfs_trans_read_buf `echo xfs:xfs_trans_read_buf >>
>> /sys/kernel/debug/tracing/set_event`, I see a kernel panic.
>>
>> A little bit of debugging shows that bp->b_fspriv is NULL many a time
>> when trace_xfs_trans_read_buf(bp->b_fspriv) is called.
>>
>> I do not have any idea about xfs filesystem. So, I am not sure, if it
>> is expected to have bp->b_fspriv = NULL at this location.
>>
>> This patch fixes the issue, until we have a better fix.
>
> What kernel did you hit this on?  What did the backtrace look like?
>
> I've been unable to reproduce the problem so far.
>
> Thanks,
> -Eric
>
RHELSA snap7 kernel (that's RHEL Server for ARM; 3.19-based).

Thanks for everyone's attention. Pratyush has provided a link
to the upstream patch, that we have to pull into our kernel.


>> Signed-off-by: Pratyush Anand <panand@redhat.com>
>> ---
>>   fs/xfs/xfs_trans_buf.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
>> index 0a4d4ab6d9a9..0b67a20643bf 100644
>> --- a/fs/xfs/xfs_trans_buf.c
>> +++ b/fs/xfs/xfs_trans_buf.c
>> @@ -329,7 +329,8 @@ xfs_trans_read_buf_map(
>>
>>   	if (tp)
>>   		_xfs_trans_bjoin(tp, bp, 1);
>> -	trace_xfs_trans_read_buf(bp->b_fspriv);
>> +	if (bp->b_fspriv)
>> +		trace_xfs_trans_read_buf(bp->b_fspriv);
>>   	*bpp = bp;
>>   	return 0;
>>
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
