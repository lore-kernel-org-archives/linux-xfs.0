Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C50f4p189228 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 00:00:42 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B4BC120B6A1
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 22:08:21 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id y1gxhONFdlHVhyCF for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 22:08:21 -0700 (PDT)
Message-ID: <4A31E0FF.8050400@tlinx.org>
Date: Thu, 11 Jun 2009 22:00:47 -0700
From: "Linda A. Walsh" <suse@tlinx.org>
MIME-Version: 1.0
Subject: grub no longer being maintained?  drops support for XFS?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: SuSE Linux <opensuse@opensuse.org>
Cc: xfs-oss <xfs@oss.sgi.com>

I just saw this bug, https://bugzilla.novell.com/show_bug.cgi?id=459792,
that reports a problem in OpenSUSE with Grub being unable to boot with
XFS when someone upgraded from OpenSuSE11.0 to OpenSuSE11.1.
Quote:

Grub is unable to start if /boot is on xfs partition.
Found after updating from 11.0 to 11.1.

Response from Novell:

------- Comment #1 From Jiri Srain (jsrain(at)novell(dot)com) 2008-12-18 04:24:39 MST 
-------

We agreed with product management that /boot on XFS will not be a supported
bootloader scenario. See relevant thread on factory to see explanations;
successful booting from XFS is just a pure luck.

Perhaps if Grub can't support XFS, the default bootloader should
be upgraded to 'lilo' -- as it still seems to be maintained and still
supports high performance file systems like XFS.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
