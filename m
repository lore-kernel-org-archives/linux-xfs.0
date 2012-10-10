Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ADGPdw032636 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 08:16:25 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id tbFIiFxKemVxjCPT
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 06:17:56 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 8B4A56C09D
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 08:17:55 -0500 (CDT)
Message-ID: <50757583.9000901@hardwarefreak.com>
Date: Wed, 10 Oct 2012 08:17:55 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Performance degradation over time
References: <20121010105142.148519ca@booking.com>
In-Reply-To: <20121010105142.148519ca@booking.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 10/10/2012 3:51 AM, Marcin Deranek wrote:
> Hi,
> 
> We are running XFS filesystem on one of out machines which is a big
> store (~3TB) of different data files (mostly images). Quite recently we
> experienced some performance problems - machine wasn't able to keep up
> with updates. After some investigation it turned out that open()
> syscalls (open for writing) were taking significantly more time than
> they should eg. 15-20ms vs 100-150us.
> Some more info about our workload as I think it's important here:
> our XFS filesystem is exclusively used as data store, so we only
> read and write our data (we mostly write). When new update comes it's
> written to a temporary file eg.
> 
> /mountpoint/some/path/.tmp/file
> 
> When file is completely stored we move it to final location eg.
> 
> /mountpoint/some/path/different/subdir/newname
> 
> That means that we create lots of files in /mountpoint/some/path/.tmp
> directory, but directory is empty as they are moved (rename() syscall)
> shortly after file creation to a different directory on the same
> filesystem.
> The workaround which I found so far is to remove that directory
> (/mountpoint/some/path/.tmp in our case) with its content and re-create
> it. After this operation open() syscall goes down to 100-150us again.
> Is this a known problem ?
> Information regarding our system:
> CentOS 5.8 / kernel 2.6.18-308.el5 / kmod-xfs-0.4-2
> Let me know if you need to know anything more.

Hi Marcin,

I'll begin where you ended:  kmod-xfs.  DO NOT USE THAT.  Use the kernel
driver.  Eric Sandeen can point you to the why.  AIUI that XFS module
hasn't been supported for many many years.

Regarding your problem, I can't state some of the following with
authority, though it might read that way.  I'm making an educated guess
based on what I do know of XFS and the behavior you're seeing.  Dave
will clobber and correct me if I'm wrong here. ;)

XFS filesystems are divided into multiple equal sized allocation groups
on the underlying storage device (single disk, RAID, LVM volume, etc).
With inode32 each directory that is created has its files store in only
one AG, with some exceptions, which you appear to bumping up against.
If you're using inode64 the directories, along with their files, go into
the AGs round robin.

Educated guessing:  When you use rename(2) to move the files, the file
contents are not being moved, only the directory entry, as with EXTx
etc.  Thus the file data is still in the ".tmp" directory AG, but that
AG is no longer its home.  Once this temp dir AG gets full of these
"phantom" file contents (you can only see them with XFS tools), the AG
spills over.  At that point XFS starts moving the phantom contents of
the rename(2) files into the AG which owns the directory of the
rename(2) target.  I believe this is the source of your additional
latency.  Each time you do an open(2) call to write a new file, XFS is
moving a file's contents (extents) to its new/correct parent AG, causing
much additional IO, especially if these are large files.

As you are witnessing, if XFS did the move to the new AG in real time,
the performance of rename(2) would be horrible on the front end.  I'd
guess the developers never imagined that a user would fill an entire AG
using rename(2) calls.  Your deleting and recreating of the .tmp
directory which fixes the performance seems to be evidence of this.
Each time you delete/create that directory it is put into a different AG
in the filesystem, in a round robin fashion.  If you do this enough
times, you should eventually create the directory in the original AG
that's full of the rename(2) file extents, and performance will suffer
again.

One of the devs probably has some tricks/tools up his sleeve to force
those extents to their new parent AG.  You might be able to run a
nightly script to do this housekeeping.  Or you could always put the
.tmp directory on a different filesystem on a scratch disk.

This problem could also be a free space fragmentation issue, but given
that recreating the .tmp directory fixes it, I doubt free space frag is
the problem.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
