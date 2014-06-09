Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20E417F60
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 15:58:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EFCA88F8059
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 13:58:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OotaFIFCe0j0baFT for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 13:58:16 -0700 (PDT)
Message-ID: <53961FE7.3050607@sandeen.net>
Date: Mon, 09 Jun 2014 15:58:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_mdrestore: initialize sb prior to xfs_sb_from_disk()
References: <5390F89C.2050305@redhat.com>	<20140605235633.GC4453@dastard>	<53910482.1030909@redhat.com>	<20140606014256.GD4453@dastard>
	<53912D1F.6010609@sandeen.net>
In-Reply-To: <53912D1F.6010609@sandeen.net>
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

On 6/5/14, 9:53 PM, Eric Sandeen wrote:
> On 6/5/14, 8:42 PM, Dave Chinner wrote:
>> On Thu, Jun 05, 2014 at 07:00:02PM -0500, Eric Sandeen wrote:
>>> On 6/5/14, 6:56 PM, Dave Chinner wrote:
>>>> On Thu, Jun 05, 2014 at 06:09:16PM -0500, Eric Sandeen wrote:
>>>
>>> ...
>>>
>>>>> But ... should we maybe just do this once and for all in
>>>>> xfs_sb_from_disk?  I'm not sure leaving it up to every
>>>>> caller is a good idea, unless somebody ahs a reason to
>>>>> pre-populate some fields - I can't imagine why that would
>>>>> be, though...
>>>>
>>>> We don't ever read in the CRC field into the in-memory structures
>>>> because it has no meaning in memory. Simiarly, we don't ever write
>>>> the CRC field from the in-core structure because we always
>>>> re-calculate it in the IO path if CRCs are configured. That is
>>>> consistent behaviour across the entire code-base.

But as you say in userspace, this
 
	libxfs_sb_to_disk(buf, sbp, XFS_SB_ALL_BITS)

*does* write it.

kernelspace does the same here:

0 xfs_fsops.c xfs_growfs_data_private 520 xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);

>>> <snip stuff>
>>>
>>>> Perhaps we should move the memset() to within xfs_sb_from_disk()
>>>> to make this explicit?
>>>
>>> Yes, that's what I meant by "this" in "do this once and for all" - 
>>> sorry, that wasn't clear.  memset(0) in xfs_sb_from_disk().
>>
>> I didn't read it clearly. my fault.
>>
>>> Yeah, the more I think about it, the more I think that's probably
>>> the obviously correct thing to do.
> 
> Actually, a memset() seems like overkill - every field except
> sb_crc is explicitly filled in in the function.
> 
> Maybe better to just set sb_crc to 0, with a comment as to why?
> I think I'll whip that one up.

But now I realize we do sometimes write the in-memory value to
disk, as seen above.

Backing up - shouldn't we just go ahead and read/write it from/to
disk just like every other field, at least in the cases where we
are writing all, and when we are reading (which always reads all)?

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
