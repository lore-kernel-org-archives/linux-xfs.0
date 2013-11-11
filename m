Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 473947F6B
	for <linux-xfs@oss.sgi.com>; Mon, 11 Nov 2013 11:25:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 20D0930406A
	for <linux-xfs@oss.sgi.com>; Mon, 11 Nov 2013 09:25:38 -0800 (PST)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id 40BIhXglSWVnVd74 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 11 Nov 2013 09:25:36 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1VfvEx-0005YX-5V
	for linux-xfs@oss.sgi.com; Mon, 11 Nov 2013 18:25:31 +0100
Received: from router1.itwm.fhg.de ([131.246.191.250])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 11 Nov 2013 18:25:31 +0100
Received: from bernd.schubert by router1.itwm.fhg.de with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 11 Nov 2013 18:25:31 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: ag selection
Date: Mon, 11 Nov 2013 18:25:13 +0100
Message-ID: <l5r3tf$m0j$1@ger.gmane.org>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi all,

for streaming writes onto a raid6 the current round-robin ag selection 
seems does not seem to be optimal. Writing 4 files from 4 threads into a 
single directory we get 900 MB/s, writing 4 files in 4 different 
directories we only get 700 MB/s (12 disks with with hw megaraid-sas). 
The current round-robin scheme seems to be optimized for linear raid0? 
With small AGs one could also argue, that choosing AGs which are not far 
away from each other (in respect to the number of blocks) also adds more 
parallel disk access for small and medium sized files.

Any objections against a patch to improve the AG selection?


Thanks,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
