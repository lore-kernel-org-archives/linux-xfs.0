Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1NGU7wE071135 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 10:30:07 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7472F129B5A6
	for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 08:32:50 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 6TVNjBx9b266arqA for <xfs@oss.sgi.com>;
	Wed, 23 Feb 2011 08:32:50 -0800 (PST)
Message-ID: <4D6536B1.80303@sandeen.net>
Date: Wed, 23 Feb 2011 10:32:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Input/Output error
References: <4D63D9D8.3060204@storegrid.com> <4D641AB1.7010101@sandeen.net>
	<4D64AA28.9050207@storegrid.com>
In-Reply-To: <4D64AA28.9050207@storegrid.com>
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
To: Srinivasan T <srinivasan@storegrid.com>
Cc: xfs@oss.sgi.com

On 2/23/11 12:33 AM, Srinivasan T wrote:
> Hi Eric,
> 
> There is enough disk space in the fs.
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# df -lh
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda1             9.9G  2.9G  6.6G  31% /
> /dev/sdb              147G  188M  140G   1% /mnt
> none                  854M     0  854M   0% /dev/shm
> /dev/sdh              5.0G   25M  5.0G   1% /mymountpoint
> 
> Also, the output of modinfo is as follows,
> 
> [root@domU-12-31-39-07-81-36 StoreGrid]# modinfo xfs
> filename:       /lib/modules/2.6.21.7-2.fc8xen/kernel/fs/xfs/xfs.ko

so a fedora 8 xen kernel on a centos 5.4 machine... you are pretty far
from the supported realm here, I'm afraid.

Can you check your logs for IO errors as dave suggested; otherwise, try
upstream or at -least- an official RHEL5 install.

-Eric

> license:        GPL
> description:    SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
> author:         Silicon Graphics, Inc.
> srcversion:     C7114C18263E3067C64F2BC
> depends:
> vermagic:       2.6.21-2952.fc8xen SMP mod_unload 686 4KSTACKS
> 
> I have installed xfs with yum by using the following command,
> 
> yum install xfsprogs
> 
> I think I have installed the kernel rpm xfs ko. Can you confirm if this is correct.
> 
> Regards,
> Srinivasan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
