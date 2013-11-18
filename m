Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF48229E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 16:53:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A5F7AC006
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 14:53:48 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	29bEClZHDmA4OcPb for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 14:53:46 -0800 (PST)
Date: Tue, 19 Nov 2013 09:53:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 1/1] xfsprogs: update version for 3.2.0-alpha2
Message-ID: <20131118225342.GX6188@dastard>
References: <20131118150313.940966335@sgi.com>
	<20131118150313.940966335@sgi.com>
	<20131118151117.GA4459@infradead.org> <528A3533.3080607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528A3533.3080607@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 18, 2013 at 09:41:39AM -0600, Rich Johnston wrote:
> On 11/18/2013 09:11 AM, Christoph Hellwig wrote:
> >On Mon, Nov 18, 2013 at 09:03:13AM -0600, rjohnston@sgi.com wrote:
> >>+xfsprogs-3.2.0-alpha2 (18 November 2013)
> >>+	- Alpha release for the purpose of testing the CRC feature during the
> >>+	  v3.12 kernel -rc series.
> >
> >Please list the actual changes here, and also update the list for
> >-alpha1 which was missing all the usual information as well.
> >
> I will send a new V2 with the requested information after others
> have chimed in.
> 
> Attached are the commits so far:

I think what Christoph means is that there needs to be a summary of
all the changes made, not a list of the commits that were included.
i.e. a list of bugs fixed, features added and changes made written
in a way that a user would be able to look at and say "oh, they've
fixed the problem I saw"....

> commit 64eb960fb0d95bab9aa0c28f8c809bcaaeac564f
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Thu Nov 14 20:54:02 2013 +0000
> 
>     xfsprogs: Fix stray semicolon in libxfs/rdwr.c

So something like that is not worth mentioning

> --
> commit 79e106f05f0fbffb89ab5401fb97af5391c6291f
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Thu Nov 14 20:38:08 2013 +0000
> 
>     xfs_repair: correct docs for "-t" units

But this is as "fixed units in xfs_repair man page"

> --
> commit 1adfe5c6296d3ea6c182f31a6728fc94af9146f7
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Fri Oct 18 22:30:18 2013 +0000
> 
>     xfs_fsr: fix SWAPEXT failures under selinux

That's worth mentioning

> --
> commit 275077754611e5a15672624e674265b54f1cb7ed
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Fri Oct 18 22:09:07 2013 +0000
> 
>     xfs_fsr: extra debugging info

But this isn't.

> --
> commit 9b981421f503ba679097f8cd749af37cc42f5fd7
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Nov 13 06:41:00 2013 +0000
> 
>     repair: fix leaf node directory data check

That isn't worth mentioning because it's a bug fix for a change in
this series....

> --
> commit 0cce4aa198f0470817bedb3781ea5b6955e43076
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Nov 13 06:40:59 2013 +0000
> 
>     repair: Increase default repair parallelism on large filesystems
> --
> commit 61510437c627b529feb95ebffddd73df5ed5b104
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Nov 13 06:40:58 2013 +0000
> 
>     repair: prefetching is turned off unnecessarily

But these are.

And so on - use your discretion...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
