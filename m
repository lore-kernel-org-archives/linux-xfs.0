Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 06DEA7F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 17:41:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CC12AC003
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 15:41:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	K8vNSwsfOKYXcXuV for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 15:41:18 -0700 (PDT)
Date: Fri, 17 May 2013 08:41:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfstests: generic/235 breaks /etc/mtab symlinks
	breaks xfs/189
Message-ID: <20130516224114.GF24635@dastard>
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
	<1368062501-15046-4-git-send-email-david@fromorbit.com>
	<5194D12E.4000903@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5194D12E.4000903@sgi.com>
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
Cc: xfs@oss.sgi.com

On Thu, May 16, 2013 at 07:29:34AM -0500, Rich Johnston wrote:
> On 05/08/2013 08:21 PM, Dave Chinner wrote:
> >From: Dave Chinner <dchinner@redhat.com>
> >
> >Serenity lost.
> >Insanity looms darkly.
> >/etc/mtab
> >
> >Random behaviour.
> >xfs/189 fails
> >After a week passing.
> >
> >-SCRATCH_DEV on SCRATCH_MNT type xfs (ro,filestreams)
> >+SCRATCH_DEV on SCRATCH_MNT type xfs (ro,relatime,attr2,filestreams,inode64,noquota)
> >
> >Confusion prevails.
> >/proc/mounts can never give success.
> >Anything but golden.
> >
> >ls -l
> >/etc/mtab shows:
> >lrwxrwxrwx 1 root root 12 May  8 16:05 /etc/mtab -> /proc/mounts
> >
> >symlink modified.
> >Stealth. Deception. WTF?
> >Ninjas go unseen.
> >
> >"git grep mtab". Yay!
> >generic/235: sad
> >SElinux hack.
> >
> >Remount context grot.
> >Mount uses all options from
> >/etc/mtab
> >
> >Kernel rejects mount.
> >sed hacks /etc/mtab
> >Symlink becomes file.
> >
> >Test frobulation.
> >xfs/189 passes
> >Randomness tamed.
> >
> >Double face-palm. Tears.
> >Crack-inspired insanity.
> >mount(8) needs fixing.
> >
> >Schizophrenia.
> >/etc/mtab. Same thing.
> >Test psychiatry.
> >
> >Hack, slash, glue, polish.
> >xfs/189 fixed.
> >Made shiny again.
> >
> >Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >---
> 
> Thanks for the cleanup patches.  Only comment is although I enjoy
> the humorous patch description, can we make it shorter?

No, I'm not going to rewrite it - there's nothing wrong with having
a long commit message to describe the change.

FWIW, the notes I wrote as I tracked down this problem are about
twice as long as this summary, so any straight up and down
description of the problem is not going to make the commit message
smaller.  And a boring commit message will simply not convey the
insanity of the situation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
