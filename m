Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3FMVCr3139946 for <xfs@oss.sgi.com>; Sun, 15 Apr 2012 17:31:12 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LKZnVxJRWjGlnzYo for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 15:31:10 -0700 (PDT)
Date: Mon, 16 Apr 2012 08:31:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_check segfault / xfs_repair I/O error
Message-ID: <20120415223106.GU6734@dastard>
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
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
To: Drew Wareham <m3rlin@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Apr 15, 2012 at 11:15:09PM +1000, Drew Wareham wrote:
> Hello Everyone,
> 
> Hopefully this is the correct kind of information to send to this list.
> 
> I have an issue with a large XFS volume (17TB) that mounts, but is not
> readable.  I can view the folder structure on the volume but I can't access
> any of the actual data.  A disk failed in a RAID5 array and while it has
> rebuilt now, it looks like it's caused serious data integrity issues.
> 
> Here is the CentOS release / Kernel version:
>     [root@svr608 ~]# uname -a
>     Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:51 EST 2012
> x86_64 x86_64 x86_64 GNU/Linux
>     [root@svr608 ~]# cat /etc/redhat-release
>     CentOS release 5.8 (Final)
>     [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep installed
>     kmod-xfs.x86_64                            0.4-2
> installed
>     xfsdump.x86_64                             2.2.46-1.el5.centos
> installed
>     xfsprogs.x86_64                            2.9.4-1.el5.centos

Try upgrading xfsprogs to the latest version first. this is rather
old, and the latest versions handle IO errors better...

> But even though the volume mounts, when trying to access data it just gives
> a "Structure needs cleaning" error.
> 
> Running xfs_check and xfs_repair yield the following:
>     [root@svr608 ~]# xfs_check /dev/cciss/c0d2
>     bad agf magic # 0x58418706 in ag 0

Oh, that's bad. 2 bytes of the magic number are corrupt...

>     bad agf version # 0x30002 in ag 0

And the version is completely toast.

>     /usr/sbin/xfs_check: line 28:  5259 Segmentation fault
> xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1
>     [root@svr608 ~]# xfs_repair -n /dev/cciss/c0d2
>     Phase 1 - find and verify superblock...
>     superblock read failed, offset 0, size 524288, ag 0, rval -1
> 
>     fatal error -- Input/output error
> 
> And they leave the following in dmesg:
>     xfs_db[5259]: segfault at 000000000555a134 rip 00000000004070c3 rsp
> 00007fff986bae50 error 4
>     cciss 0000:04:00.0: cciss: c ffff810037e00000 has CHECK CONDITION sense
> key = 0x3

This is clearly a raid array error....

....

> ................
>     Filesystem cciss/c0d2: XFS internal error xfs_da_do_buf(2) at line 2112
> of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8835d9b9
> 
> hpacucli says the array is fine, but it looks like it's corrupted to me.

It's badly corrupted. Try a newer version of check/repair, otherwise
you're in a disaster recovery situation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
