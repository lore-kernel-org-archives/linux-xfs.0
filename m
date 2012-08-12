Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7CLbUMR170128 for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 16:37:31 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4JtM4ioaWYmRYTpz for <xfs@oss.sgi.com>;
	Sun, 12 Aug 2012 14:37:28 -0700 (PDT)
Date: Mon, 13 Aug 2012 07:37:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bad version from xfs_repair after raid crash
Message-ID: <20120812213719.GI2877@dastard>
References: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E94@COSMOS.nbg.geneon.de>
	<5026D290.10209@sandeen.net>
	<27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E98@COSMOS.nbg.geneon.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E98@COSMOS.nbg.geneon.de>
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
To: Andreas Vogler <andreas.vogler@geneon.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Aug 12, 2012 at 09:49:48AM +0200, Andreas Vogler wrote:
> 
> > Is your xfsprogs version up to date?
> 
> 
> I guess the xfsprogs are rather old but they should be on the same level as the filesystem as they are part oft he same distro (OpenFiler 2.3, package is called xfsprogs=2.6.25-4-0.1).

That's -very- old:

-- Nathan Scott <nathans@debian.org>  Tue, 29 Mar 2005 11:57:57 +1000

xfsprogs (2.6.26-1) unstable; urgency=low

  * New upstream release.
  * Man page updates (closes: #295397)
  * Fix compilation with gcc version 4 (closes: #297876)
  * Switch build dependency from readline4 to readline5.


> > You could also include another email with the output from xfs_db -c "sb 0" -c "p" /dev/blah
> 
> Here ist he output of xfs_db:
> 
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 332800000
> rblocks = 0
> rextents = 0
> uuid = 567f4c2f-ce9a-42a3-bbc2-e791cf43f8ae
> logstart = 268435460
> rootino = 128
> rbmino = 129
> rsumino = 130
> rextsize = 1
> agblocks = 83200000
> agcount = 4
> rbmblocks = 0
> logblocks = 32768
> versionnum = 0xb4a4
.....
> features2 = 0x8

So it's got the ATTR2 feature bit set.

 -- Nathan Scott <nathans@debian.org>  Tue, 31 Jan 2006 13:35:39 +1100

xfsprogs (2.7.7-1) unstable; urgency=low

  * New upstream release.
  * Add support for (optional) ATTR2 format extension (closes: #336350)
  * Allow gcc -pedantic option for C++ <xfs.h> users (closes: #249429)
  * Fix segv in xfs_db frag command (closes: #338207)

So, yeah, upgrade your userspace to something recent, and it will
just work.

> But I have already experimented a little bit, originally
> versionnum was 0xb4f4 but the next superblock (sb 1) contained
> 0xb4a4, so I tried to set it with xfs_db to this value, but it
> didn't make a difference.

Don't stuff around with feature bits if you don't know what they
mean - you'll render parts of your filesystem
unusable/corrupt/unreadable by doing so.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
