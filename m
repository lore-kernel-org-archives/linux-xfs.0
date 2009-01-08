Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n080cq4W018666 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 18:38:54 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6547517B971D
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 16:38:47 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id HAQKGvw5aTVnyfIh for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 16:38:47 -0800 (PST)
Date: Thu, 8 Jan 2009 01:38:39 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090108003839.GA466@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185226.GA19010@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107185226.GA19010@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Quoting Christoph Hellwig (hch@infradead.org):
> On Wed, Jan 07, 2009 at 07:44:20PM +0100, Danny ter Haar wrote:
> > Will compile a new kernel in the mean time with those 2 options:
> > CONFIG_XFS_DEBUG & CONFIG_DEBUG_INFO
> 
> Please only with CONFIG_DEBUG_INFO in that case.  CONFIG_XFS_DEBUG would
> be useful if you could reproduce it, but it does change the addresses,
> so it's harmful for the case of getting back to the source line.
> 

Okay, it barfed again:

Let me first explain thati've set the sleeptimer for the storage harddrives
to 24(x5=120 sec) in hdparm.conf:

/dev/sdb {
        spindown_time = 24
        }

/dev/sdc {
        spindown_time = 24
        }

This is the error (snapped using netconsole)

http://www.dth.net/kernel/c3/netconsole_2.6.28-git9d-error.txt

I rebooted again with the git2 kernel and xfs_check gave no errors:

filer1:~# xfs_check /dev/sdb1 
filer1:~# 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
