Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2LBQfNv199706
	for <linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 06:26:46 -0500
Received: from a.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B19F013EB93E
	for <linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 04:29:29 -0700 (PDT)
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id hm0yEfTlo1ldF3t1 for
	<linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 04:29:29 -0700 (PDT)
Subject: Re: umount fails with device is busy
Mime-Version: 1.0 (Apple Message framework v1082)
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <31199414.post@talk.nabble.com>
Date: Mon, 21 Mar 2011 11:29:26 +0000
Message-Id: <0D795CD6-BA0B-4A54-9F07-9146908FD08E@filmlight.ltd.uk>
References: <31199414.post@talk.nabble.com>
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
To: stress_buster <leo1783@yahoo.com>
Cc: linux-xfs@oss.sgi.com

> 
> I'm trying to run xfs_repair on my filesystem:
> Firstly to unmount the fs
> 
> Quote:
> umount /myfs
> umount: /myfs: device is busy
> umount: /myfs: device is busy  
> 
> Quote:
> lsof /dev/sda  
> 
> -show none ie nothing seems to be 'touching' the disk.
> confused why its still showing device is busy

Are you swapping to it ?
# cat /proc/ swaps

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
