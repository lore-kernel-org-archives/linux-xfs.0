Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76BE77F3F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 00:47:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6244F8F8064
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 22:47:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	w8Y6CbhgLGjQo56q for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 22:47:23 -0700 (PDT)
Date: Wed, 23 Apr 2014 15:47:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS fragmentation on file append
Message-ID: <20140423054719.GJ15995@dastard>
References: <CAJhmKHmwvCBx=arJ6m2ZhuQVq=Jj-XbBGvEPjTPY5a1QtWRTCQ@mail.gmail.com>
	<20140408015012.GB22917@dastard>
	<CAJhmKHnap0vu8m4AXBxJr9L0RKoquFrm3NjKQdDBJwpRTYmfpw@mail.gmail.com>
	<20140408053117.GJ27017@dastard>
	<CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJhmKHk5fWVaDTEfL_oESULspavk83eBEsyw7=qEp8bC7f2S2g@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Keyur Govande <keyurgovande@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 07:35:34PM -0400, Keyur Govande wrote:
> On Tue, Apr 8, 2014 at 1:31 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Apr 07, 2014 at 11:42:02PM -0400, Keyur Govande wrote:
> >> On Mon, Apr 7, 2014 at 9:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > [cc the XFS mailing list <xfs@oss.sgi.com>]
> >> >
> >> > On Mon, Apr 07, 2014 at 06:53:46PM -0400, Keyur Govande wrote:
> >> >> Hello,
> >> >>
> >> >> I'm currently investigating a MySQL performance degradation on XFS due
> >> >> to file fragmentation.
.....
> >> > Alternatively, set an extent size hint on the log files to define
> >> > the minimum sized allocation (e.g. 32MB) and this will limit
> >> > fragmentation without you having to modify the MySQL code at all...
.....
> I spent some more time figuring out the MySQL write semantics and it
> doesn't open/close files often and initial test script was incorrect.
> 
> It uses O_DIRECT and appends to the file; I modified my test binary to
.....
> [root@dbtest09 linux-3.10.37]# xfs_io -c "extsize " /var/lib/mysql/xfs/
> [0] /var/lib/mysql/xfs/

So you aren't using extent size hints....

> 
> Here's how the first 3 AG's look like:
> https://gist.github.com/keyurdg/82b955fb96b003930e4f
> 
> After a run of the dpwrite program, here's how the bmap looks like:
> https://gist.github.com/keyurdg/11196897
> 
> The files have nicely interleaved with each other, mostly
> XFS_IEXT_BUFSZ size extents.

XFS_IEXT_BUFSZ Has nothing to do with the size of allocations. It's
the size of the in memory array buffer used to hold extent records.

What you are seeing is allocation interleaving according to the
pattern and size of the direct IOs being done by the application.
Which happen to be 512KB (1024 basic blocks) and the file being
written to is randomly selected.

> The average read speed is 724 MBps. After
> defragmenting the file to 1 extent, the speed improves 30% to 1.09
> GBps.

Sure. Now set an extent size hint of 32MB and try again.

> I noticed that XFS chooses the AG based on the parent directory's AG
> and only the next sequential one if there's no space available.

Yes, that's what the inode64 allocator does. It tries to keep files
in the same directory close together.

> A
> small patch that chooses the AG randomly fixes the fragmentation issue
> very nicely. All of the MySQL data files are in a single directory and
> we see this in Production where a parent inode AG is filled, then the
> sequential next, and so on.
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index c8f5ae1..7841509 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -517,7 +517,7 @@ xfs_ialloc_ag_select(
>          * to mean that blocks must be allocated for them,
>          * if none are currently free.
>          */
> -       agno = pagno;
> +       agno = ((xfs_agnumber_t) prandom_u32()) % agcount;
>         flags = XFS_ALLOC_FLAG_TRYLOCK;
>         for (;;) {
>                 pag = xfs_perag_get(mp, agno);

Ugh. That might fix the interleaving, but it randomly distributes
related files over the entire filesystem. Hence if you have random
access to the files (like a database does) you now have random seeks
across the entire filesystem rather than within AGs. You basically
destroy any concept of data locality that the filesystem has.

> I couldn't find guidance on the internet on how many allocation groups
> to use for a 2 TB partition,

I've already given guidance on that. Choose to ignore it if you
will...

> but this random selection won't scale for
> many hundreds of concurrently written files, but for a few heavily
> writtent-to files it works nicely.
> 
> I noticed that for non-DIRECT_IO + every write fsync'd, XFS would
> cleverly keep doubling the allocation block size as the file kept
> growing.

That's the behaviour of delayed allocation.  By using buffered IO,
the application has delegated all responisbility of optimal layout
of the file to the filesystem, and this is the method XFS uses to
minimise fragmentation in that case.

Direct IO does not have delayed allocation - it allocates for the
current IO according to the bounds given by the IO, inode extent size
hints and alignment characteristic of the filesystem. It does not do
specualtive allocation at all.

The principle of direct IO to do exactly what the application asked,
not to second guess what the application *might* need. Either the
application delegates everything to the filesystem (i.e. buffered
IO) or it assumes full responsibility for allocation behaviour and
IO coherency (i.e. direct IO).

IOWs, If you need to preallocate  space beyond EOF that doubles in
size as the file grows to prevent fragmentation, then the
application should be calling fallocate(FALLOC_FL_KEEP_SIZE) at
the appropriate times or using extent size hints to define the
minimum allocation sizes for the direct IO.

> The "extsize" option seems to me a bit too static because the size of
> tables we use varies widely and large new tables come and goe

You can set the extsize per file at create time, but really, you
only need to set the extent size just large enough to obtain maximal
read speeds.

> Could the same doubling logic be applied for DIRECT_IO writes as well?

I don't think so. It would break many carefully tuned production
systems out there that rely directly  on the fact that XFS does
exactly what the application asks it to do when using direct IO.

IOWs, I think you are trying to optimise the wrong layer - put your
effort into making fallocate() do what the application needs to
prevent fragmentation rather trying to hack the filesystem to do it
for you.  Not only will that improve performance on XFS, but it will
also improve performance on ext4 and any other filesystem that
supports fallocate and direct IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
