Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DDE7E7F56
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:56:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9F4730407A
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:56:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gnzkz5PCO9mA2hd0 for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 10:56:00 -0700 (PDT)
Message-ID: <5245C6AF.6080502@sandeen.net>
Date: Fri, 27 Sep 2013 12:55:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dir2_node_removename
References: <20130927130140.640252809@sgi.com> <5245B5E5.7000206@sandeen.net>
	<5245C4FA.7010208@sgi.com>
In-Reply-To: <5245C4FA.7010208@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 9/27/13 12:48 PM, Mark Tinguely wrote:
> On 09/27/13 11:44, Eric Sandeen wrote:
>> On 9/27/13 8:01 AM, Mark Tinguely wrote:
>>> Free the memory pointed to by state before returning on error from
>>> xfs_dir2_node_removename.c
>>>
>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>> ---
>>> Found by Coverity (134681) in userspace, same patch applies there
>>> also.
>>
>> Heh, looks like that one has been around since the dawn of time, thanks.
>>
>> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>>
>> how do we handle the matching userspace fixes, separate patch to
>> be explicit?  Wait for the next syncup?
>>
>> Thanks,
>> -Eric
> 
> <patch delete>
> 
> Good question.
> 
> The user space should be kept up to date with the kernel.
> 
> Since the patches will be identical except the directory name, I was hoping to submit one copy. But I am not trying to invent a policy, just being lazy.
> 
> --Mark.
> 

Was just an offhanded question; it'd just be good to know what we all expect.

I suppose that it could depend on the severity of the flaw; a minor leak before exit()
isn't a big deal and could wait for a global sync-up; a data corruption fix might
need to be quickly merged to both trees.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
