Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3G0lKX7099752 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 19:47:20 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C383014DA682
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 17:50:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wvRDzrg3T5Xwm8Ed for <xfs@oss.sgi.com>;
	Fri, 15 Apr 2011 17:50:43 -0700 (PDT)
Date: Sat, 16 Apr 2011 10:50:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110416005040.GP21395@dastard>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Thu, Apr 14, 2011 at 11:01:04PM -0600, Andreas Dilger wrote:
> On 2011-04-14, at 6:09 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > No, this was explicitly laid out in the fiemap interface
> > discussions - it's up to the applicaiton to decide if it needs
> > to do a sync first. That's what the FIEMAP_FLAG_SYNC control
> > flag is for.  This forces the fiemap call to do a fsync _before_
> > getting the mapping. If you want to know the exact layout of the
> > file is, then you must use this flag.
> > =

> > Even so, it is recognised that this is racy - any use of the
> > block map has a time-of-read-to-time-of-use race condition that
> > means you have to _verify_ the copy after it completes. FYI,
> > that's what xfs_fsr does when copying based on extent maps - if
> > the inode has changed in _any way_ during the copy, it aborts
> > the copy of that file.
> > =

> > i.e. using fiemap for copying is at best a *hint* about the
> > regions that need copying, and it is in no way a guarantee that
> > you'll get all the information you need to make accurate copy
> > even if you do use the synchronous variant.
> =

> I would tend to agree with P=E1draig. If there is data in the
> mapping (regardless of whether it is on disk or not), the FIEMAP
> should return this to the caller.  The SYNC flag is only intended
> to flush the data to disk for tools that are doing
> direct-to-disk operations on the data.

What you are suggesting is that FIEMAP needs to be page cache
coherent, and that is far, far away from the intended use of the
interface. Even consiering that you need to looking for active pages
in the page cache when mapping extents say to me that you are
doing something very wrong.

Unwritten extents remain unwritten until the data is physically
written to them. Therefore, to change their state, you need to sync
the data covering the range.  _Lying_ about whether an extent is in
the unwritten state is a really bad precedence to set, especially as
it is then guaranteed to change state when a crash occurs (Why did
recovery zero out my file? FIEMAP said it contained data before my
system crashed!).

Don't try to mangle the API semantics every time someone doesn't
understand how to use FIEMAP reliably. If you need the extent list
returned by FIEMAP to match what is in the page cache *regardless of

> Otherwise the UNMAPPED flag is useless, since even with "check,
> copy, check" there is no guarantee that the inode is changed
> _during_ the copy operation. It could have been written into the
> cache _before_ the FIEMAP and remain unchanged and in your case
> there would be no way to know any data was ever written to the
> file without SYNC on ever single file before FIEMAP.

I can't find any UNMAPPED flag in the FIEMAP interface, so I have no
idea what you are refering to here.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
