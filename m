Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8MtISh160430 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 16:55:19 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56C1C1CF68D5
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 14:55:16 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	psHyfcPLy4qxXGKK for <xfs@oss.sgi.com>;
	Tue, 08 Nov 2011 14:55:16 -0800 (PST)
Date: Wed, 9 Nov 2011 09:55:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: quota mismatch for NFS mount of XFS filesystem
Message-ID: <20111108225513.GO5534@dastard>
References: <CACXvBApxwWUyYNfRL9rS32t7f04XCDwafbR7fSFjmXg8fJRpTg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACXvBApxwWUyYNfRL9rS32t7f04XCDwafbR7fSFjmXg8fJRpTg@mail.gmail.com>
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
To: Liam Forbes <loforbes@alaska.edu>
Cc: xfs@oss.sgi.com

On Tue, Nov 08, 2011 at 09:31:05AM -0900, Liam Forbes wrote:
> I searched the archives, but didn't find anything about incorrect
> quota information for an NFS mounted XFS filesystem.  I hope somebody
> might have an idea.
> 
> We have a RHEL 5.7 server mounting a 15T XFS filesystem and exporting
> it to RHEL 5.6 and 5.7 clients.  quota and xfs_quota on the server
> show a user using ~5.8T, but quota on a client only shows ~1.8T.
> 
> Server:
> nfs2:~$ cat /etc/redhat-release
> Red Hat Enterprise Linux Server release 5.7 (Tikanga)
> nfs2:~$ uname -a
> Linux nfs2 2.6.18-274.3.1.el5 #1 SMP Fri Aug 26 18:49:02 EDT 2011 x86_64 x86_64
> nfs2:~$ rpm -qa | grep xfsprogs
> xfsprogs-2.9.4-1.el5.centos
> nfs2:~$ sudo quota -s -v -u krieger
> Disk quotas for user krieger (uid 3105):
>      Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
> /dev/mapper/primaryfs_vg-primaryfs
>                   5901G       0       0            310k       0       0
> nfs2:~$ sudo /usr/sbin/xfs_quota
> xfs_quota> quota -u -h krieger
> Disk quotas for User krieger (3105)
> Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
> /dev/primaryfs_vg/primaryfs
>                5.8T      0      0  00 [------] /export/wrkdir20
> xfs_quota> quit
> 
> Client:
> pacman1:~$ cat /etc/redhat-release
> Red Hat Enterprise Linux Server release 5.6 (Tikanga)
> pacman1:~$ uname -a
> Linux pacman1 2.6.18-238.19.1.563g0000.el5 #1 SMP Fri Jul 15 20:26:36
> EDT 2011 x86_64 x86_64 x86_64 GNU/Linux
> pacman1:~$ sudo quota -s -v -u krieger
> Disk quotas for user krieger (uid 3105):
>      Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
> nfs2:/export/wrkdir20
>                   1806G       0       0            310k       0       0

That looks like a 32bit variable overflow. In 512 byte blocks
(sectors), 2^32 sectors overflows at 2T. And 5.8T ~= 2T + 2T + 1.8T.

This is most likely to be an NFS issue - I'm not familiar with the
Linux NFS quota protocol implementation, so I can't really say much
more than that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
