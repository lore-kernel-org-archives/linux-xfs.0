Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5AEtt7h079893 for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 09:55:56 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CFC41E0C29F
	for <xfs@oss.sgi.com>; Thu, 10 Jun 2010 07:58:27 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id GYCoFuvuBerqnyTw for
	<xfs@oss.sgi.com>; Thu, 10 Jun 2010 07:58:27 -0700 (PDT)
Message-ID: <4C10FD91.4060209@sandeen.net>
Date: Thu, 10 Jun 2010 09:58:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs, aacraid
	2.6.27 => 2.6.32 results in 6 times slowdown]
References: <4C0E13A7.20402@msgid.tls.msk.ru>
	<20100608122919.GC7869@dastard>	<4C0EA938.9000104@msgid.tls.msk.ru>
	<20100608231845.GG7869@dastard>	<4C0F3819.4000409@msgid.tls.msk.ru>
	<20100609074741.GJ7869@dastard>	<4C0FE779.8010603@msgid.tls.msk.ru>
	<20100610004701.GN7869@dastard>
In-Reply-To: <20100610004701.GN7869@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, Jun 09, 2010 at 11:11:53PM +0400, Michael Tokarev wrote:


>> The same is with -o osyncisosync (in .34).  Actually,
>> osyncis[od]sync mount options does not change anything, not
>> in .32 nor in .34.
> 
> I think only osyncisosync exists, and it doesn't do anything
> anymore.

Just to be pedantic, osyncisdsync "exists," but is deprecated and does
nothing to change defaults:

                } else if (!strcmp(this_char, "osyncisdsync")) {
                        /* no-op, this is now the default */
                        cmn_err(CE_WARN,
        "XFS: osyncisdsync is now the default, option is deprecated.");
                }

huh, didn't realize that osyncisosync does nothing but set a flag that
is never tested other than to show mount options:

  File                  Function      Line
0 xfs_mount.h           <global>      285 #define XFS_MOUNT_OSYNCISOSYNC (1ULL << 13)
1 linux-2.6/xfs_super.c xfs_parseargs 292 mp->m_flags |= XFS_MOUNT_OSYNCISOSYNC;
2 linux-2.6/xfs_super.c xfs_showargs  542 { XFS_MOUNT_OSYNCISOSYNC, "," MNTOPT_OSYNCISOSYNC },

Time to deprecate/remove that one too I guess?

-Eric
 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
