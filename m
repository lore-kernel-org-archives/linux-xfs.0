Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B9967F63
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 09:26:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E2768F8033
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 07:26:28 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18]) by cuda.sgi.com
	with ESMTP id mHQKzS56VIpApDwb (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 07:26:26 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-74aaa980-3667-4c6d-9e1e-60f3f70dc888-1445005584585@3capp-gmx-bs54>
From: Dragon <Sunghost@gmx.de>
Subject: Re: Error in `xfs_repair': double free or corruption
Date: Fri, 16 Oct 2015 16:26:24 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello Emmanuel,

kernel version is 3.16-0.bpo.2-amd64 and xfsprogs in version 3.2.1 from stable. the question is if xfs_repair can repair a raid which has missed a disk with over 240gb bad blocks.
gretings


    Hello,
    i have a problem after repaired a degraded Softare Raid6. System is
    Debian Jessi and Root and Boot are on Raid1, and Data on Raid6 on md2
    which miss one Disk. The mainproblem was a missing Disk because of
    badblocks which i cloned and exchanged agains a new one. After that i
    could successfully rebuild the raid (md2), while now only one disk is
    midding. But i recognised that xfs reports inode problems. Therefor i
    run xfs_repair on the raid device md2, but get message "Error in
    &#96;xfs_repair': double free or corruption" What can i do the fix
    this? thx 


You didn't provide enough information (kernel and xfs-progs version at
the very least) but you should use the latest version of xfs_repair, the
one included in Debian is probably quite old. Here's one new:

http://update.intellique.com/pub/xfs_repair-4.2.0.gz

Or if you like it better in debian form:
http://update.intellique.com/repository/pool/storiq3/unstable/amd64/xfsprogs_4.2.0+1_amd64.deb


-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
