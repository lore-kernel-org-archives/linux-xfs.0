Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BEEC37CBF
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 00:07:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16F7DAC001
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 22:07:42 -0700 (PDT)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
	[209.85.220.49]) by cuda.sgi.com with ESMTP id a4jSG79HVABD88o7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 31 Jul 2013 22:07:40 -0700 (PDT)
Received: by mail-pa0-f49.google.com with SMTP id bi5so1686044pad.8
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 22:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130801002241.GH7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
	<20130801002241.GH7118@dastard>
Date: Thu, 1 Aug 2013 14:07:39 +0900
Message-ID: <CAKYAXd_VvGQL6KW3+FmfPogxzkXq7yF-4WPM9iebXcTn7tiN9A@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
From: Namjae Jeon <linkinjeon@gmail.com>
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
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

2013/8/1, Dave Chinner <david@fromorbit.com>:
> On Wed, Jul 31, 2013 at 11:42:00PM +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Fallocate now supports new FALLOC_FL_COLLAPSE_RANGE flag.
>> The semantics of this flag are following:
>> 1) It collapses the range lying between offset and length by removing any
>> data
>>    blocks which are present in this range and than updates all the
>> logical
>>    offsets of extents beyond "offset + len" to nullify the hole created
>> by
>>    removing blocks. In short, it does not leave a hole.
>> 1) It should be used exclusively. No other fallocate flag in combination.
>> 2) Offset and length supplied to fallocate should be fs block size
>> aligned.
>
Hi Dave.

> Given that the rest of fallocate() interfaces are byte based, this
> is going to cause some confusion if it's not well documented. i.e.
> this restriction needs to be documented in the header file that is
> exposed to userspace, as well as in the fallocate(2) man page.
Agree.

>
>> 3) It wokrs beyond "EOF", so the extents which are pre-allocated beyond
>> "EOF"
>>    are also updated.
>
> I don't think that's valid for this operation. If the range is
> beyond EOF, you are not modifying anything visible to userspace, and
> that makes it the same as a hole punch operation. So, I'd get rid of
> thisnasty implementation complexity altogether.
The basic idea behind collapse range is that it does'nt leaves a hole.
And this is achieved by updating starting block of each of the extents
which lies beyond hole.
When we are updating an extent, we are actually moving hole to the
right, towards the last allocated block in the file space.
We continue doing this for each extent and finally when this operation
completes, the hole is gone.
If the file has preallocated extent(s) beyond EOF, something like this=>
hole, extent1, extent2, extent_beyond_EOF1.
And we start updating extents one by one, to nullify the effect of hole=>
STEP1: After updating extent1: extent1, hole, extent2, extent_beyond_EOF1.
STEP2: After updating extent2: extent1, extent2, hole, extent_beyond_EOF1.
STEP3: After updating extent_beyond_EOF1: extent1, extent2,
extent_beyond_EOF1, hole => And this removes hole from the file.
If we stop updating just after extent2, this will not remove hole from
the file space but instead, it will place the hole between EOF and 1st
preallcoated extent beyond EOF as in STEP2.
So, if user does an extending truncate, hole will became visible as it
is still there.

>
>> 4) It reduces the i_size of inode by the amount of collapse range which
>> lies
>>    within i_size. So, if offset >= i_size, i_size won't be changed at
>> all.
>
> Similarly, I don't think that asking for a range that overlaps EOF
> is valid, either. The moment you overlap or go beyond EOF, you are
> effectively truncating the file as there is no data to collapse into
> the range
Yes, we could put a restriction on that, something like: if (len +
offset > i_size) { return -EINVAL;}

>
> As it is, I don't see these EOF rules enforced by this patch, nor
> are they documented at all in the patch.
The EOF file rules are handled in the fs specific patches. As in XFS =>
+       if (mode & FALLOC_FL_COLLAPSE_RANGE) {
+               error = -xfs_collapse_file_space(ip, offset + len, len);
+               if (error || offset >= i_size_read(inode))
+                       goto out_unlock;
+
+               /* Shrink size in case of FALLOC_FL_COLLAPSE_RANGE */
+               if ((offset + len) > i_size_read(inode))
+                       new_size = offset;
+               else
+                       new_size = i_size_read(inode) - len;
+               error = -xfs_update_file_size(ip, new_size);
But it seems ok to not allow (offset + len) > i_size.

>
> Regardless of what semantics we decide on, this needs xfs_io
> support and extensive corner case tests added to xfstests so that we
> can confirm the implementation in every filesystem is correct and we
> don't introduce regressions in future. it also needs documentation
> in the fallocate(2) man page.
Yes, we are currently working on it.
With next version of collapse_range patches, we will also send xfs_io
and xfstests patches and manpage also.

>
>> diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
>> index 990c4cc..7567c8c 100644
>> --- a/include/uapi/linux/falloc.h
>> +++ b/include/uapi/linux/falloc.h
>> @@ -1,9 +1,10 @@
>>  #ifndef _UAPI_FALLOC_H_
>>  #define _UAPI_FALLOC_H_
>>
>> -#define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
>> -#define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
>> +#define FALLOC_FL_KEEP_SIZE		0x01 /* default is extend size */
>> +#define FALLOC_FL_PUNCH_HOLE		0x02 /* de-allocates range */
>>  #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
>> +#define FALLOC_FL_COLLAPSE_RANGE	0x08 /* it does not leave a hole */
>
> I'd suggest that you need to explain what FALLOC_FL_COLLAPSE_RANGE
> does in great detail right here.
Okay!

Thanks for review!
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
