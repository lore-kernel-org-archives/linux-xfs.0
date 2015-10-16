Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 678947F5E
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:19:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BA5C304053
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 06:19:02 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19]) by cuda.sgi.com
	with ESMTP id 4mykm7dPkizGhynI (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 06:19:00 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-7e00f108-b6b9-4750-82b6-fb7533517200-1445001537779@3capp-gmx-bs54>
From: Dragon <Sunghost@gmx.de>
Subject: Error in `xfs_repair': double free or corruption
Date: Fri, 16 Oct 2015 15:18:57 +0200
References: <trinity-16122364-b1e6-4dc9-9057-f2df3aa193bb-1445001446455@3capp-gmx-bs54>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3522741907616444895=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3522741907616444895==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>Hello,<br/>
i have a problem after repaired a degraded Softare Raid6. System is Debian Jessi and Root and Boot are on Raid1, and Data on Raid6 on md2 which miss one Disk. The mainproblem was a missing Disk because of badblocks which i cloned and exchanged agains a new one. After that i could successfully rebuild the raid (md2), while now only one disk is midding. But i recognised that xfs reports inode problems. Therefor i run xfs_repair on the raid device md2, but get message &quot;Error in &#96;xfs_repair&#39;: double free or corruption&quot;<br/>
What can i do the fix this?<br/>
thx<br/>
&nbsp;</div></div></body></html>


--===============3522741907616444895==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3522741907616444895==--
