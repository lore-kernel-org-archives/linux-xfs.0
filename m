Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o230XHaX026943 for <xfs@oss.sgi.com>; Tue, 2 Mar 2010 18:33:17 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB199211DE3
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 16:34:44 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 0RsjfP6X4V0Jo4dV
	for <xfs@oss.sgi.com>; Tue, 02 Mar 2010 16:34:44 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id E00946C263
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 18:34:43 -0600 (CST)
Message-ID: <4B8DAECA.50701@hardwarefreak.com>
Date: Tue, 02 Mar 2010 18:35:22 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Stalled xfs_repair on 100TB filesystem
References: <DD534F7C25BFA14FB18E6D603135D7EA0A11E82ECB@sbapexch05>
In-Reply-To: <DD534F7C25BFA14FB18E6D603135D7EA0A11E82ECB@sbapexch05>
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
To: xfs@oss.sgi.com

Jason Vagalatos put forth on 3/2/2010 11:22 AM:
> Hello,
> On Friday 2/26 I started an xfs_repair on a 100TB filesystem:
> 
> #> nohup xfs_repair -v -l /dev/logfs-sessions/logdev /dev/logfs-sessions/sessions > /root/xfs_repair.out.logfs1.sjc.02262010 &
> 
> I've been monitoring the process with 'top' and tailing the output file from the redirect above.  I believe the repair has "stalled".  When the process was running 'top' showed almost all physical memory consumed and 12.6G of virt memory consumed by xfs_repair.  It made it all the way to Phase 6 and has been sitting at agno = 14 for almost 48 hours.  The memory consumption of xfs_repair has ceased but the process is still "running" and consuming 100% CPU:

Here's how another user solved this xfs_repair "hanging" problem.  I say
"hang" because "stall" didn't return the right Google results.

http://marc.info/?l=linux-xfs&m=120600321509730&w=2

Excerpt:

"In betwenn I created a test filesystem 360GB with 120million inodes on it.
xfs_repair without options is unable to complete. If I run xfs_repair -o
bhash=8192 the repair process terminates normally (the filesystem is
actually ok)."

Unfortunately it appears you'll have to start the repair over again.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
