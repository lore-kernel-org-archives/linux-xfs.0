Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 252037F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 01:23:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B784AAC001
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 23:23:27 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bVgIa2gdF8MBdoZe for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 23:23:25 -0700 (PDT)
Date: Mon, 8 Sep 2014 16:23:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs_repair: don't ASSERT on corrupt ftype
Message-ID: <20140908062321.GA20518@dastard>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-5-git-send-email-sandeen@redhat.com>
	<20140908001044.GB30012@dastard> <540D001C.6020607@sandeen.net>
	<20140908031644.GZ20518@dastard> <540D1FF1.4030601@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540D1FF1.4030601@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 10:18:09PM -0500, Eric Sandeen wrote:
> On 9/7/14 10:16 PM, Dave Chinner wrote:
> >On Sun, Sep 07, 2014 at 08:02:20PM -0500, Eric Sandeen wrote:
> >>On 9/7/14 7:10 PM, Dave Chinner wrote:
> 
> ...
> 
> >>>Needs to be fixed kernel-side first.
> >>
> >>xfs_dir3_dirent_get_ftype doesn't exist in kernelspace :)
> >>
> >>bleah, why do they have different names...  Ok, will send.
> >
> >Because kernel has changed, and we need to do yet another large
> >kernel/user libxfs sync.
> >
> >I haven't found time to do that yet. Unless you want to volunteer
> >for it....
> 
> I could give it a shot.  Do you usually do it commit-by-commit,
> diff-and-edit, or a big copy?

This one is going to need multiple phases, and in a moment you're
going to understand what all functions called into libxfs should
have a "libxfs define wrapper":

	1. sync up to kernel commit before error negation
	2. make sure all external function calls have libxfs
	   define wrappers
	3. commit error negation patch and change sign of all libxfs
	   define wrappers
	4. apply kernel libxfs rename patch and restructure
	   libxfs userspace and xfsprogs build to match
	5. continue syncing kernel changes commit by commit.

Given the scope of changes, and the fact that some of the changes
have already been applied (i.e. bug fixes, finobt changes, etc)
step #1 is not going to be a straight forward commit-by-commit.
So I'm happy to do that as a bulk commit. Steps #2 and #3 are
relatively straight forward, too, just a bit painful as we need
to be sure we don't leak negative errors.

Step #4 is the big one; we want to end up with the kernel
fs/xfs/libxfs to be identical to the xfsprogs:/libxfs/ code and so
in userspace we've got to move headers around and rejig includes and
things like that. That's one I should probably do.

And from there, step 5 should be a simple extract/sed/commit process
of pulling patch by patch from the kernel changes that touch
fs/xfs/libxfs....

So, really, the big step right now is #1...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
