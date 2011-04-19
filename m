Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3JL54lt053486 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 16:05:04 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 912AF3F8660
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 14:08:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	x3C9TgukPqsOPpI0 for <xfs@oss.sgi.com>;
	Tue, 19 Apr 2011 14:08:29 -0700 (PDT)
Date: Wed, 20 Apr 2011 07:08:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110419210825.GJ23985@dastard>
References: <20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110419140909.GD3030@thunk.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Tue, Apr 19, 2011 at 10:09:09AM -0400, Ted Ts'o wrote:
> On Tue, Apr 19, 2011 at 05:45:38PM +1000, Dave Chinner wrote:
> > You are *not listening*. There is no #2. FIEMAP returns the extent
> > state _on disk_ at the time of the call.
> 
> Dave, you're being rather strident about your insistence about what
> FIEMAP's semantics are. 

The bit about the page cache state being relevant? That's what I was
refering to here.

> Part of the problem here is that it's *not*
> clear or settled.
> 
> If it really is the state _on_ _disk_, does XFS really have a DELALLOC
> bit _on_ _disk_?

Sigh. No.

This whole thing blew up because of unwritten extent behaviour when
there is dirty page cache covering and unwritten extent. Delalloc
was not the issue - what I said is absolutely true for unwritten
extents.  Somewhere in the middle someone started talking about
delalloc extents and conflating their behaviour with unwritten
extents, but I continued to talk about unwritten extents and
cached pages.

Even so, for delalloc extents the dirty page state in the page cache
is irrelevant. I've said earlier that XFS delalloc extents can span
regions that have no page cache state - they don't get reported as
holes by FIEMAP because they are tracked as delalloc. IOWs, like
unwritten extents, you can't rely on delalloc extents to tell you
where the data is in the file.

So, it logically follws that you need to use the SYNC flag for both
unwritten extents and delalloc extents to find out where there data
realy lies by converting them to real, written extents. i.e. the
only extents you can trust contain data from FIEMAP are the real
extents on disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
