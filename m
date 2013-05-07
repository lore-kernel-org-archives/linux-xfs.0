Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F5E929DF8
	for <linux-xfs@oss.sgi.com>; Tue,  7 May 2013 06:18:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 014EF304067
	for <linux-xfs@oss.sgi.com>; Tue,  7 May 2013 04:18:19 -0700 (PDT)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id a6FL5FlRafgyIFAD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Tue, 07 May 2013 04:18:17 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	r47BIF5Y003020
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Tue, 7 May 2013 13:18:15 +0200
Message-ID: <5188E2F5.1090304@itwm.fraunhofer.de>
Date: Tue, 07 May 2013 13:18:13 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: 3.9.0: general protection fault
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
In-Reply-To: <20130507011254.GP19978@dastard>
Content-Type: multipart/mixed; boundary="------------060509090104050902070601"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060509090104050902070601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/07/2013 03:12 AM, Dave Chinner wrote:
> On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
>> On 05/06/2013 02:28 PM, Dave Chinner wrote:
>>> On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
>>>> And anpther protection fault, this time with 3.9.0. Always happens
>>>> on one of the servers. Its ECC memory, so I don't suspect a faulty
>>>> memory bank. Going to fsck now-
>>>
>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>>
>> Isn't that a bit overhead? And I can't provide /proc/meminfo and
>> others, as this issue causes a kernel panic a few traces later.
>
> Provide what information you can.  Without knowing a single thing
> about your hardware, storage config and workload, I can't help you
> at all. You're asking me to find a needle in a haystack blindfolded
> and with both hands tied behind my back....

I see that xfs_info, meminfo, etc are useful, but /proc/mounts? Maybe 
you want "cat /proc/mounts | grep xfs"?. Attached is the output of 
/proc/mounts, please let me know if you were really interested in all of 
that non-xfs output?

And I just wonder what you are going to do with the information about 
the hardware. So it is an Areca hw-raid5 device with 9 disks. But does 
this help? It doesn't tell if one of the disks reads/writes with hickups 
or provides any performance characteristics at all.


>
> Stuff like /proc/meminfo doesn't have to be provided from exactly
> the time of the crash - it's just the simplest way to find out how
> much RAM you have in the machine, so a dump from whenever the
> machine is up and running the workload is fine. Other information we
> ask for (e.g. capturing the output of `vmstat 5` as suggested in the
> FAQ) gives us the runtime variation of memory usage and easy to
> capture right up to the failure point...

I have started collectl now, it logs meminfo and other useful 
information. But still with all of that, are you sure xfs debugging 
information wouldn't be more useful? For example setting a
"#define debug" in xfs_trans_ail.c?


Cheers,
Bernd





--------------060509090104050902070601
Content-Type: text/plain; charset=UTF-8;
 name="mounts.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mounts.txt"

rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=3482172k,nr_inodes=870543,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,relatime,size=1406060k,mode=755 0 0
192.168.40.150:/chroots/squeeze64 / nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=7,retrans=10,sec=sys,local_lock=all,addr=192.168.40.150 0 0
tmpfs /tmp tmpfs rw,relatime 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=755 0 0
172.18.25.3://scratch/unionfs/groups/squeeze /unionfs/group nfs rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=600,retrans=2,sec=sys,mountaddr=172.18.25.3,mountvers=3,mountport=52204,mountproto=tcp,local_lock=all,addr=172.18.25.3 0 0
172.18.25.3://scratch/unionfs/hosts/192.168.40.112 /unionfs/host nfs rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=600,retrans=2,sec=sys,mountaddr=172.18.25.3,mountvers=3,mountport=52204,mountproto=tcp,local_lock=all,addr=172.18.25.3 0 0
192.168.40.150:/chroots/squeeze64/root /unionfs/common/root nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=7,retrans=10,sec=sys,local_lock=all,addr=192.168.40.150 0 0
unionfs-fuse /unionfs/union/root fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
unionfs-fuse /root fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
192.168.40.150:/chroots/squeeze64/etc /unionfs/common/etc nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=7,retrans=10,sec=sys,local_lock=all,addr=192.168.40.150 0 0
unionfs-fuse /unionfs/union/etc fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
unionfs-fuse /etc fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
192.168.40.150:/chroots/squeeze64/var /unionfs/common/var nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=7,retrans=10,sec=sys,local_lock=all,addr=192.168.40.150 0 0
unionfs-fuse /unionfs/union/var fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
unionfs-fuse /var fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
192.168.40.150:/chroots/squeeze64/opt /unionfs/common/opt nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=7,retrans=10,sec=sys,local_lock=all,addr=192.168.40.150 0 0
unionfs-fuse /unionfs/union/opt fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
unionfs-fuse /opt fuse.unionfs-fuse rw,relatime,user_id=0,group_id=0,default_permissions,allow_other 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
/dev/sdc /data/fhgfs/meta ext4 rw,relatime,journal_checksum,journal_async_commit,nobarrier,data=writeback 0 0
/dev/sdb /data/fhgfs/storage1 xfs rw,relatime,attr2,inode64,logbsize=128k,sunit=256,swidth=2048,noquota 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
fsdevel3:/home/schubert/src /home/schubert/src fuse.sshfs rw,nosuid,nodev,relatime,user_id=5741,group_id=2130,allow_other,max_read=65536 0 0


--------------060509090104050902070601
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------060509090104050902070601--
