Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n77BcbX5129004 for <xfs@oss.sgi.com>; Fri, 7 Aug 2009 06:38:37 -0500
Received: from essen024.server4you.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE4B63B193E
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2009 04:39:27 -0700 (PDT)
Received: from essen024.server4you.de (essen024.server4you.de
	[217.172.182.24]) by cuda.sgi.com with ESMTP id
	tvElPlh8C4hEufob for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2009 04:39:27 -0700 (PDT)
Message-ID: <4A7C1265.5020909@zmensch.de>
Date: Fri, 07 Aug 2009 13:39:17 +0200
From: Zoran Cvetkovic <Zoran.Cvetkovic@zmensch.de>
MIME-Version: 1.0
Subject: corrupt dinode but xfs_check and xfs_repair are bit detecting any
	problem and are fixing nothing.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Fellows,

I am running a 2.6.26 kernel on debian lenny having a 6 TB data 
partition under xfs, 2.6 TB are in use now.
xfs fs is exported via nfs from that box.

after 12 weeks of popper service suddenly nfs performance was a disaster 
and the box was stuttering, system load was about 10.
There was no indication  for a  hardware problem. HW Raid status was *OK*

/var/log/messages lists several thousand lines like:

Aug 6 21:12:03 nfsserver kernel: [7660448.840139] Filesystem "sdb1": 
corrupt dinode 4806258, (btree extents). Unmount and run xfs_repair.

(allways the same dinode #)

after stopping nfsd and unmounting the fs

both xfs_check and xfs_repaier did not detect any corruption!

back in service i got the same problem and log lines.

So what is wrong here?

There might be a fs issue and the fs utilitys are not able to detect it ?

I did a metadata dump of that fs and could  post it, would this help to 
determine what is going wrong here?

Regards,
Zoran Cvetkovic

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
