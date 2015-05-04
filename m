Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E5DAC7F55
	for <xfs@oss.sgi.com>; Mon,  4 May 2015 18:00:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC00E8F8050
	for <xfs@oss.sgi.com>; Mon,  4 May 2015 16:00:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Oc6k4FaFBXdCWzhe for <xfs@oss.sgi.com>;
	Mon, 04 May 2015 16:00:25 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YpPLP-0005iI-Jy
	for xfs@oss.sgi.com; Tue, 05 May 2015 09:00:11 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YpPLP-0003Oe-Iy
	for xfs@oss.sgi.com; Tue, 05 May 2015 09:00:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: couple of corruption fixes...
Date: Tue,  5 May 2015 09:00:06 +1000
Message-Id: <1430780408-12539-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This are two patches following up on review discussions that were
had a while back. Both fix problems that cause on-disk corruption.

Comments, testing, thoughts welcome.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
