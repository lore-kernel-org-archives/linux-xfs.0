Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6JEdvjx020653 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 09:39:57 -0500
Message-ID: <50081C31.5090507@oracle.com>
Date: Thu, 19 Jul 2012 22:39:45 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs: probe data buffer from page cache for unwritten
	extents
References: <4FF29C2C.2000407@oracle.com> <4FFB099C.6020809@sgi.com>
In-Reply-To: <4FFB099C.6020809@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 07/10/2012 12:41 AM, Mark Tinguely wrote:
> On 07/03/12 02:15, Jeff Liu wrote:
>> Hello,
>>
>> This is v3 of the patch.
>>
>> We can trigger BUG() in xfs_seek_data() if met two unwritten without 
>> data or hole extents at last version.
>> So making the extents map reading in loop could solve it.
>>
>> Sorry, Am not yet try the repeated holes scenario according to Dave's 
>> comments as lack of X64 test env, still
>> waiting for it ready.  But this patch is already too long delayed, I 
>> have worked it out one weeks ago.
>> So I'd like to post it because of it could handle repeated 
>> hole/unwritten extents well in a loop, and I also improved
>> xfstests:286 with those cases for the verification, will post it soon.
>>
>> v2->v3:
>> Tested by Mark, hit BUG() for continuous unwritten extents without 
>> data wrote.
>> * xfs_seek_data(), remove BUG() and having extents map search in loop.
>>
>> v1->v2:
>> suggested by Mark.
>> * xfs_has_unwritten_buffer(), use the input offset instead of 
>> bmap->br_startoff to
>>   calculate page index for data buffer probing.
>>
>> Thanks,
>> -Jeff
>>
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>
>> ---
>
> Nice. Up to refining xfs_seek_hole()?
Thanks for the review.
Sorry for my late response, I missed you this email.
Sure, the refinement will be reflected in next post. :)

Thanks,
-Jeff
>
>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
