Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p58InOxd111534 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 13:49:24 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0EA949FDC9
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 11:49:23 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id 2FkAUih8mgXp3eJj for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 11:49:23 -0700 (PDT)
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p58IkNR7001888
	for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 12:46:23 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p58In9wY348520 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 12:49:16 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p58CmxXs000764
	for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 06:48:59 -0600
Message-ID: <4DEFC41A.9070701@linux.vnet.ibm.com>
Date: Wed, 08 Jun 2011 11:48:58 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Port xfstests 145, 161, 175, 176, 185?
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
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Hi all!

During one of my reviews for the punch hole tests patch set it was 
mentioned that it would be helpful to take the xfstests 145, 161, 175, 
176, 185 and modify them such that they can run with out requiring the 
dmapi.  These tests contain some more interesting punch hole tests, but 
they dont normally run unless there is support for dmapi.

I did take a peek at them and I was thinking that if we decide to do 
this, we would probably need to do something like introduce a new set of 
source code that is similar to what is seen under the dmapi folder, but 
modified to use a generic interface instead of the dmapi libraries.  We 
could try to merge them into a single code path, but I think that may 
introduce more complexities than would be desirable.

I just wanted to get a general consensus of how many people would be 
interested in this idea.  Thx all!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
