Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 24E2E7F66
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 22:11:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1348D304048
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:11:49 -0700 (PDT)
Received: from mail02.lsn.net (mail02.lsn.net [66.90.130.128]) by cuda.sgi.com
	with ESMTP id bigOQlrixdHdiAjr for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 20:11:47 -0700 (PDT)
Message-ID: <540FC135.8010601@mygrande.net>
Date: Tue, 09 Sep 2014 22:10:45 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>
	<20140909220645.GH20518@dastard>	<540FA586.9090308@mygrande.net>
	<20140910015331.GJ20518@dastard>
In-Reply-To: <20140910015331.GJ20518@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/9/2014 8:53 PM, Dave Chinner wrote:
> On Tue, Sep 09, 2014 at 08:12:38PM -0500, Leslie Rhorer wrote:
>> On 9/9/2014 5:06 PM, Dave Chinner wrote:
>>> Fristly, more infomration is required, namely versions and actual
>>> error messages:
>>
>> 	Indubitably:
>>
>> RAID-Server:/# xfs_repair -V
>> xfs_repair version 3.1.7
>> RAID-Server:/# uname -r
>> 3.2.0-4-amd64
>
> Ok, so a relatively old xfs_repair. That's important - read on....

	OK, a good reason is a good reason.

>> 4.0 GHz FX-8350 eight core processor
>>
>> RAID-Server:/# cat /proc/meminfo /proc/mounts /proc/partitions
>> MemTotal:        8099916 kB
> ....
>> /dev/md0 /RAID xfs
>> rw,relatime,attr2,delaylog,sunit=2048,swidth=12288,noquota 0 0
>
> FWIW, you don't need sunit=2048,swidth=12288 in the mount options -
> they are stored on disk and the mount options are only necessray to
> change the on-disk values.

	They aren't.  Those were created automatically, weather at creation 
time or at mount time, I don't know, but the filesystem was created with

mkfs.xfs /dev/md0

and fstab contains:

/dev/md0  /RAID  xfs  rw  1  2

>> 	Six of the drives are 4T spindles (a mixture of makes and models).
>> The three drives comprising MD10 are WD 1.5T green drives.  These
>> are in place to take over the function of one of the kicked 4T
>> drives.  Md1, 2, and 3 are not data drives and are not suffering any
>> issue.
>
> Ok, that's creative. But when you need another drive in the array
> and you don't have the right spares.... ;)

	Yes, but I wasn't really expecting to need 3 spares this soon or 
suddenly.  These are fairly new drives, and with 33% of the array being 
parity, the sudden need for 3 extra drives just is not too likely. 
That, plus I have quite a few 1.5 and 1.0T drives lying around in case 
of sudden emergency.  This isn't the first time I've replaced a single 
drive temporarily with a RAID0.  The performance is actually better, of 
course, and for the 3 or 4 days it takes to get a new drive, it's really 
not an issue.  Since I have a full online backup system plus a regularly 
updated off-site backup, the risk is quite minimal.  This is an exercise 
in mild inconvenience, not an emergency failure.  If this were a 
commercial system, it would be another matter, but I know for a fact 
there are a very large number of home NAS solutions in place that are 
less robust than this one.  I personally know quite a few people who 
never do backups, at all.

>> 	I'm not sure what is meant by "write cache status" in this context.
>> The machine has been rebooted more than once during recovery and the
>> FS has been umounted and xfs_repair run several times.
>
> Start here and read the next few entries:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_problem_with_the_write_cache_on_journaled_filesystems.3F

	I knew that, but I still don't see the relevance in this context. 
There is no battery backup on the drive controller or the drives, and 
the drives have all been powered down and back up several times. 
Anything in any cache right now would be from some operation in the last 
few minutes, not four days ago.

>> 	I don't know for what the acronym BBWC stands.
>
> "battery backed write cache". If you're not using a hardware RAID
> controller, it's unlikely you have one.

	See my previous.  I do have one (a 3Ware 9650E, given to me by a friend 
when his company switched to zfs for their server).  It's not on this 
system.  This array is on a HighPoint RocketRAID 2722.

> The difference between a
> drive write cache and a BBWC is that the BBWC is non-volatile - it
> does not get lost when power drops.

	Yeah, I'm aware, thanks.  I just didn't cotton to the acronym.

>> RAID-Server:/# xfs_info /dev/md0
>> meta-data=/dev/md0               isize=256    agcount=43,
>> agsize=137356288 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=5860329984, imaxpct=5
>>           =                       sunit=256    swidth=1536 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>           =                       sectsz=512   sunit=8 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> Ok, that all looks pretty good, and the sunit/swidth match the mount
> options you set so you definitely don't need the mount options...

	Yeah, I didn't set them.  What did, I don't really know for certain. 
See above.


>> [192173.364460]  [<ffffffff810fe45a>] ? vfs_fstatat+0x32/0x60
>> [192173.364471]  [<ffffffff810fe590>] ? sys_newstat+0x12/0x2b
>> [192173.364483]  [<ffffffff813509f5>] ? page_fault+0x25/0x30
>> [192173.364495]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b
>> [192173.364503] XFS (md0): Corruption detected. Unmount and run xfs_repair
>>
>> 	That last line, by the way, is why I ran umount and xfs_repair.
>
> Right, that's the correct thing to do, but sometimes there are
> issues that repair doesn't handle properly. This *was* one of them,
> and it was fixed by commit e1f43b4 ("repair: update extent count
> after zapping duplicate blocks") which was added to xfs_repair
> v3.1.8.
>
> IOWs, upgrading xfsprogs to the latest release and re-running
> xfs_repair should fix this error.

	OK. I'll scarf the source and compile.  All I need is to git clone 
git://oss.sgi.com/xfs/xfs and git://oss.sgi.com/xfs/cmds/xfsprogs, right?

	I've never used git on a package maintained in my distro.  Will I have 
issues when I upgrade to Debian Jessie in a few months, since this is 
not being managed by apt / dpkg?  It looks like Jessie has 3.2.1 of 
xfs-progs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
