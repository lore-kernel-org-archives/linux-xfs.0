Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NKN60Z007847 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 15:23:06 -0500
Received: from mail.vlasiu.net (mail.vlasiu.net [213.157.175.46]) by
	cuda.sgi.com with ESMTP id NoOxaV3CHKTFyTSY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2012 13:23:05 -0700 (PDT)
Date: Fri, 23 Mar 2012 22:22:54 +0200 (EET)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
In-Reply-To: <4F6CD799.9090903@sandeen.net>
Message-ID: <alpine.LRH.2.02.1203232220010.4760@mail.vlasiu.net>
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
	<4F6CD1DC.7010706@sandeen.net>
	<alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
	<4F6CD799.9090903@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Fri, 23 Mar 2012, Eric Sandeen wrote:

> It wouldn't be expected to.
> 
> Please see also
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=671015
> 
> and suggestions for tracing the error, so we know exactly which case this is.

# cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 2/2   #P:2
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
         xfs_fsr-3895  [000] .... 108290.726664: xfs_swap_extent_before: dev 7:0 ino 0x400dd2e4 (target), btree format, num_extents 1463, broot size 120, fork offset 104
         xfs_fsr-3895  [000] .... 108290.726666: xfs_swap_extent_before: dev 7:0 ino 0x1c4917 (temp), extent format, num_extents 1, broot size 0, fork offset 104

Should I add the trace to the bugzilla?
Thank you.


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 0xE684206E
// OpenGPG-Fingerprint: 0C3D 9F8B 725D E243 CB3C 8428 796A DB1F E684 206E
// OpenGPG-URL        : http://www.vlasiu.net/public.key


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9s254ACgkQeWrbH+aEIG6axQCeMpnlT5YRoMSqYI7B+NMoE2zm
e98An3BW+/bk2jdsPcc8nE/c2c7gtimo
=D4cr
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
