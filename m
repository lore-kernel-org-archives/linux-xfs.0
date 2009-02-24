Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OMlAhs170690
	for <linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 16:47:11 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F86B199AA23
	for <linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:46:39 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id 3osOpN8Br5UTENop
	for <linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 14:46:39 -0800 (PST)
Date: Wed, 25 Feb 2009 09:46:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
Message-ID: <20090224224636.GF26138@disturbed>
References: <1235480661.17293.28.camel@disciplina.fs3.ph>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1235480661.17293.28.camel@disciplina.fs3.ph>
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
To: Federico Sevilla III <jijo@fs3.ph>
Cc: Linux XFS <linux-xfs@oss.sgi.com>

[please don't reply to year old message threads with a new problem]

On Tue, Feb 24, 2009 at 09:04:21PM +0800, Federico Sevilla III wrote:
> Hi,
> 
> Recently, we had two file servers crash during periods of increased load
> (increased access from workstations in the LAN). After the crash, the
> XFS file systems would no longer mount. The mount process would just
> stay in state D, with no progress, and no significant disk activity.

What was the cause of the crash?

....

> On one of the servers now, on the same file system that had trouble, we
> are having the following messages (the system otherwise remains usable,
> though, which is weird):
> 
>         attempt to access beyond end of device
>         sda7: rw=0, want=154858897362229008, limit=3885978852
>         I/O error in filesystem ("sda7") meta-data dev sda7 block 0x2262b58bf959708       ("xfs_trans_read_buf") error 5 buf count 4096

A corrupted extent pointer of some kind. xfs_repair should have
found this. Can you run xfs_repair again? If it doesn't find
anything, please upgrade xfs_repair to the latest version and
try again.

> Both servers use CentOS5 with the Linux 2.6.18-92.1.22.el5 kernel. For

Oh. XFS is not really supported on that platform because it is pretty much
completely untested on RHEL based kernels.

> Please help me understand what the cause of this problem could be.

Could be anything. Knowing what caused you systems to crash in the
first place would be handy....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
