Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 206077F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 21:53:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1E058F8033
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 19:53:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dzfcoey9zv4ISj94 for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 19:53:18 -0700 (PDT)
Message-ID: <53912D1F.6010609@sandeen.net>
Date: Thu, 05 Jun 2014 21:53:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_mdrestore: initialize sb prior to xfs_sb_from_disk()
References: <5390F89C.2050305@redhat.com>
	<20140605235633.GC4453@dastard>	<53910482.1030909@redhat.com>
	<20140606014256.GD4453@dastard>
In-Reply-To: <20140606014256.GD4453@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/5/14, 8:42 PM, Dave Chinner wrote:
> On Thu, Jun 05, 2014 at 07:00:02PM -0500, Eric Sandeen wrote:
>> On 6/5/14, 6:56 PM, Dave Chinner wrote:
>>> On Thu, Jun 05, 2014 at 06:09:16PM -0500, Eric Sandeen wrote:
>>
>> ...
>>
>>>> But ... should we maybe just do this once and for all in
>>>> xfs_sb_from_disk?  I'm not sure leaving it up to every
>>>> caller is a good idea, unless somebody ahs a reason to
>>>> pre-populate some fields - I can't imagine why that would
>>>> be, though...
>>>
>>> We don't ever read in the CRC field into the in-memory structures
>>> because it has no meaning in memory. Simiarly, we don't ever write
>>> the CRC field from the in-core structure because we always
>>> re-calculate it in the IO path if CRCs are configured. That is
>>> consistent behaviour across the entire code-base.
>>
>> <snip stuff>
>>
>>> Perhaps we should move the memset() to within xfs_sb_from_disk()
>>> to make this explicit?
>>
>> Yes, that's what I meant by "this" in "do this once and for all" - 
>> sorry, that wasn't clear.  memset(0) in xfs_sb_from_disk().
> 
> I didn't read it clearly. my fault.
> 
>> Yeah, the more I think about it, the more I think that's probably
>> the obviously correct thing to do.

Actually, a memset() seems like overkill - every field except
sb_crc is explicitly filled in in the function.

Maybe better to just set sb_crc to 0, with a comment as to why?
I think I'll whip that one up.

-Eric

> *nod*
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
