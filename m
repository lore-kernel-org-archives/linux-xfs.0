Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK95BfE132905 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 03:05:11 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2lE3AENZpx4DWMLR for <xfs@oss.sgi.com>;
	Tue, 20 Nov 2012 01:07:19 -0800 (PST)
Date: Tue, 20 Nov 2012 20:07:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Available space after enable quota in XFS
Message-ID: <20121120090716.GA2591@dastard>
References: <CAJaOQm8YscpdtFcMvU68VuiNH7eOYDsgY5wTTpUX=A_XDk5HCw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJaOQm8YscpdtFcMvU68VuiNH7eOYDsgY5wTTpUX=A_XDk5HCw@mail.gmail.com>
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
To: "geturmaddy@gmail.com" <geturmaddy@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 20, 2012 at 12:16:32PM +0530, geturmaddy@gmail.com wrote:
> Hi all,
> I am trying to evaluation XFS for NFS server. We need to configure
> directory level quota in order to better manage storage in the server. I
> came to know that, we can use project quota which looks similar to
> directory level quotas.
> 
> I was able to configure project level quota for XFS file system in my
> Cent)S 5.7 machine. Below are the details
> 
> [root@linux-nfs ~]# cat  /etc/issue
> CentOS release 5.6 (Final)
> Kernel \r on an \m
> 
> [root@linux-nfs ~]# cat /etc/projects
> 13:/das/myproject1
> 
> [root@linux-nfs ~]# cat /etc/projid
> myproject1:13
> 
> [root@linux-nfs ~]# xfs_quota -xc 'report -p' /das
> Project quota on /das (/dev/cciss/c0d0)
>                                Blocks
> Project ID       Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> myproject1          0          0     102400     00 [--------]
> 
> You can see the hard limit set to 1G. But, when i check directory space
> using df -h command. its showing entire file system space in "Avail" column.
> 
> [root@linux-nfs ~]# df -h /das/myproject1/
> Filesystem            Size  Used *Avail *Use% Mounted on
> /dev/cciss/c0d0       100M     0   *13T   *0% /das

Your kernel is too old to support project quotas showing up properly
in df output.

A current kernel shows:

$ sudo xfs_quota -x -c 'project -s -p /mnt/scratch/foo 42' /mnt/scratch
Setting up project 42 (path /mnt/scratch/foo)...
Processed 1 (/etc/projects and cmdline) paths for project 42 with recursion depth infinite (-1).
$ sudo xfs_quota -x -c 'limit -p bhard=1g 42' /mnt/scratch
$ sudo dd if=/dev/zero of=/mnt/scratch/foo/bar bs=1024k count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.133275 s, 787 MB/s
$ sync
$ $ df -h /mnt/scratch /mnt/scratch/foo
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb         11G  133M   11G   2% /mnt/scratch
/dev/vdb        1.0G  100M  924M  10% /mnt/scratch

Which is exactly what you are asking for. Solution: upgrade.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
