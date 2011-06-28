Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S5QtLt182476 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:26:56 -0500
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48B153433C
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:26:54 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id fJ4HoB85fVPlMnOv for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:26:54 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5S5KfFl026205
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:20:41 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5S5Qg6d135836 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:26:42 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5RNQfCp008133
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 17:26:41 -0600
Message-ID: <4E09660B.7050706@linux.vnet.ibm.com>
Date: Mon, 27 Jun 2011 22:26:35 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 v2] XFS TESTS: Fix 252 Failure: Update 252 Golden
	Output
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309235247-32650-3-git-send-email-achender@linux.vnet.ibm.com>
	<20110628050900.GL32466@dastard>
In-Reply-To: <20110628050900.GL32466@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com

On 06/27/2011 10:09 PM, Dave Chinner wrote:
> On Mon, Jun 27, 2011 at 09:27:26PM -0700, Allison Henderson wrote:
>> New filtered golden output for test 252
>>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>> ---
>> :100644 100644 930c924... fcfd121... M	252.out
>>   252.out |  272 +++++++++++++++++++++++++++++++++++++++------------------------
>>   1 files changed, 170 insertions(+), 102 deletions(-)
>>
>> diff --git a/252.out b/252.out
>> index 930c924..fcfd121 100644
>> --- a/252.out
>> +++ b/252.out
>> @@ -1,239 +1,307 @@
>>   QA output created by 252
>>   	1. into a hole
>> +daa100df6e6711906b61c9ab5aa16032
>>   	2. into allocated space
>> -0: [0..7]: data
>> +0: [0..7]: extent
>>   1: [8..23]: hole
>> -2: [24..39]: data
>> +2: [24..39]: extent
>> +cc58a7417c2d7763adc45b6fcd3fa024
>
> I don't really like the way this weakens the test for XFS. With this
> change, the test no longer is checking that unwritten extent
> behaviour is correct.
>
> Rather than weakening the test, perhaps it would be better to
> execute 252 for XFS only (with the md5sums added), and then
> duplicate it to a new test for all filesystems to run with the
> weaker result checking that using the new filter function gives us.
> With the amount of common code the two tests share, it should be
> trivial to do this....
>

Alrighty, that sounds pretty straight forward, as long as every one is 
in agreement.  I think that would help retain the tests effectiveness. 
Eric, Josef, what are your thoughts?

Allison Henderson

> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
