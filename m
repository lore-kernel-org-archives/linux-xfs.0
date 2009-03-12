Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CJv8FA096575 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 14:57:29 -0500
Received: from web31805.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 1E9941C3AE20
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 12:56:45 -0700 (PDT)
Received: from web31805.mail.mud.yahoo.com (web31805.mail.mud.yahoo.com
	[68.142.207.68]) by cuda.sgi.com with SMTP id 06rakXCKWh5ppyut
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 12:56:45 -0700 (PDT)
Message-ID: <296855.89556.qm@web31805.mail.mud.yahoo.com>
Date: Thu, 12 Mar 2009 12:56:45 -0700 (PDT)
From: brian wince <bswince@yahoo.com>
Subject: issues with project quota over nfs
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1092733550412417733=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1092733550412417733==
Content-Type: multipart/alternative; boundary="0-2113199796-1236887805=:89556"


--0-2113199796-1236887805=:89556
Content-Type: text/plain; charset=us-ascii

All,
We have a Quad-core server running gentoo 2.6.27-r7 that is used as an nfs server for a xfs partition.
We are using project quota's on directories within this partition and exporting this.
When a client tries to untar in the dir with project quotas set and reaches the quota limit the load on the NFS server goes up dramatically and stays like this for a few minutes after the tar has gone through trying to write all of it files and failing due to quota limit exceeded.

Is this a known issue and if so is there anything that can be done to resolve this.

We do not see this issue if on the locally mounted partition. This only happens over NFS.

Please let me know if you need more information or if this should be addressed on a different list.

TIA,

Brian


      
--0-2113199796-1236887805=:89556
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt"><DIV>All,</DIV>
<DIV>We have a Quad-core server running gentoo 2.6.27-r7 that is used as an nfs server for a xfs partition.</DIV>
<DIV>We are using project quota's on directories within this partition and exporting this.</DIV>
<DIV>When a client tries to untar in the dir with project quotas set and reaches the quota limit the load on the NFS server goes up dramatically and stays like this for a few minutes after the tar has gone through trying to write all of it files and failing due to quota limit exceeded.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Is this a known issue and if so is there anything that can be done to resolve this.</DIV>
<DIV>&nbsp;</DIV>
<DIV>We do not see this issue if on the locally mounted partition. This only happens over NFS.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Please let me know if you need more information or if this should be addressed on a different list.</DIV>
<DIV>&nbsp;</DIV>
<DIV>TIA,</DIV>
<DIV>&nbsp;</DIV>
<DIV>Brian</DIV></div><br>

      </body></html>
--0-2113199796-1236887805=:89556--


--===============1092733550412417733==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1092733550412417733==--
