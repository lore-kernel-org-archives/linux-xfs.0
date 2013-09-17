Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A94A7F50
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 17:14:23 -0500 (CDT)
Message-ID: <5238D43B.5010808@sgi.com>
Date: Tue, 17 Sep 2013 17:14:19 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: v2 xfs directory unbalance assert test
References: <20130917192538.230164044@sgi.com>
	<20130917213409.GL19103@dastard> <5238CB32.2090404@sandeen.net>
In-Reply-To: <5238CB32.2090404@sandeen.net>
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

On 09/17/13 16:35, Eric Sandeen wrote:
> On 9/17/13 4:34 PM, Dave Chinner wrote:
>> On Tue, Sep 17, 2013 at 02:25:23PM -0500, Mark Tinguely wrote:
>>> This tests triggers an assert in the XFS directory unbalance code.
>>> This test originally written by Brian Foster and suggestions
>>> from Micheal Semon.
>>>
>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>> ---
>>> v1->v2:
>>>   remove clean up.
>>>   remove $seqres.full before test.
>>>   remove scratch mount.
>>>   11g ->  calculate 11g bytes.
>>>   check for failing mkfs and mount.
>>>   add a safer removal of the scratch files.
>>>
>>>   put into auto group and "long" group so people can opt out:
>>>    this test almost an hour on my test box.
>>
>> 45m is too long for the auto group. The entire auto group runs in
>> 50-55 minutes on my test VMs, so doubling that for one test is not
>> really a good idea.
>
> Ok, sorry, my fault.  Fix on commit?
>
> -Eric

We can't remove much more and still hit the assert, so I am happy to 
remove it from the auto group.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
