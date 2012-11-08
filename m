Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA85bfJs219444 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 23:37:41 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sLg7x72FBuFRu5vE for <xfs@oss.sgi.com>;
	Wed, 07 Nov 2012 21:39:38 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TWKq0-0003N9-1z
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 16:39:36 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TWKpz-0004v2-Tq
	for xfs@oss.sgi.com; Thu, 08 Nov 2012 16:39:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3]xfs: growfs infrastructure changes for 3.8
Date: Thu,  8 Nov 2012 16:39:30 +1100
Message-Id: <1352353173-18820-1-git-send-email-david@fromorbit.com>
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

Hi folks.

The following 3 patches are changes to growfs necessary for supporting CRC
verification of metadata. The first converts AG btree root blocks to use the
generic btree header block initialisation code so CRC support only needs to be
added in one place. The second allows verifiers to distinguish between a write
for growfs whenteh xfs-perag is not fully initialised by using uncached buffers.
And the last adds initialisation of the AGFL during growfs, which we currently
don't do at all.

These are also patches for the 3.8 cycle i'd lik eto see in the 3.8 cycle - the
more infrastructure changes that get done in 3.8, the less there will be when
the format changes and CRCs patches arrive for the 3.9 cycle...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
