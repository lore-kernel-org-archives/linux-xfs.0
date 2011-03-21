Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2LFgl8p209508
	for <linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 10:42:53 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 5D40B1B59967
	for <linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 08:45:45 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with SMTP id skwKQbZ3ceereAYC for <linux-xfs@oss.sgi.com>;
	Mon, 21 Mar 2011 08:45:45 -0700 (PDT)
Message-ID: <4D8772A8.9050201@sandeen.net>
Date: Mon, 21 Mar 2011 10:45:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: umount fails with device is busy
References: <31199414.post@talk.nabble.com>
In-Reply-To: <31199414.post@talk.nabble.com>
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

On 3/21/11 5:53 AM, stress_buster wrote:
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
> 
> i did a force unmount then 
> 
> Quote:
> #umount -l /dev/sda  

that's not really enough.

Checking swap is a good idea, as is looking for loopback mounted
files on the fs...

-Eric

> but then when I try to run xfs_repair
> 
> Quote:
> xfs_repair -n /dev/sda, it 
> xfs_repair: /dev/sda contains a mounted and writable filesystem
> 
> fatal error -- couldn't initialize XFS library  
> 
> lsof /dev/sda
> shows nothing ie nothing seems to be 'touching' the disk.
> makes me wonder whether this is a xfs issue now??
> 
> 
> Any thoughts???
> 
> Thanks 
> David 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
