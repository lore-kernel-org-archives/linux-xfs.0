Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3EEZg9w261274 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 09:35:42 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6869C164043B
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 07:39:03 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id AElTpgyanYohSHx6 for <xfs@oss.sgi.com>;
	Thu, 14 Apr 2011 07:39:03 -0700 (PDT)
Message-ID: <4DA70706.4050305@sandeen.net>
Date: Thu, 14 Apr 2011 09:39:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <20110414102608.GA1678@x4.trippels.de>
In-Reply-To: <20110414102608.GA1678@x4.trippels.de>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: coreutils@gnu.org, xfs@oss.sgi.com

On 4/14/11 5:26 AM, Markus Trippelsdorf wrote:
> I trashed my system this morning when I installed coreutils-8.11.
> 
> What happened is that coreutils compiles and links correctly, but
> then the following command (during the installation phase):
> 
> ./ginstall chroot hostid nice who users pinky stty df stdbuf [ base64
> basename cat chcon chgrp chmod chown cksum comm cp csplit cut date dd
> dir dircolors dirname du echo env expand expr factor false fmt fold
> head id join link ln logname ls md5sum mkdir mkfifo mknod mktemp mv
> nl nproc nohup od paste pathchk pr printenv printf ptx pwd readlink
> rm rmdir runcon seq sha1sum sha224sum sha256sum sha384sum sha512sum
> shred shuf sleep sort split stat sum sync tac tail tee test timeout
> touch tr true truncate tsort tty uname unexpand uniq unlink vdir wc
> whoami yes arch
> '/var/tmp/portage/sys-apps/coreutils-8.11/image//usr/bin'
> 
> apparently produces files which have the length of the originals but
> are full of zeros. (and these were then installed to my live system,
> thereby trashing it).
> 
> Now all the above is automated, because I use gentoo. But when I run
> the command above (ginstall) later again by hand, everything is
> copied just fine and the resulting binaries are all usable.
> 
> The partition in question uses xfs.
> 
> # xfs_info /var meta-data=/dev/sda1              isize=256
> agcount=4, agsize=12800000 blks =                       sectsz=4096
> attr=2 data     =                       bsize=4096   blocks=51200000,
> imaxpct=25 =                       sunit=0      swidth=0 blks naming
> =version 2              bsize=4096   ascii-ci=0 log      =internal
> bsize=4096   blocks=25000, version=2 =
> sectsz=4096  sunit=1 blks, lazy-count=1 realtime =none
> extsz=4096   blocks=0, rtextents=0
> 
> This is a 4kb hard drive (sectsz=4096).
> 
> I'm running the lastest vanilla git kernel
> (2.6.39-rc3-00087-gda768a4).
> 
> Now my question is, could this be caused by the recent FIEMAP changes
> in coreutils?


Well damn.  Looking into it ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
