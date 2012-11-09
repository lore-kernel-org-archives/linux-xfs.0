Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9ET6WY116297 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 08:29:06 -0600
Message-ID: <509D139F.1050607@sgi.com>
Date: Fri, 09 Nov 2012 08:30:55 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: get return value in seek_sanity_test
References: <1350825309-30733-1-git-send-email-wenqing.lz@taobao.com>
	<20121109032551.GA28325@gmail.com>
In-Reply-To: <20121109032551.GA28325@gmail.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Jeff Liu <jeff.liu@oracle.com>, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 11/08/12 21:25, Zheng Liu wrote:
> On Sun, Oct 21, 2012 at 09:15:09PM +0800, wenqing.lz wrote:
>
> ping?
>
> Regards,
> Zheng
>
>> From: Zheng Liu<wenqing.lz@taobao.com>
>>
>> In seek_sanity_test getting return value is missing.  Thus we couldn't get the
>> result unless someone read the log file (e.g. # 285).
>>
>> CC: Jeff Liu<jeff.liu@oracle.com>
>> Signed-off-by: Zheng Liu<wenqing.lz@taobao.com>
>> ---
>> v2<- v1:
>> 	* put return value check below the run_test()
>>
>> Hi Jeff,
>>
>> Could you please review this patch again?  Thanks.
>>
>> Regards,
>> Zheng
>>
>>   src/seek_sanity_test.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
>> index 34f5508..3897f02 100644
>> --- a/src/seek_sanity_test.c
>> +++ b/src/seek_sanity_test.c
>> @@ -674,9 +674,9 @@ int main(int argc, char **argv)
>>   		goto out;
>>
>>   	for (i = 0; i<  numtests; ++i) {
>> +		ret = run_test(&seek_tests[i]);
>>   		if (ret)
>> -			goto out;
>> -		run_test(&seek_tests[i]);
>> +			break;
>>   	}
>>
>>   out:
>> --
>> 1.7.12.rc2.18.g61b472e
>>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Hi Jeff and Zheng,

Jeff, can I assume by your email:

   http://oss.sgi.com/archives/xfs/2012-10/msg00412.html

that you are giving your Reviewed-by:?

It also looks good to me too:

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

I will make sure it gets committed.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
