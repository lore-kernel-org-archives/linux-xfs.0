Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F6617F4E
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 16:35:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C6BC8F8078
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 14:35:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id g44drDRtpfK9TzUI for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 14:35:47 -0700 (PDT)
Message-ID: <5238CB32.2090404@sandeen.net>
Date: Tue, 17 Sep 2013 16:35:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: v2 xfs directory unbalance assert test
References: <20130917192538.230164044@sgi.com> <20130917213409.GL19103@dastard>
In-Reply-To: <20130917213409.GL19103@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 9/17/13 4:34 PM, Dave Chinner wrote:
> On Tue, Sep 17, 2013 at 02:25:23PM -0500, Mark Tinguely wrote:
>> This tests triggers an assert in the XFS directory unbalance code.
>> This test originally written by Brian Foster and suggestions
>> from Micheal Semon.
>>
>> Signed-off-by: Mark Tinguely <tinguely@sgi.com> 
>> ---
>> v1->v2:
>>  remove clean up.
>>  remove $seqres.full before test.
>>  remove scratch mount.
>>  11g -> calculate 11g bytes.
>>  check for failing mkfs and mount.
>>  add a safer removal of the scratch files.
>>
>>  put into auto group and "long" group so people can opt out:
>>   this test almost an hour on my test box.
> 
> 45m is too long for the auto group. The entire auto group runs in
> 50-55 minutes on my test VMs, so doubling that for one test is not
> really a good idea.

Ok, sorry, my fault.  Fix on commit?

-Eric

> The usual rule of thumb for the auto group is that the test should
> take less than 5 minutes to run. For the quick group, it should take
> less than 30-60s to run.
> 
> If you want to make this test run in the auto group, scale it for
> stress tests via the use of LOAD_FACTOR and TIME_FACTOR, and add it
> to the stress group.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
