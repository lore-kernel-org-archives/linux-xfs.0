Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52ATBSM091152 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 05:29:11 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 016721B419A0
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 03:29:19 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[83.64.48.195]) by cuda.sgi.com with ESMTP id NSyuUhuko8lR31VM
	for <xfs@oss.sgi.com>; Tue, 02 Jun 2009 03:29:19 -0700 (PDT)
Message-ID: <4A24FEF9.6050309@dermichi.com>
Date: Tue, 02 Jun 2009 12:29:13 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: regarding the inode64 mount option
References: <4A1E81D8.7010706@dermichi.com>	<20090528145612.GA14684@infradead.org>
	<4A1EAB31.7090604@sandeen.net>
In-Reply-To: <4A1EAB31.7090604@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Eric + Christoph!
> http://sandeen.net/wordpress/?p=9
This is a scary list indeed! Does this apply only to Fedora on i686 or also to x86_64?

In general, does the inode64 option make sense at all on a partition that is <1TB in size?

> Actually they should still be accessible, we just won't create new
> inodes not addressable by 32bit inode numbers.
Well, in my tests it didn't work. I tried this is on fedora core 6 with vanilla kernel 2.6.28.10 x86_64. See here:
(when mounted without inode64)
[root@mojave ~]# ls /backup/ -lha
ls: cannot access /backup/mojave_gentoo_backup: Invalid argument
total 8.0K
drwxr-xr-x  6 root         root   99 2009-05-25 18:07 .
drwxr-xr-x 26 root         root 4.0K 2009-05-28 17:38 ..
drwxr-xr-x  4 amandabackup disk   51 2009-05-07 15:46 amanda_holdings
??????????  ? ?            ?       ?                ? mojave_gentoo_backup
drwx--x--x  4 root         root   41 2009-04-29 11:57 servers
drwxrwxrwt  2 root         root    6 2009-06-02 10:38 tmp
[root@mojave ~]# ls /backup/mojave_gentoo_backup -lha
ls: cannot access /backup/mojave_gentoo_backup: Invalid argument
[root@mojave ~]#

(when mounted with inode64)
[root@mojave ~]# ls /backup/ -lha
total 12K
drwxr-xr-x  6 root         root   99 2009-05-25 18:07 .
drwxr-xr-x 26 root         root 4.0K 2009-05-28 17:38 ..
drwxr-xr-x  4 amandabackup disk   51 2009-05-07 15:46 amanda_holdings
drwxr-xr-x 23 root         root 4.0K 2009-05-05 10:53 mojave_gentoo_backup
drwx--x--x  4 root         root   41 2009-04-29 11:57 servers
drwxrwxrwt  2 root         root    6 2009-06-02 10:38 tmp
[root@mojave ~]# ls /backup/mojave_gentoo_backup/ -lha
total 27M
drwxr-xr-x 23 root root 4.0K 2009-05-05 10:53 .
drwxr-xr-x  6 root root   99 2009-05-25 18:07 ..
drwxr-xr-x  2 root root   10 2009-05-05 11:53 backup
(snipped)

The filesystem is consistent - xfs_check (3.0.1) doesn't report any problems.

thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
