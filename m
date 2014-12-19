Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCF857F3F
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 15:26:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD258304082
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2014 13:26:14 -0800 (PST)
Received: from nihxway5out.hub.nih.gov (nihxway5out.hub.nih.gov
	[128.231.90.113]) by cuda.sgi.com with ESMTP id
	HRQmFBScG5qFwwRf for <xfs@oss.sgi.com>;
	Fri, 19 Dec 2014 13:26:13 -0800 (PST)
From: "Weber, Charles (NIH/NIA/IRP) [E]" <WeberC@grc.nia.nih.gov>
Subject: weird quota issue
Date: Fri, 19 Dec 2014 21:26:12 +0000
Message-ID: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
Content-Language: en-US
Content-ID: <AA68720CD88AD44EB498F7207B9B18C4@mail.nih.gov>
MIME-Version: 1.0
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

HI everyone, long time xfs/quota user with new server and problem
hardware is HP BL460 G7 blade, qlogic fiber channel and 3Par 7200 storage
3 16TB vols exported from 3Par to server via FC. These are thin volumes, but plenty of available backing storage.

Server runs current patched CentOS 6.6
kernel 2.6.32-504.3.3.el6.x86_64
xfsprogs 2.1.1-16.el6
Default mkfs.xfs options for volumes

mount options for logical volumes  home_lv 39TB imap_lv 4.6TB
/dev/mapper/irphome_vg-home_lv on /home type xfs (rw,delaylog,inode64,nobarrier,logbsize=256k,uquota,prjquota)
/dev/mapper/irphome_vg-imap_lv on /mail type xfs (rw,delaylog,inode64,nobarrier,logbsize=256k,uquota,prjquota)

Users are from large AD via winbind set to not enumerate. I saw the bug with xfs_quota report not listing winbind defined user names. Yes this happens to me.
I can assign project quota to smaller volume. xfs_quota will not report it. I cannot assign a project quota to larger volume. I get this error: xfs_quota: cannot set limits: Function not implemented.

xfs_quota -x -c 'report -uh' /mail
User quota on /mail (/dev/mapper/irphome_vg-imap_lv)
                        Blocks
User ID      Used   Soft   Hard Warn/Grace
---------- ---------------------------------
root         2.2G      0      0  00 [------]

[xfs_quota -x -c 'report -uh' /home

nothing is returned

I can set user and project quotas on /mail but cannot see them. I have not tested them yet.
I cannot set user or project quotas on /home.
At one time I could definitely set usr quotas on /home. I did so and verified it worked.

Any ideas what is messed up on the /home volume?



Weber, Charles (NIH/NIA/IRP)
weberc@mail.nih.gov<mailto:weberc@mail.nih.gov>
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
