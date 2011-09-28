Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SAvIYW103483 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 05:57:18 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 0/5] xfsprogs: some libxcmd cleanups
Date: Wed, 28 Sep 2011 05:57:07 -0500
Message-Id: <1317207432-8464-1-git-send-email-aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series contains a few cleanups in libxcmd.  The main change
makes the device id's used in setting up a table of filesystems be
computed in a centralized and consistent way.  The third patch drops
support for optionally looking for a device in /dev, but as
explained there this was really not a useful feature.  Other than
that these patches should produce net change in behavior.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
