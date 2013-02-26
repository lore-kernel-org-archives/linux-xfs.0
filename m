Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BD877CBF
	for <linux-xfs@oss.sgi.com>; Tue, 26 Feb 2013 11:30:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11619AC009
	for <linux-xfs@oss.sgi.com>; Tue, 26 Feb 2013 09:30:53 -0800 (PST)
Received: from joe.nabble.com (216-139-250-139.aus.us.siteprotect.com
	[216.139.250.139]) by cuda.sgi.com with ESMTP id
	B9k7ShHUUrqmni4k (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 09:30:51 -0800 (PST)
Received: from tom.nabble.com ([192.168.236.105])
	by joe.nabble.com with esmtp (Exim 4.72)
	(envelope-from <praneethu.u@gmail.com>) id 1UAOMc-0003c2-Hq
	for linux-xfs@oss.sgi.com; Tue, 26 Feb 2013 09:30:50 -0800
Date: Tue, 26 Feb 2013 09:30:50 -0800 (PST)
From: "praneethu.u" <praneethu.u@gmail.com>
Message-ID: <1361899850527-34994.post@n7.nabble.com>
Subject: test case no.256 in xfs test suite, makes gnome 3 to fall back to
	emergency mode
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
To: linux-xfs@oss.sgi.com

I have installed opensuse 12.2 and made 5 different partitions to test xfs
tests. I have followed instruction as provided in 
http://en.opensuse.org/SDB:XFStests <http://en.opensuse.org/SDB:XFStests>  .
After executing test case no.254 i.e.,btrfs snapshot. in the next reboot,
GNOME 3 will not load, instead it falls back to emergency mode. When i tried
to see what is happening, in verbose mode of loading os, i saw scratch
device did not mount and then emergency mode started.
Is this a bug or i am doing any mistake ? please help.



--
View this message in context: http://xfs.9218.n7.nabble.com/test-case-no-256-in-xfs-test-suite-makes-gnome-3-to-fall-back-to-emergency-mode-tp34994.html
Sent from the linux-xfs mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
