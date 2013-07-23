Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D49F7F5D
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 20:00:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0F72AC004
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 18:00:46 -0700 (PDT)
Received: from mail-vb0-f46.google.com (mail-vb0-f46.google.com
	[209.85.212.46]) by cuda.sgi.com with ESMTP id hKUXG0OXSRVeRRga
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Jul 2013 18:00:42 -0700 (PDT)
Received: by mail-vb0-f46.google.com with SMTP id w8so139066vbf.33
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 18:00:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130722234352.GE19986@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<51EB7E6B.8080607@gmail.com> <20130722234352.GE19986@dastard>
Date: Mon, 22 Jul 2013 21:00:41 -0400
Message-ID: <CAJzLF9n=GeCpCiLkKc9jg4xf79TwYU+sPDa7xBhXfphCWmAa4w@mail.gmail.com>
Subject: Re: [PATCH 00/49] current patch queue for 3.12
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jul 22, 2013 at 7:43 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Jul 21, 2013 at 02:23:39AM -0400, Michael L. Semon wrote:
>> On 07/19/2013 02:24 AM, Dave Chinner wrote:
>> > Hi folks,
>> >
>> > The following mass of patches is my current patch queue I have
>> > pending for the 3.12 cycle.
>>
>> OK, it seems to be going okay:  The PC is still functioning, even on
>> a CRC-enabled / partition.  The `git am` session had these anomalies:
>>
>> # Patch #5
>> Applying: xfs: separate dquot on disk format definitions out of xfs_quota.h
>> /usr/src/kernel-git/linux/.git/rebase-apply/patch:138: trailing whitespace.
>>  * This header file defines all the on-disk format definitions for
>> warning: 1 line adds whitespace errors.
>>
>> # Patch #15
>> Applying: xfs: move getdents code into it's own file
>> /usr/src/kernel-git/linux/.git/rebase-apply/patch:1266: new blank line at EOF.
>> +
>> warning: 1 line adds whitespace errors.
>>
>> ########
>> There were build errors as well with gcc-4.8.1:
>>
>>   CC      fs/xfs/xfs_inode_fork.o
>> fs/xfs/xfs_inode_fork.c:43:23: fatal error: xfs_utils.h: No such file or directory
>>  #include "xfs_utils.h"
>>                        ^
>> compilation terminated.
>> make[2]: *** [fs/xfs/xfs_inode_fork.o] Error 1
>> make[1]: *** [fs/xfs] Error 2
>> make: *** [fs] Error 2
>> # next try...
>>   CC      fs/xfs/xfs_inode_fork.o
>> fs/xfs/xfs_inode_fork.c:49:26: fatal error: xfs_vnodeops.h: No such file or directory
>>  #include "xfs_vnodeops.h"
>
> Ah, I thought I caught all of them. I use a rsync'd build tree, and
> I don't use --delete because that removes all the object files.
> Hence sometimes I end up with "stale files" that have been removed
> from the source tree but don't get removed from the build tree and
> so the build doesn't fail.
>
> (I thought I added a "git clean -f -d" to my build script, but on
> review, that only went into the userspace builds....)

This was a breeze, anyway.  Good work!

>> --- a/fs/xfs/xfs_log_rlimit.c
>> +++ b/fs/xfs/xfs_log_rlimit.c
>> @@ -137,7 +137,8 @@ xfs_log_calc_minimum_size(
>>        * it up to lsunit boundary if lsunit is specified.
>>        */
>>       if (lsunit)
>> -             min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
>> +             min_logblks = roundup((int)BTOBB(max_logres), lsunit)
>> +                     + 2 * lsunit;
>
> Why did you need that one change?

This fixes a build error with gcc-4.8.1 to do with the roundup()
function and calling something like __divdi3.  The code compiles
without the cast, but without the cast, one of the final kernel link
stages fails.  include/linux/kernel.h from the kernel source mentioned
something about it for gcc-3.3 needing a workaround.  I came up with a
(const int) cast to kludge xfs_log_rlimit.c.  [Without the kernel
comments, I wouldn't have found the answer on my own.]  Jeff reduced
it to just (int), and it works, but I never got his final answer on
whether it was the best solution.

Should somebody else come across the same issue with
gcc-4.8.1--especially on something other than 32-bit x86--I'll push
this idea with more confidence.

Sorry for the omitted explanation!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
