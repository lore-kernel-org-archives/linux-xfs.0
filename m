Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59KU8Vx199330 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 15:30:08 -0500
Received: from pyre.virge.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E83484B0BAE
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 13:30:06 -0700 (PDT)
Received: from pyre.virge.net (24-246-28-70.cable.teksavvy.com [24.246.28.70])
	by cuda.sgi.com with ESMTP id 0H5a7Vtt4aryN9N0 for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2011 13:30:06 -0700 (PDT)
Date: Thu, 9 Jun 2011 16:30:01 -0400
From: Norbert Veber <nveber@pyre.virge.net>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110609203000.GM28625@pyre.virge.net>
References: <20110607163742.GH28625@pyre.virge.net>
	<20110609012907.GR32466@dastard>
	<20110609134811.GI28625@pyre.virge.net> <201106091830.29491@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201106091830.29491@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Thu, Jun 09, 2011 at 06:30:28PM +0200, Michael Monnerie wrote:
> On Donnerstag, 9. Juni 2011 Norbert Veber wrote:
> > In these kinds of cases maybe there should be an error logged instead
> > of just silently ignoring them?
> 
> And also don't show them in the mount options when calling "mount" or 
> "cat /proc/mount".

Yes, thats even worse.  I found I can just put random things in there
when doing a mount -o remount, and it will just show up.

pyre:~# mount -o remount,bobsyouruncle /shared
pyre:~# mount | grep shared
/dev/mapper/vg0-shared on /shared type xfs (rw,sunit=128,swidth=256,bobsyouruncle)

Thats on 2.6.32.  No error in dmesg output either.

It doesnt accept random nonexistent options when mounting, only when
remounting.  

moupyre:~# mount -o bobsyouruncle /shared
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/vg0-shared,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
pyre:~# dmesg | tail -n1
[441854.007959] XFS: unknown mount option [bobsyouruncle].

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
