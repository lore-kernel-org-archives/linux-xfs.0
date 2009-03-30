Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UAUXf3190174 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 05:30:44 -0500
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E24F313DAB2A
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 03:30:51 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com
	[87.194.172.100]) by cuda.sgi.com with ESMTP id
	tZfqI9yIIYUTfOkX for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2009 03:30:51 -0700 (PDT)
Received: from kennet.dsl.local ([10.0.0.11])
	by knox.decisionsoft.com with esmtp (Exim 4.69)
	(envelope-from <strr-debian@decisionsoft.co.uk>) id 1LoEkm-000513-Rj
	for xfs@oss.sgi.com; Mon, 30 Mar 2009 11:30:04 +0100
Message-ID: <49D09F2C.8060406@decisionsoft.co.uk>
Date: Mon, 30 Mar 2009 11:30:04 +0100
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
MIME-Version: 1.0
Subject: xfs_freeze -f misbehaving under lenny / xfsprogs 2.9.8
Reply-To: strr-debian@decisionsoft.co.uk
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

Hi,

We have a backup script running on another machine that ssh's in to the 
affected server and does the following:
mkdir -p /tmp/foo;
/usr/sbin/xfs_freeze -f /home;
/sbin/lvcreate -s -L 20G -n snap-shot home ;
/usr/sbin/xfs_freeze -u /home;
mount -o nouuid,ro /dev/data/snap-shot /tmp/foo;

It then rsyncs (over ssh) the data to the backup store from /tmp/foo

The above command set hangs at running "/sbin/lvcreate -s -L 20G -n 
snap-shot home;"

All I/O to /home is of course blocked at this point so for example exim 
starts queueing up all the mail.

As soon as I manually log in some hours later and run /usr/sbin/xfs_freeze 
-u /home; ... the lvcreate succeeds, the backup runs etc.


We recently upgraded this server to lenny from etch. It is still using the 
same kernel as it did with etch. The kernel is 2.6.26-bpo.1-amd64.

So this has never happened before and it occurring directly coincides with 
my upgrade to lenny on Friday.

The error occurred on Friday night
Backup proceeded normally on Saturday night
The error occurred on Sunday night
This suggests to me that there's some sort of race going on?

Previous version of xfsprogs (using etch): 2.8.11-1
Current version of xfsprogs (using lenny): 2.9.8-1lenny1

Anyone have any thoughts / is this a known issue with the 2.9.8 release?

Kind regards,
Stu.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
