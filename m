Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7FIsDNB198715 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 13:54:13 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0792BCB2444
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 12:03:44 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id UzYQFtulA4CsWB3c for
	<xfs@oss.sgi.com>; Sun, 15 Aug 2010 12:03:44 -0700 (PDT)
From: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: xfs.fsck change that is unhelpful
Date: Sun, 15 Aug 2010 20:54:27 +0200
References: <4C670101.8050901@tlinx.org> <20100815005240.GH10429@dastard>
	<4C674AE8.7030107@tlinx.org>
In-Reply-To: <4C674AE8.7030107@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201008152054.27909.hpj@urpla.net>
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
To: xfs@oss.sgi.com

On Sunday 15 August 2010, 04:03:20 Linda Walsh wrote:
> Dave Chinner wrote:
> > On Sat, Aug 14, 2010 at 01:48:01PM -0700, Linda A. Walsh wrote:
> >> Some time ago, when I upgraded a system, I ran into problems when
> >> it hit a file system that was offline.  It wasn't a critical
> >> partition, so it normally wouldn't have been an issue, but somewhere
> >> along the line
> >> someone mangled fsck.xfs.
> >
> > fsck.xfs is behaving identically to e2fsck when presented with an
> > invalid block device - it exits with an error of 8, which is defined
> > as "operational error" in the e2fsck man page.
>
> ---
> 	That may be fine for the ext2 fs, but I am asserting that in actual
> practice, with xfs, it does more harm than good.

Linda, you're barking at the wrong tree, IMHO.

If xfs would tolerate any configuration failure, a lot of people would 
complain for a _good_ reason. 

> > That sounds like a problem with the distro init scripts or you've
> > stuffed up your /etc/fstab config (i.e. fs_passno is wrong). Indeed,
> > setting fs_passno = 0 will cause the filesysetm fsck to be skipped
> > completely on boot, regardless of the fs type...
>
> ---
> 	Yes, you are right.  They are setup to be check in the order
> I would want them mounted.  But I don't see the benefit to being
> compliant with a checking mechanism for a file system that is
> actually needs fsck.
>
> 	It was long a *feature* of xfs, that xfs.fsck, was a noop.
>
> 	I don't see that making it fail in ways fsck does for a file
> system that *needs* fsck, is productive.  Sure, it may be dotting i's
> and crossing t's, but in reality, is that a standard xfs should be
> living down to?

Of course, most of the attending audience is being bitten by such a 
configuration failure, but to argue, that it is wrong behavior, if the init 
code decides to stop booting, because some devices configured to mount on 
boot failed to mount, is, hmm, incongruous..

By (current) definition, the init system has absolutely no business to 
_weight_ the _severity_ of such a basic failure. Nowadays, there are enough 
ways to delay the mount (noauto, autofs) for certain FS in order to avoid 
such a failure - if that is what you want - but generally ignoring any fsck 
failures, be them on journaling FS or not is not acceptable. And making xfs 
special in the regard is even more incongruous.

Pete

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
