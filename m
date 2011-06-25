Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5PH3fZ4128953
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 12:03:45 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49C7A15E7609
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 10:03:39 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id QMdaoXa1FlnY3tEl for <linux-xfs@oss.sgi.com>;
	Sat, 25 Jun 2011 10:03:39 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QaWGe-0005Pz-9I
	for linux-xfs@oss.sgi.com; Sat, 25 Jun 2011 19:03:36 +0200
Received: from s0106000acd1d509c.du.shawcable.net ([70.67.174.161])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 19:03:36 +0200
Received: from prad by s0106000acd1d509c.du.shawcable.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 19:03:36 +0200
From: prad <prad@towardsfreedom.com>
Subject: xfsrestore seems to hang
Date: Sat, 25 Jun 2011 09:59:38 -0700
Message-ID: <87oc1ln8xx.fsf@psinom.home>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

this seems to be a new development.

in the past, i've xfsdumped my home directory as home.xfs in a separate
partition on the same drive and have extracted a specific file without
any difficulties.

now i'm trying to do the same thing on an external usb drive which has
the xfs filesystem on it.

i can xfsdump to it no problem.

then i try to restore:
1. cd into the directory /media/f6.....
2. mkdir tmp
3. xfsrestore -i -f home.xfs tmp/
4. ls and cd to the right place - all work just fine
5. add the file i want to extract
6. extract

things seem to be working:

 -> ls 
        77766469 kyron/
             131 pradmin/

 -> cd pradmin/Public

 -> ls
      1766125579 ipflush.sh 
      1766125536 iptables.sh 

 -> add ipflush.sh

 -> ls
    * 1766125579 ipflush.sh 
      1766125536 iptables.sh 

 -> extract

 --------------------------------- end dialog ---------------------------------

xfsrestore: restoring non-directory files


but it just hangs on the last line and we wait and wait and wait.

top shows that xfsrestore is using 3% of cpu so something is happening
supposedly, but i don't know what.

inside tmp there are the usual directories:
orphanage and xfsrestorehousekeepingdir
but they don't want to go away (orphanage is empty) because the thing
doesn't finish.

i tried the same thing with a -V5, but the only difference seemed to be
hanging on:
xfsrestore:general: restoring non-directory files

are there error logfiles somewhere?
how can i troubleshoot this problem?

-- 
in friendship,
prad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
