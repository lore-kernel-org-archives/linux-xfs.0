Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9AETj8K054451 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 09:29:45 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 4CQ1DJeqB7Jve73e for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 07:31:16 -0700 (PDT)
Message-ID: <507586B4.6010201@sandeen.net>
Date: Wed, 10 Oct 2012 09:31:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Performance degradation over time
References: <20121010105142.148519ca@booking.com>
	<50757583.9000901@hardwarefreak.com>
In-Reply-To: <50757583.9000901@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

On 10/10/12 8:17 AM, Stan Hoeppner wrote:
> On 10/10/2012 3:51 AM, Marcin Deranek wrote:
>> Hi,
>>
>> We are running XFS filesystem on one of out machines which is a big
>> store (~3TB) of different data files (mostly images). Quite recently we
>> experienced some performance problems - machine wasn't able to keep up
>> with updates. After some investigation it turned out that open()
>> syscalls (open for writing) were taking significantly more time than
>> they should eg. 15-20ms vs 100-150us.
>> Some more info about our workload as I think it's important here:
>> our XFS filesystem is exclusively used as data store, so we only
>> read and write our data (we mostly write). When new update comes it's
>> written to a temporary file eg.
>>
>> /mountpoint/some/path/.tmp/file
>>
>> When file is completely stored we move it to final location eg.
>>
>> /mountpoint/some/path/different/subdir/newname
>>
>> That means that we create lots of files in /mountpoint/some/path/.tmp
>> directory, but directory is empty as they are moved (rename() syscall)
>> shortly after file creation to a different directory on the same
>> filesystem.
>> The workaround which I found so far is to remove that directory
>> (/mountpoint/some/path/.tmp in our case) with its content and re-create
>> it. After this operation open() syscall goes down to 100-150us again.
>> Is this a known problem ?
>> Information regarding our system:
>> CentOS 5.8 / kernel 2.6.18-308.el5 / kmod-xfs-0.4-2
>> Let me know if you need to know anything more.
> 
> Hi Marcin,
> 
> I'll begin where you ended:  kmod-xfs.  DO NOT USE THAT.  Use the kernel
> driver.  Eric Sandeen can point you to the why.  AIUI that XFS module
> hasn't been supported for many many years.

Yep.  Ditch that; it overrides the maintained module that comes with the
kernel itself.  See if that helps, first, I suppose.

I've been asking Centos for a while to find some way to deprecate that,
but it's like night of the living dead xfs modules.

(modinfo xfs will tell you for sure which xfs.ko is getting loaded I suppose).

> Regarding your problem, I can't state some of the following with
> authority, though it might read that way.  I'm making an educated guess
> based on what I do know of XFS and the behavior you're seeing.  Dave
> will clobber and correct me if I'm wrong here. ;)
> 
> XFS filesystems are divided into multiple equal sized allocation groups
> on the underlying storage device (single disk, RAID, LVM volume, etc).
> With inode32 each directory that is created has its files store in only
> one AG, with some exceptions, which you appear to bumping up against.
> If you're using inode64 the directories, along with their files, go into
> the AGs round robin.

Agreed that it would be good to know whether inode64 is in use.

Let's start there (and with a modern xfs.ko) before we speculate further.

> Educated guessing:  When you use rename(2) to move the files, the file
> contents are not being moved, only the directory entry, as with EXTx
> etc.  Thus the file data is still in the ".tmp" directory AG, but that
> AG is no longer its home.  Once this temp dir AG gets full of these
> "phantom" file contents (you can only see them with XFS tools), the AG
> spills over.  At that point XFS starts moving the phantom contents of
> the rename(2) files into the AG which owns the directory of the
> rename(2) target.  I believe this is the source of your additional
> latency.  Each time you do an open(2) call to write a new file, XFS is
> moving a file's contents (extents) to its new/correct parent AG, causing
> much additional IO, especially if these are large files.

Nope, don't think so ;) Nothing is going to be moving file contents
behind your back on a rename.

<snip>

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
