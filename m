Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CF3829DF5
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 13:54:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49461304032
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 11:54:58 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18]) by cuda.sgi.com
	with ESMTP id YZfk87b6db2iYNLT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 11:54:56 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-35b666d3-ff9b-4764-9962-bf376c678994-1436381694787@3capp-mailcom-bs09>
From: "Mark Noon" <mnoon@gmx.com>
Subject: Proper SU/SW values for nested raids RAID50/RAID60
Date: Wed, 8 Jul 2015 20:54:54 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2403697590767774586=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2403697590767774586==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>I&#39;m trying to understand the proper values when formatting an xfs filesystem under a hardware raid controller and seem to get conflicting information between whats on the wiki and various mailing listings and forum posts when searching google. I have a system that will be storing images and other static content files accross a RAID50. The plan is to do 3 raid5 arrays each with 5 disks with a stripe size of 128K striped accross a raid0. I will then build a logical volume on top of this.</div>

<div>&nbsp;</div>

<div>When running mkfs.xfs should the correct settings be&nbsp;<span style="line-height: 1.6em;">su=128k sw=12 (-1 parity &#39;disk&#39; for each of the 3 arrays) or su=128k sw=4 (only consider one of the arrays)?&nbsp;</span></div>

<div>&nbsp;</div>

<div><span style="line-height: 1.6em;">Also if I ever add a JBOD and extend the storage how does this change things esspecially given that it will be on a completely different raid volume just merged together via LVM?</span></div>

<div>&nbsp;</div>

<div><span style="line-height: 1.6em;">Thanks for the assitance!</span></div>

<div>&nbsp;</div>

<div>&nbsp;</div></div></body></html>


--===============2403697590767774586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2403697590767774586==--
