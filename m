Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 200AA7F37
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 10:07:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6A3EAC003
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 08:07:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GgV9A9tgoI5cOpnx for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 08:07:48 -0800 (PST)
Message-ID: <530A1CD3.8070204@sandeen.net>
Date: Sun, 23 Feb 2014 10:07:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: gentoo linux, kernel 3.10.31 mount options bug?
References: <9963a76fbd006355c9ffd79f341c9971@zbfmail.de>
In-Reply-To: <9963a76fbd006355c9ffd79f341c9971@zbfmail.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On 2/23/14, 3:37 AM, Marko Weber|8000 wrote:
> 
> 
> hello list,
> 
> i have a question about mount options.
> 
> at first my fstab:
> 
> /dev/md0                /boot           xfs             noauto,noatime  1 2
> /dev/md2                /               xfs             noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep      0 1

I guess I won't ask why you decided to tweak all those knobs...

<snip>

> (YES!, normally i use Label or UUID..... but this is only a test machine.....)
> 
> 
> AFTER reboot "mount" shows this:
> 
> rootfs on / type rootfs (rw)
> /dev/root on / type xfs (rw,noatime,nodiratime,attr2,nobarrier,inode64,noquota)

<snip>

default mount options

> 
> on /dev/root "discrad" and some other are not shown
> 
> 
> when i do a "mount -o remount /"
> 
> "mount" shows this:
> 
> 
> rootfs on / type rootfs (rw)
> /dev/root on / type xfs (rw,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)
> /dev/md1 on /tmp type xfs (rw,noexec,noatime,nodiratime,nobarrier,largeio,discard,logbsize=256k,noikeep)

tweaked options.

<snip>

> 
> now,all options from /etc/fstab are listed.
> Is this XFS related?

Not really.  Only some xfs options are remountable, so unless you originally mounted with, say, "largeio" the option won't be in effect.  Mount -o remount won't enable it.  So if you really want all those options enabled on your root fs, you'll need to have them in your initrd/initramfs so that the original mount of the root fs at boot time includes them.

Also, mount may be looking at /etc/mtab rather than /proc/mounts.  /proc/mounts contains the true state of the fileystem w.r.t. mount options.  /etc/mtab is managed by mount, and knows nothing about what the filesystem actually did:

[root@sandeen ~]# mount -o remount,notanoption /home

[root@sandeen ~]# mount | grep home
/dev/md2 on /home type xfs (rw,notanoption)

[root@sandeen ~]# grep home /proc/mounts
/dev/md2 /home xfs rw,seclabel,relatime,attr2,delaylog,noquota 0 0

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
