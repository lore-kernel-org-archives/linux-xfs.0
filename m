Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E6507F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 05:56:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFF7DAC003
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 03:56:27 -0700 (PDT)
Message-ID: <5182464F.5030708@oracle.com>
Date: Thu, 02 May 2013 18:56:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 v2] xfs: Don't keep silent if sunit/swidth can not
	be changed via mount
References: <518125CF.3050806@oracle.com> <20130502011302.GS10481@dastard>
	<51820D8E.7040308@oracle.com> <20130502072024.GX10481@dastard>
In-Reply-To: <20130502072024.GX10481@dastard>
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
Cc: Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/02/2013 03:20 PM, Dave Chinner wrote:
> On Thu, May 02, 2013 at 02:54:06PM +0800, Jeff Liu wrote:
>> On 05/02/2013 09:13 AM, Dave Chinner wrote:
>>> On Wed, May 01, 2013 at 10:25:19PM +0800, Jeff Liu wrote:
>>>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>>>> index 29e8de8..2836ef6 100644
>>>> --- a/fs/xfs/xfs_mount.c
>>>> +++ b/fs/xfs/xfs_mount.c
>>>> @@ -909,6 +909,10 @@ xfs_update_alignment(xfs_mount_t *mp)
>>>>  				sbp->sb_width = mp->m_swidth;
>>>>  				mp->m_update_flags |= XFS_SB_WIDTH;
>>>>  			}
>>>> +		} else {
>>>> +			xfs_warn(mp, "cannot change alignment: "
>>>> +				 "superblock does not support data alignment");
>>>
>>> Same comment again about single line format strings. Otherwise it's
>>> ok.
>> Ah, sorry! I misunderstood the comments of Mark before. I was bluffed
>> into believing that I should cut the length of log string as short as
>> possible. :(
> 
> Thing of being able cut-n-paste the error message out of the log and
> then being able to grep the source tree for it. i.e.
> 
> $ git grep "cannot change alignment: superblock does not support data alignment"
> 
> Will fail to find anything in the former case, but in the single
> line case it will identify the file the error lies in immediately.
> So the question I always ask myself is "is that format string easy
> to find with grep?" :)
I just checked your response because of my email box was broken this afternoon.

Thanks for the teaching, I'll bear it in mind. :)

Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
