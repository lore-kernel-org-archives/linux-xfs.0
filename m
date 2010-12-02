Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2EE9hc022179 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 08:14:09 -0600
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F1211405B41
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 06:15:52 -0800 (PST)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id VPu7M0CINZM8zeM8 for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 06:15:52 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUY70IQ3Q8LS7BA9@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Thu, 02 Dec 2010 15:15:00 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUY70FXFGGLS76YD@mx.isti.cnr.it> for xfs@oss.sgi.com; Thu,
	02 Dec 2010 15:14:41 +0100 (MET)
Date: Thu, 02 Dec 2010 15:14:39 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
In-reply-to: <4CF7A539.1050206@shiftmail.org>
Message-id: <4CF7A9CF.2020904@shiftmail.org>
MIME-version: 1.0
References: <4CF7A539.1050206@shiftmail.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Spelic <spelic@shiftmail.org>
Cc: linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Sorry for replying to my own email already
one more thing on the 3rd bug:

On 12/02/2010 02:55 PM, Spelic wrote:
> Hello all
> [CUT]
> .......
> with NFS over <RDMA or IPoIB> over Infiniband over XFS over ramdisk it 
> is possible to write a file (2.3GB) which is larger than

This is also reproducible with:
NFS over TCP over Ethernet over XFS over ramdisk.
You don't need infiniband for this.
With ethernet it doesn't hang (that's another bug, for RDMA people, in 
the othter thread) but the file is still 1.9GB, i.e. larger than the device.


Look, after running the test over ethernet,
at server side:

# ll -h /mnt/ram
total 1.5G
drwxr-xr-x 2 root root   21 2010-12-02 12:54 ./
drwxr-xr-x 3 root root 4.0K 2010-11-29 23:51 ../
-rw-r--r-- 1 root root 1.9G 2010-12-02 15:04 zerofile

# mount
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
/dev/sda1 on / type ext4 (rw,errors=remount-ro)
proc on /proc type proc (rw,noexec,nosuid,nodev)
none on /sys type sysfs (rw,noexec,nosuid,nodev)
none on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
devtmpfs on /dev type devtmpfs (rw,mode=0755)
none on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
none on /dev/shm type tmpfs (rw,nosuid,nodev)
none on /var/run type tmpfs (rw,nosuid,mode=0755)
none on /var/lock type tmpfs (rw,noexec,nosuid,nodev)
none on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
nfsd on /proc/fs/nfsd type nfsd (rw)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc 
(rw,noexec,nosuid,nodev)
/dev/ram0 on /mnt/ram type xfs (rw)

# blockdev --getsize64 /dev/ram0
1610612736

# dd if=/mnt/ram/zerofile | wc -c
1985937408
3878784+0 records in
3878784+0 records out
1985937408 bytes (2.0 GB) copied, 6.57081 s, 302 MB/s

Feel free to forward to NFS mailing list also if you think it's appropriate.
Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
