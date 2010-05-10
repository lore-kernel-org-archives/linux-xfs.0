Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AE47oa004985 for <xfs@oss.sgi.com>; Mon, 10 May 2010 09:04:07 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97E5D1DEA155
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 07:06:19 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id lyFs2uyQ7BXQskFa
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 07:06:19 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id CD2AA6C24B
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 09:06:18 -0500 (CDT)
Message-ID: <4BE81368.4030209@hardwarefreak.com>
Date: Mon, 10 May 2010 09:08:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
References: <20100510022033.GB7165@dastard> <4BE7AD82.90300@gmail.com>
	<23944308.20100510122203@kaneda.iguw.tuwien.ac.at>
In-Reply-To: <23944308.20100510122203@kaneda.iguw.tuwien.ac.at>
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

Rainer Fuegenstein put forth on 5/10/2010 5:22 AM:
> mark,
> 
> yes, thank you, that looks very much like it. CentOS is still at 5.4,
> version 5.5 is long overdue :-(

Hi Rainer,

You don't have to wait for the next CentOS release.  Just grab the source
for the latest stable kernel from kernel.org and roll your own.  I've been
doing so for years with Debian stable in order to avoid problems such as
this one you've run into (that and security holes being plugged).

I'm running xfsprogs 2.9.8-1lenny1 that shipped with kernel 2.6.26 on top of
kernel 2.6.32.9 and haven't had any problems.  At least, none so far with
mkfs.xfs, mount, xfs_db, or xfs_fsr.  I've not had a need for xfs_check,
xfs_repair, or other xfs utils.  My point being that older xfs tools seem to
work fine atop newer kernels.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
