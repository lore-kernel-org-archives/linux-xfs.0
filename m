Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C06629DF8
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 00:29:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70878304059
	for <xfs@oss.sgi.com>; Sun,  2 Jun 2013 22:29:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5YpkYKZa3et2F6hD for <xfs@oss.sgi.com>;
	Sun, 02 Jun 2013 22:28:59 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: fixes for 3.10-rc4
Date: Mon,  3 Jun 2013 15:28:45 +1000
Message-Id: <1370237332-24757-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bpm@sgi.com

Hi Ben,

He's an up-to-date set of patches remaining for 3.10. It fixes the
dquot crc calc that Brain pointed out, as well are removes the
unnecessary xfs_iunlink_dinode_calc_crc() function.

There's also a new patch that deals with rejecting the noattr2 mount
option for CRC enabled filesystems. attr2 is always enabled for
them, so the noattr2 mount option needs to be rejected as invalid.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
