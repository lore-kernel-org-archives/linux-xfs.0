Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A51197F47
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 18:14:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 846CF30405F
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 16:14:27 -0700 (PDT)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	tO1yRPzEmOGN1KoL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 16:14:25 -0700 (PDT)
Received: by mail-ie0-f171.google.com with SMTP id rp18so1866688iec.2
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 16:14:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Aug 2014 16:14:25 -0700
Message-ID: <CAGdUFVa3e7VPcmkn3OvcVenXTCedffXov_YSg427aVvURDRUSg@mail.gmail.com>
Subject: Find hardlinks to a file
From: Chris Holcombe <xfactor973@gmail.com>
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
To: xfs@oss.sgi.com

My apologies if this has already been asked.  I feel that I've done a
sufficient amount of Google search homework.  I'm working with Gluster
(http://www.gluster.org/) and they have a directory called xattrop
where they store links to files that need to be healed.  When I stat
the file I can see that there's 2 or 3 hard links to the file.  I
can't seem to find a way in code or with an xfs_* utility to find the
path of those hard links.  Does anyone know how to do this or if it's
even possible?  From looking through the XFS documentation I don't
really see a way to do it without a find /mount_point -num <number>
brute force method.  btrfs has a utility called:

btrfs inspect-internal inode-resolve [-v] <inode> <path>
              Resolves an <inode> in subvolume <path> to all filesystem
              paths.

I'd like to build an equivalent tool in C for XFS if it's possible.

Thanks,
Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
