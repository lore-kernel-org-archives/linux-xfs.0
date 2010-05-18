Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IJQ43P071153 for <xfs@oss.sgi.com>; Tue, 18 May 2010 14:26:05 -0500
Received: from exchange.blackducksoftware.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EBA2357198
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 12:28:21 -0700 (PDT)
Received: from exchange.blackducksoftware.com
	(68.233.172.16.static.rev.colospace.com [68.233.172.16]) by
	cuda.sgi.com with ESMTP id laHyDzNYJRngfb4K for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 12:28:21 -0700 (PDT)
From: Colin Wilson <cwilson@blackducksoftware.com>
Date: Tue, 18 May 2010 15:28:20 -0400
Subject: xfs_repair memory usage and stopping on "Traversing filesystem..."
Message-ID: <00FB97ED-C684-4B81-B623-AB7EBD7B7091@blackducksoftware.com>
Content-Language: en-US
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello all,
	I seem to be having the same problem as Tomasz had in this post to the mailing list: http://oss.sgi.com/archives/xfs/2009-07/msg00082.html .  Eric ultimately suggested running xfs_repair with the '-P' and '-o bhash=1024' flags to get past this problem and described what he thought the underlieing problem was as such:

> "This looks like some of the caching that xfs_repair does is mis-sized,
> and it gets stuck when it's unable to find a slot for a new node to
> cache.  IMHO that's still a bug that I'd like to work out.  If it gets
> stuck this way, it'd probably be better to exit, and suggest a larger
> hash size."

	Currently my file system is ~50 TB in size with ~40TB in use and when I do the repair memory usage ends up between 10 and 11 GB used for most of the check .  The system currently has 12GB of ram not including swap.  Is this expected behavior?  My concern is setting bhash too large and causing xfs_repair to swap for long periods of time.  It already takes a few days to get to Phase 6 in the repair.

	I am currently running Debian Lenny(5.0.4) with xfsprogs 2.9.8 with linux kernel 2.6.26.  I've briefly looked through the change logs for newer version of xfsprogs and noticed that there were a few updates mentioning better memory performance or management  so upgrading to a newer version may be all I need.  Has the bug Eric mentions been fixed in a later version of xfsprogs?  What is your suggestion as to my best course of action to get this xfs-repair to complete in a timely manor without using up all the ram in my system?  Thanks

xfs_info dump:
# xfs_info /u1/
meta-data=/dev/mapper/sangroup-sandisk isize=256    agcount=821, agsize=15258784 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=12514290688, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

--Colin

Colin Wilson
Linux Systems Administrator
T +1.781.810.1331
F +1.781.891.5145
cwilson@blackducksoftware.com
http://www.blackducksoftware.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
