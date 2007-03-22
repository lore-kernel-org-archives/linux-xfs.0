Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Mar 2007 12:10:05 -0700 (PDT)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2MJA06p003855
	for <linux-xfs@oss.sgi.com>; Thu, 22 Mar 2007 12:10:01 -0700
Message-ID: <4602D433.3070406@exegy.com>
Date: Thu, 22 Mar 2007 14:08:35 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Subject: Quick fix for LSI8888ELP overruns in 2.6.20 and 2.6.21-rc4
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

My local kernel guru recognized this problem as a duplicate of the
LSI8408E bus lockup problem. The controller gets flooded with work,
and just climbs under a rock to hide. In the 8408E case, it
froze the PCI-e bus :-)

#!/bin/csh
#
# set the max request queue down from 128. any more than 32
# quickly slows down from 810MB/Sec to 11MB/Sec.
#
setenv X 32
#
foreach i ( /sys/block/sd{g,h,i,j,k,l,m,n}/queue/nr_requests)
   echo $X > $i
   end

Lots of time was spent in the congestion queue, like 99% of the time.

Berkley
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
