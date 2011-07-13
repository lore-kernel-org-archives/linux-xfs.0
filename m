Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DExgxY088349 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 09:59:43 -0500
Received: from Ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A13B69128
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 07:59:41 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id ZoOWJU57equnDxMQ for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2011 07:59:41 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.tlinx.org (8.14.4/8.14.4/SuSE Linux 0.8) with ESMTP id
	p6DExbFI019045 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 07:59:39 -0700
Message-ID: <4E1DB2D9.4060900@tlinx.org>
Date: Wed, 13 Jul 2011 07:59:37 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: suse cp copies 'acls' and extended attrs....
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
To: xfs-oss <xfs@oss.sgi.com>

I'm not sure if it is in mainline cp (would tend to guess it is likely), 
but the default
cp -a mode will copy all file attributes now, as well, by default.  (You 
can turn it off, but
the default for -a(rchive) mode is to copy everything...)...


So you can use 'cp' now to copy xfs files around and not lose 
capabilities, acls or other ext_attrs,
as well as rsync....


Just an FYI from someone who just found out recently  -- it may be old 
news...if so, sorry,
first I heard of it!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
