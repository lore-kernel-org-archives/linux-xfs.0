Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p08Eel8r008298 for <xfs@oss.sgi.com>; Sat, 8 Jan 2011 08:40:48 -0600
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76D73153AB36
	for <xfs@oss.sgi.com>; Sat,  8 Jan 2011 06:42:57 -0800 (PST)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id BCQ2gA67uZr6URtZ
	for <xfs@oss.sgi.com>; Sat, 08 Jan 2011 06:42:57 -0800 (PST)
Received: by pwj6 with SMTP id 6so3874507pwj.26
	for <xfs@oss.sgi.com>; Sat, 08 Jan 2011 06:42:56 -0800 (PST)
Message-ID: <4D2877EC.1070302@philkarn.net>
Date: Sat, 08 Jan 2011 06:42:52 -0800
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: Re: realtime partition support?
References: <4D2724E0.9020801@philkarn.net>
	<20110108021728.GA28803@dastard>	<4D27E11F.4030607@philkarn.net>
	<4D28043A.20300@hardwarefreak.com>
In-Reply-To: <4D28043A.20300@hardwarefreak.com>
Reply-To: karn@ka9q.net
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On 1/7/11 10:29 PM, Stan Hoeppner wrote:
> Phil Karn put forth on 1/7/2011 9:59 PM:
> 
>> No? I'm having a very hard time getting XFS on rotating SATA drives to
>> come close to Reiser or ext4 when extracting a large tarball (e.g., the
>> Linux source tree) or when doing rm -rf.
> 
> This is because you're not using Dave's delayed logging patch, and
> you've not been reading this list for many months, as it's been
> discussed in detail many times.  See:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/filesystems/xfs-delayed-logging-design.txt;h=96d0df28bed323d5596fc051b0ffb96ed8e3c8df;hb=HEAD

Yes, I am new to the list, and while I did pull down a year of the
archives I certainly haven't read them all.

Thanks to this file pointer and your explanation, I now have a pretty
good idea of what's going on.

Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
