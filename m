Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3KF6WQA234438 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 10:06:33 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id CCuREEFthlB0Da7W for <xfs@oss.sgi.com>;
	Fri, 20 Apr 2012 08:06:32 -0700 (PDT)
Message-ID: <4F917B77.6040403@sandeen.net>
Date: Fri, 20 Apr 2012 10:06:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_check segfault / xfs_repair I/O error
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
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

On 4/15/12 8:15 AM, Drew Wareham wrote:
> Hello Everyone,
> 
> Hopefully this is the correct kind of information to send to this list.
> 
> I have an issue with a large XFS volume (17TB) that mounts, but is not readable.  I can view the folder structure on the volume but I can't access any of the actual data.  A disk failed in a RAID5 array and while it has rebuilt now, it looks like it's caused serious data integrity issues.
> 
> Here is the CentOS release / Kernel version:
>     [root@svr608 ~]# uname -a
>     Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:51 EST 2012 x86_64 x86_64 x86_64 GNU/Linux
>     [root@svr608 ~]# cat /etc/redhat-release
>     CentOS release 5.8 (Final)
>     [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep installed
>     kmod-xfs.x86_64                            0.4-2                       installed

You reall, Really, REALLY, *REALLY* want to remove kmod-xfs.

RHEL5 has been shipping with supported xfs for what, 2 years now, and that old kmod-xfs
is an ancient, ancient piece of unmaintained, bitrotting code.  Sadly it overrides
the kernel rpm's xfs.ko.  I don't know if this is the root cause of your problem; probably
not, but eventually it will likely be the root cause of some other problem :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
