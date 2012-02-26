Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1Q7MVnK215891 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 01:22:31 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id rIjLYzb6yNyNVTKw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Feb 2012 23:22:29 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1S1YRB-0005uz-Bn
	for xfs@oss.sgi.com; Sat, 25 Feb 2012 23:22:29 -0800
Message-ID: <33393429.post@talk.nabble.com>
Date: Sat, 25 Feb 2012 23:22:29 -0800 (PST)
From: MikeJeezy <forums@mgaccess.net>
Subject: Re: mount: Structure needs cleaning
In-Reply-To: <4F49B693.4080309@hardwarefreak.com>
MIME-Version: 1.0
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
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



On 02/25/2012 10:35pm, Stan Hoeppner wrote:
>Can you run xfs_check on the filesystem to determine if a freespace
>tree is corrupted (post the output if it is), then run xfs_repair
>to rebuild them?"

Thank you for responding.  This is a 24/7 production server and I did not
anticipate getting a response this late on a Saturday, so I panicked quite
frankly, and went ahead and ran "xfs_repair -L" on both volumes.  I can now
mount the volumes and everything looks okay as far as I can tell.  There
were only 2 files in the "lost+found" directory after the repair.  Does that
mean only two files were lost?  Is there any way to tell how many files were
lost?

>This corruption could have happened a long time ago in the past, and
>it may simply be coincidental that you've tripped over this at
>roughly the same time you upgraded the kernel.

It would be nice to find out why this happened.  I suspect it is as you
suggested, previous corruption and not a hardware issue, because I have
other volumes mounted to other VM's that are attached to the same SAN
controller / RAID6 Array... and they did not have any issues - only this one
VM.

>So, run "xfs_check /dev/sde1" and post the output here.  Then await
>further instructions.  

Can I still do this (or anything) to help uncover any causes or is it too
late?  I have also run yum update on the server because it was out of date.
-- 
View this message in context: http://old.nabble.com/mount%3A-Structure-needs-cleaning-tp33393100p33393429.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
