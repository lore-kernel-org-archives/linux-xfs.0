Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA9347F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:01:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FF838F8039
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:01:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D4rrKUGnawNdBAuf for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:01:15 -0800 (PST)
Date: Tue, 25 Feb 2014 22:01:06 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
	range
In-Reply-To: <20140225205349.GD13647@dastard>
Message-ID: <alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-6-git-send-email-lczerner@redhat.com>
	<20140225205349.GD13647@dastard>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, 26 Feb 2014, Dave Chinner wrote:

> Date: Wed, 26 Feb 2014 07:53:49 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
>     range
> 
> On Tue, Feb 25, 2014 at 08:15:28PM +0100, Lukas Czerner wrote:
> > This is copy of xfs/242. However it's better to make it file system
> > specific because the range can be zeroes either directly by writing
> > zeroes, or converting to unwritten extent, so the actual result might
> > differ from file system to file system.
> 
> You could say the same thing about preallocation using unwritten
> extents. Yet, funnily enough, we have generic tests for them because
> all filesystems currently use unwritten extents for preallocation
> and behave identically....
> 
> This test is no different - all filesystems currently use unwritten
> extents, and so this test should be generic because all existing
> filesystems *should* behave the same.
> 
> When we get a filesystem that zeros rather uses unwritten extents,
> we can add a new *generic* test that tests for zeroed data extents
> rather than unwritten extents. All that we will need is a method of
> checking what behaviour the filesystem has and adding that to a
> _requires directive to ensure the correct generic fallocate tests
> are run...

Currently xfs/242 fails on xfs for me and it does behave differently
than ext4. Also I had to change to 242.out a bit because ext4 was
a little different. It seems to me that it was expected that when
the extent is small enough it would be overwritten by zeroes rather
than converted to unwritten, but I have not looked into
implementation.

Btw this kind of optimization is actually something I've been
thinking of as well for ext4. Rather than going though the hassle of
changing extents around it might be worth in some situation to zero
out. But that's an optimization I have not implemented yet.

-Lukas


> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
