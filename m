Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3F8oRwL055984 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 03:50:27 -0500
Received: from mx.meyering.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A808C163FC23
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 01:53:49 -0700 (PDT)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64]) by
	cuda.sgi.com with ESMTP id hHRQ4K3Ixzpb3BJ7 for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 01:53:49 -0700 (PDT)
From: Jim Meyering <jim@meyering.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
In-Reply-To: <20110415000940.GL21395@dastard> (Dave Chinner's message of "Fri,
	15 Apr 2011 10:09:40 +1000")
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard> <4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
Date: Fri, 15 Apr 2011 10:53:48 +0200
Message-ID: <87sjtjq4ir.fsf@rho.meyering.net>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, coreutils@gnu.org, linux-ext4@vger.kernel.org, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

Dave Chinner wrote:
> On Fri, Apr 15, 2011 at 12:29:46AM +0100, P=E1draig Brady wrote:
...
>> Well IMHO there should be a difference between
>> knowing where you are going to write, and actually writing to disk.
>> I.E. one shouldn't need to write the whole way to the device
>> before returning a valid fiemap.  If a particular file system
>> implementation needs to sync to return a valid fiemap,
>> then it should be implicit.
>
> No, this was explicitly laid out in the fiemap interface discussions
> - it's up to the applicaiton to decide if it needs to do a sync
> first. That's what the FIEMAP_FLAG_SYNC control flag is for.
> This forces the fiemap call to do a fsync _before_ getting the
> mapping. If you want to know the exact layout of the file is, then
> you must use this flag.
>
> Even so, it is recognised that this is racy - any use of the block
> map has a time-of-read-to-time-of-use race condition that means you
> have to _verify_ the copy after it completes. FYI, that's what
> xfs_fsr does when copying based on extent maps - if the inode has
> changed in _any way_ during the copy, it aborts the copy of that
> file.
>
> i.e. using fiemap for copying is at best a *hint* about the regions
> that need copying, and it is in no way a guarantee that you'll get
> all the information you need to make accurate copy even if you do
> use the synchronous variant.

Hi Dave,

Can you or anyone else point to authoritative documentation
(or even a summary of those "discussions") of FIEMAP semantics?
I'm hoping the semantics are the same for all file system types.

I had understood that cp's use of FIEMAP_FLAG_SYNC was not only
unnecessary, but even undesirable, given a new-enough kernel.
That's why coreutils-8.11 resorts to using the workaround of
FIEMAP_FLAG_SYNC only when uname says the kernel is 2.6.[0..38].

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
