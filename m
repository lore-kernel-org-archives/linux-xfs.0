Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Apr 2008 16:42:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3GNflml017034
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 16:41:50 -0700
Received: from mail105c25.carrierzone.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B5D8A0E61E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 16:42:26 -0700 (PDT)
Received: from mail105c25.carrierzone.com (mail105c25.carrierzone.com [64.29.147.175]) by cuda.sgi.com with ESMTP id MSvzZtxJz47HhBm6 for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 16:42:26 -0700 (PDT)
From: "Amicus Services Inc." <support@geoglobal.com>
Subject: XFS error cannot mount RAID
Date: Wed, 16 Apr 2008 18:01:35 -0600
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fNpBIeoPxt1CU2d"
Message-Id: <200804161801.35174.support@geoglobal.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, vincent.roy@geoglobal.com

--Boundary-00=_fNpBIeoPxt1CU2d
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have a AMCC RAID 5 which has been verified without error but cannot mount on 
a SUSE 10.1 OS. Inconsistency on the volume may have occurred during an 
abrupt power shutdown. Not sure if it would be prudent to run XFS_Repair at 
this stage since XFS_check returned info indicating inconsistencies exist.

Please assist in any way you can, thanks.

Vincent Roy
System Admin
403-830-7283

--Boundary-00=_fNpBIeoPxt1CU2d
Content-Type: text/plain;
  charset="us-ascii";
  name="logprint.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="logprint.txt"

xfs_logprint:
    data device: 0x811
    log device: 0x811 daddr: 1171829280 length: 262144

* ERROR: mismatched uuid in log
*            SB : 2ca4f030-af24-4cfe-b895-c702b5579ac5
*            log: e35bfa5c-8c62-0ff5-fe81-cb1ad034edb4
    log tail: 57710896 head: 130834 state: <DIRTY>


--Boundary-00=_fNpBIeoPxt1CU2d--
