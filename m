Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D64FE7F72
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 19:41:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7A348F8037
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 17:41:17 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id KVIyhMpRlJEp4SLO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 17:41:13 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	r1Q1fAn3014047 for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 17:41:12 -0800
Message-ID: <512C12B5.3070908@tlinx.org>
Date: Mon, 25 Feb 2013 17:41:09 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: FYI: better workaround for updating 'df' info after 'rm' on xfs-vols
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
To: xfs-oss <xfs@oss.sgi.com>

Some time ago I reported that after I deleted
some large amount of space from one of my xfs volumes,
'df' still showed the original, pre-delete space, though
'du' only showed the expected amount.

Mentioned that I had tried 'sync' to no avail, and had
only found umount/mount to cause the figures to synchronize.

Someone suggested cat [1|3] >/proc/sys/vm/drop_caches.
That works as a 1 time event, but I've found that doing
so only works once/system uptime (if you 'cat' drop_caches'
it retains the last value you put there, and doesn't accept
a new value with fewer bits set than what you echo'd to it
originally (you can change from 1>3, but then not from 3>1 or
(3|1)>0.  So not so useful.

Prob w/unmounting was inuse file descriptors (being exported
by samba to clients being the most likely culprit).

This might not be wise if the FS was actively being written
to for a backup, but temporarily doing a

    mount -o remount,ro /backups && mount -o remount,rw /backups

seemed to do the trick and cause the disk space to update without
me having to stop processes with FD's open on the vol.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
