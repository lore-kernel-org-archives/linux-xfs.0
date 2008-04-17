Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Apr 2008 16:12:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3GNBxRv009710
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 16:12:02 -0700
Received: from mail2507.carrierzone.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E5B78F309
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 16:12:38 -0700 (PDT)
Received: from mail2507.carrierzone.com (mail2507.carrierzone.com [64.29.147.17]) by cuda.sgi.com with ESMTP id HbafHLN3fHRUVGCv for <xfs@oss.sgi.com>; Wed, 16 Apr 2008 16:12:38 -0700 (PDT)
From: "Amicus Services Inc." <support@geoglobal.com>
Subject: Fwd: XFS error cannot mount RAID
Date: Wed, 16 Apr 2008 18:17:00 -0600
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8bpBIN2z73RRLKq"
Message-Id: <200804161817.00767.support@geoglobal.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, vincent@geoglobal.com

--Boundary-00=_8bpBIN2z73RRLKq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Same issue just the result of the xfs_check...

----------  Forwarded Message  ----------

Subject: XFS error cannot mount RAID
Date: Wednesday 16 April 2008 18:01
From: "Amicus Services Inc." <support@geoglobal.com>
To: xfs@oss.sgi.com, vincent.roy@geoglobal.com

I have a AMCC RAID 5 which has been verified without error but cannot mount
 on a SUSE 10.1 OS. Inconsistency on the volume may have occurred during an
 abrupt power shutdown. Not sure if it would be prudent to run XFS_Repair at
 this stage since XFS_check returned info indicating inconsistencies exist.

Please assist in any way you can, thanks.

Vincent Roy
System Admin
403-830-7283

-------------------------------------------------------

--Boundary-00=_8bpBIN2z73RRLKq
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


--Boundary-00=_8bpBIN2z73RRLKq
Content-Type: text/plain;
  charset="iso-8859-1";
  name="xfscheckerror.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfscheckerror.txt"

xfs_check: unexpected XFS SB magic number 0xfab80010
bad superblock magic number fab80010, giving up

--Boundary-00=_8bpBIN2z73RRLKq--
