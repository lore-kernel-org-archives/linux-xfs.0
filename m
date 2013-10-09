Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3386C7F6B
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:50:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCCD0AC005
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:50:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MNCUtCl0hYGWrlzT for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:50:48 -0700 (PDT)
Message-ID: <5255C1A7.80703@sandeen.net>
Date: Wed, 09 Oct 2013 15:50:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 04/32] xfs: check magic numbers in dir3 leaf verifier first
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-5-git-send-email-david@fromorbit.com>
	<52548F4F.5000800@sandeen.net> <20131009204527.GJ4446@dastard>
In-Reply-To: <20131009204527.GJ4446@dastard>
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
Cc: xfs@oss.sgi.com

On 10/9/13 3:45 PM, Dave Chinner wrote:
> On Tue, Oct 08, 2013 at 06:03:43PM -0500, Eric Sandeen wrote:
>> On 9/29/13 10:15 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Calling xfs_dir3_leaf_hdr_from_disk() in a verifier before
>>> validating the magic numbers in the buffer results in ASSERT
>>> failures due to mismatching magic numbers when a corruption occurs.
>>> Seeing as the verifier is supposed to catch the corruption and pass
>>> it back to the caller, having the verifier assert fail on error
>>> defeats the purpose of detecting the errors in the first place.
>>>
>>> Check the magic numbers direct from the buffer before decoding the
>>> header.
>>
>> Looks good; have you sent this for the kernel yet?
>>
>> (I thought we wanted changes to hit kernelspace first) :)
> 
> Yes, commit 0f295a214bb7658ca37bd61a8a1f0cd4a9d86c1f.

Sorry I missed that, man, I swear I looked.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
