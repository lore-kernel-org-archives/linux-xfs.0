Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB9557F69
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 16:08:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFD3F8F8033
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 14:08:09 -0800 (PST)
Received: from mail-bk0-f41.google.com (mail-bk0-f41.google.com
	[209.85.214.41]) by cuda.sgi.com with ESMTP id iZN8iOzFKiky92ij
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 02 Feb 2014 14:08:08 -0800 (PST)
Received: by mail-bk0-f41.google.com with SMTP id na10so2817887bkb.0
	for <xfs@oss.sgi.com>; Sun, 02 Feb 2014 14:08:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140202215720.GT2212@dastard>
References: <1391220332-22118-1-git-send-email-fdmanana@gmail.com>
	<20140202215720.GT2212@dastard>
Date: Sun, 2 Feb 2014 22:08:06 +0000
Message-ID: <CAL3q7H7wgDvUWUJdZJSswm+hx==GvyeVMd=sh_yNkCVOTyyypw@mail.gmail.com>
Subject: Re: [PATCH] xfstests: more tests for test case btrfs/030
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
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
Cc: Josef Bacik <jbacik@fb.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Feb 2, 2014 at 9:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Feb 01, 2014 at 02:05:32AM +0000, Filipe David Borba Manana wrote:
>> This change adds some new tests for btrfs' incremental send feature.
>> These are all related with inverting the parent-child relationship
>> of directories, and cover the cases:
>>
>> * when the new parent didn't get renamed (just moved)
>> * when a child file of the former parent gets renamed too
>>
>> These new cases are fixed by the following btrfs linux kernel patches:
>>
>> * "Btrfs: more send support for parent/child dir relationship inversion"
>> * "Btrfs: fix send dealing with file renames and directory moves"
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>
> Rather than modifying 030 which will cause it to fail on kernels
> where it previously passed, can you factor out the common code and
> create a new test with the additional coverage?
>
> i.e. the rule of thumb is that once a test is "done" we don't go
> back and modify it in significant ways - we write a new unit test
> that covers the new/extended functionality. Redundancy in unit tests
> is not a bad thing...

Right. The only reason I did this, instead of a new test file, is that
because the former fix which btrfs/030 relates to is not yet in any
kernel release. Given this fact, what do you think?

thanks

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
