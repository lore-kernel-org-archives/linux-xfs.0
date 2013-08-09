Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D1597F61
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 09:14:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24F2FAC005
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 07:14:43 -0700 (PDT)
Received: from nihrelayxway4.hub.nih.gov (nihrelayxway4.hub.nih.gov
	[128.231.90.98]) by cuda.sgi.com with ESMTP id DRm6D7vMb0QKDSWO
	for <xfs@oss.sgi.com>; Fri, 09 Aug 2013 07:14:40 -0700 (PDT)
From: "Weber, Charles (NIH/NIA/IRP) [C]" <WeberC@grc.nia.nih.gov>
Subject: prjquota not updating used blocks
Date: Fri, 9 Aug 2013 10:14:21 -0400
Message-ID: <6D3CECD5-FBBF-4946-A0D0-5B0C71E772DD@grc.nia.nih.gov>
MIME-Version: 1.0 (Apple Message framework v1283)
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

CentOS 6.4 
Linux niairpfs1.irp.nia.nih.gov 2.6.32-358.6.2.el6.x86_64 #1 SMP Thu May 16 20:59:36 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
xfsprogs-3.1.1-10.el6_4.1.x86_64
xfsdump-3.0.4-3.el6.x86_64

mount
/dev/mapper/shared1_vg-niairp_lv on /share/niairp type xfs (rw,delaylog,inode64,nobarrier,logbsize=256k,uquota,prjquota)

this is a 63T filesystem
xfs_quota report
Project quota on /share/niairp (/dev/mapper/shared1_vg-niairp_lv)
Project ID   Used   Soft   Hard Warn/Grace   
---------- --------------------------------- 
lbnnas          0      0     1T  00 [------]
lbnnccu         0      0   4.4T  00 [------]
tgb          1.3T      0     2T  00 [------]
apps       106.4G      0   150G  00 [------]
ncts       205.7G      0   250G  00 [------]
lg           1.4T      0    10T  00 [------]

Since initializing a project quota, there is no change in used blocks. When I initialize the block count is correct.  If I re-initialize, the used block count is updated properly. 

I copied 2T last night into the folder referenced by the lg project quota and there is no change in used blocks today.
What have I missed?

Weber, Charles (NIH/NIA/IRP) 
weberc@mail.nih.gov
p: 410-558-8001
c: 443-473-6493
251 Bayview Blvd
Baltimore MD 21224
NCTS performance comments and survey at:
https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
