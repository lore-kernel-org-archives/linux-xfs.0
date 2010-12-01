Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1ErMMD217074 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 08:53:23 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F22CB16071C5
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 06:55:04 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id 9kPCTeEBnCjprria for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 06:55:04 -0800 (PST)
Message-ID: <4CF661C7.2020103@sandeen.net>
Date: Wed, 01 Dec 2010 08:55:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS file system corruption(Return Bad Transaction) kernel - 2.6.34
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
In-Reply-To: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: sandeen-xfs@sandeen.net, xfs@oss.sgi.com

On 12/1/10 1:14 AM, Amit Sahrawat wrote:
> Dear Member,
>  
> I am getting following corruption on XFS formatted disk during a simple copy operation:
> sd 9:0:0:0: Attached scsi removable disk sdc
> sd 9:0:0:0: Attached scsi generic sg2 type 0
> XFS mounting filesystem sdc2
> Starting XFS recovery on filesystem: sdc2 (logdev: internal)
> XFS: xlog_recover_process_data: bad transaction
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed

hm, that's not a simple copy operation, that is a mount failing;
your log appears to be corrupted.

offhand I'm going to blame it on having a write cache enabled
on your drive, and having barriers either off, or not working
properly.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
