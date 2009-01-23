Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0NFQDpu203348 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 09:26:13 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9973518582BA
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 07:25:29 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 5yJ19uGy3KqYUvDA for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 07:25:29 -0800 (PST)
Message-ID: <4979E167.2040806@sandeen.net>
Date: Fri, 23 Jan 2009 09:25:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Strange fragmentation in nearly empty filesystem
References: <20090123102130.GB8012@doctronic.de>
In-Reply-To: <20090123102130.GB8012@doctronic.de>
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
To: Carsten Oberscheid <oberscheid@doctronic.de>
Cc: xfs@oss.sgi.com

Carsten Oberscheid wrote:
> Hi there,
> 
> I am experiencing my XFS filesystem degrading over time in quite a
> strange and annoying way. Googling "XFS fragmenation" tells me either
> that this does not happen or to use xfs_fsr, which doesn't really help
> me anymore -- see below. I'd appreciate any help on this.
> 
> Background: I am using two VMware virtual machines on my Linux
> desktop. These virtual machines store images of their main memory in
> .vmem files, which are about half a gigabyte in size for each of my
> VMs. The .vmem files are created when starting the VM, written when
> suspending it and read when resuming. I prefer suspendig and resuming
> over shutting down and booting again, so with my VMs these files can
> have a lifetime of several weeks.

I would suggest using xfs_bmap to look at the file layout, it will be
much more informative than filefrag.

I don't know how vmware is writing the files out (I don't use vmware, so
can't test) but I'd suggest looking at xfs_bmap output when it's first
created, and then also when it's first written (but perhaps before it
gets too horribly fragmented).

The first question I'd ask is whether it's a swiss-cheese looking sparse
file with many holes.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
