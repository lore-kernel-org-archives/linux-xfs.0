Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Nov 2006 15:40:22 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA6NeBaG021842
	for <xfs@oss.sgi.com>; Mon, 6 Nov 2006 15:40:14 -0800
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7700B50E119
	for <xfs@oss.sgi.com>; Mon,  6 Nov 2006 15:39:25 -0800 (PST)
Message-ID: <454FC5C3.8080803@agami.com>
Date: Mon, 06 Nov 2006 15:31:15 -0800
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: Weird performance decrease
References: <200611061028.08963.sgi@linuxhowtos.org>
In-Reply-To: <200611061028.08963.sgi@linuxhowtos.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sascha Nitsch <sgi@linuxhowtos.org>
Cc: xfs@oss.sgi.com

Hi Sascha,
                  Did you notice the iostat -x on the device ? Please 
verify the turnaround time of the device when you are getting the slowdown.

For example, if %b is closer towards 100, perhaps you are maxing out on 
the disk I/O ops per sec.
Since you have only one disk, once I/O becomes random, the disk wouldn't 
be able to do more than 200-250 disk ops per sec.

# iostat -x sda 1
                             extended device statistics
device mgr/s mgw/s    r/s    w/s    kr/s    kw/s   size queue   wait 
svc_t  %b
sda        3     7    3.5   18.5   157.0   112.9   12.3   0.2    9.7   
1.7   4


Regards,
Shailendra

Sascha Nitsch wrote:
> Hi,
>
> I'm observing a rather strange behaviour of the filesystem cache algorithm.
>
> I have a server running the following app scenario:
>
> A filesystem tree with a depth of 7 directories and 4 character directory 
> names.
> In the deepest directories are files.
> filesize from 100 bytes to 5kb.
> Filesystem is XFS.
>
> The app creates dirs in the tree and reads/writes files into the deepest dirs 
> in the tree.
>
> CPU: Dual Xeon 3.0 Ghz w/HT 512KB cache each, 2GB RAM, SCSI-HDD 15k RPM
>
> The first while, all is fine and extremely fast. After a while the buffer size 
> is about 3.5 MB
> and cache size about 618 MB.
> Until that moment ~445000 directories and ~106000 files have been created
>
> Thats where the weird behaviour starts.
>
> The buffer size drops to ~200 kb and cache size starts decreasing fast.
> This results in a drastic performace drop in my app.
> (avg. read/write times increase from 0.3ms to 4ms)
> not a constant increase, a jumping increase. During the next while it 
> constantly gets slower (19ms and more).
>
> After running a while (with still reducing cache size) the buffer size stays 
> at
> ~700kb and cache about 400 MB. Performane is terrible. Way slower than 
> starting up with no cache.
>
> restarting the app makes no change, neither remounting the partition.
>
> cmd to create the fs:
> mkfs.xfs -b size=512 -i maxpct=0 -l version=2 -n size=16k /dev/sdc
> mounting with
> mount /dev/sdc /data
>
> I'm open for suggestion on mkfs calls, mount options and kernel tuning via 
> procfs.
> I have a testcase to reproduce the problem. It happens after ~45 minutes.
>
> xfs_info /data/
> meta-data=/data                  isize=256    agcount=16, agsize=8960921 blks
>          =                       sectsz=512
> data     =                       bsize=512    blocks=143374736, imaxpct=0
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=16384
> log      =internal               bsize=512    blocks=65536, version=2
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
>
> kernel:
> a 2.6.9-34.0.2.ELsmp #1 SMP Mon Jul 17 21:41:41 CDT 2006 i686 i686 i386 
> GNU/Linux
>
> filesystem usage is < 1%
>
>
>   
