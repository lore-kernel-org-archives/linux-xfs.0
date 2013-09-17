Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BAAE7F55
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 15:03:06 -0500 (CDT)
Message-ID: <5238B576.7080608@sgi.com>
Date: Tue, 17 Sep 2013 15:03:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: v2 xfs directory unbalance assert test
References: <20130917192538.230164044@sgi.com> <5238AF75.2020905@sandeen.net>
In-Reply-To: <5238AF75.2020905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 09/17/13 14:37, Eric Sandeen wrote:
> On 9/17/13 2:25 PM, Mark Tinguely wrote:
>> This tests triggers an assert in the XFS directory unbalance code.
>> This test originally written by Brian Foster and suggestions
>> from Micheal Semon.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>> v1->v2:
>>   remove clean up.
>>   remove $seqres.full before test.
>>   remove scratch mount.
>>   11g ->  calculate 11g bytes.
>>   check for failing mkfs and mount.
>>   add a safer removal of the scratch files.
>>
>>   put into auto group and "long" group so people can opt out:
>>    this test almost an hour on my test box.
>
> Is there any way to do a more targeted test than 1hr of fsstress?  :(

No, I pruned the test down from a 5 hr test to 1 hr test.

>
> (TBH I didn't follow the bug, so not sure what it takes to repro)
>
> Otherwise seems fine.
>
> Reviewed-by: Eric Sandeen<sandeen@redhat.com>

Thanks.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
