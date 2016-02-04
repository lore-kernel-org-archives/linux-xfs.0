Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4FE37CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:07:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 957A18F8033
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:07:35 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EjSUbYa5d26zmx8r for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 15:07:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRSxa-0000EZ-AO
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRSxa-0004yo-9q
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7 v2] repair: big broken filesystems cause pain
Date: Fri,  5 Feb 2016 10:05:01 +1100
Message-Id: <1454627108-19036-1-git-send-email-david@fromorbit.com>
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

This is a followup to the original series I posted here:

http://oss.sgi.com/archives/xfs/2015-12/msg00557.html

This addresses Brian's review comments for patch 3 - the da tree
node splitting doesn't use extra blocks for the root split - and
includes the patch I missed in the original patch posting to
reset the dirty buffer priority when it is looked up again (patch
7). Otherwise the patch series is unchanged.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
