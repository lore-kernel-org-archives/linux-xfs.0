Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAH4VP7g203198 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 22:31:25 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3ZLcnGjPDuKcYV8Q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Nov 2012 20:33:30 -0800 (PST)
Message-ID: <50A71386.80100@oracle.com>
Date: Sat, 17 Nov 2012 12:33:10 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsprogs: Introduce a new subcommand agstate to
	xfs_fio
References: <50A5E258.3000509@oracle.com> <20121117020231.GP14281@dastard>
In-Reply-To: <20121117020231.GP14281@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/17/2012 10:02 AM, Dave Chinner wrote:
> On Fri, Nov 16, 2012 at 02:51:04PM +0800, Jeff Liu wrote:
>> Introduce a new xfs_io command: agstate.
>>
>> This command is used to get/set state for a given allocation group.
> 
> xfs_io is not the place for this command.
I was also wonder why we place the agflags command on there since xfs_io is aimed
at examining the regular file I/O paths, but I can not found out a better place
while implementing it.

> 
> A couple of weeks ago I started writing an xfs_spaceman module and
> an ioctl interface for exactly this purpose, I just hadn't got
> around to completing it and the kernel patch to test it so I hadn't
> posted it.  Once the userspace release is out of the way, I'll post
> the patches to get xfs_spaceman into xfs_progs, and we can use that
> for this AG control from the start.
> 
> The reason for this is that the AG state in future is going to be a
> lot more complex than just enabling/disabling allocation, and the
> ioctl interface I prototyped supports a lot of that future
> functionality.
Definitely, so that we can have fine-granted AG controls, that's why I didn't
chose to re-base/post the previous agflags patch but proposed the agstate command
because the naming would sounds more reasonable.
> 
> The patch is below so you can see what sort of AG control/state
> functionality I think we'll be needing sooner rather than later, and
> the interface I think we should be using...
Ok, I'll waiting for this feature. :)

BTW, Does it sounds make sense if we implement parent pointer support at first?
http://www.xfs.org/index.php/Unfinished_work#Parent_Pointers.2FCreate.2BEA
I propose this because it would reduce many efforts for implementing xfs_shrinkfs
command, and reduce the overhead for iterating overall file systems to find out
files which are located at offline AGs.
> 
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  include/xfs_ag.h |   32 ++++++++++++++++++++++++++++----
>>  include/xfs_fs.h |    2 ++
>>  io/Makefile      |    2 +-
>>  io/init.c        |    1 +
>>  4 files changed, 32 insertions(+), 5 deletions(-)
> 
> FWIW, I think you forgot to include the file that introduces the
> command in the patch :)
Oops! sorry for the mistake.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
