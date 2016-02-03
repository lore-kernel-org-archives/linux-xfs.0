Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 157CD7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 17:29:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03865304032
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 15:29:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qRYjZ9gmhl8RGGwP for <xfs@oss.sgi.com>;
	Wed, 03 Feb 2016 15:29:11 -0800 (PST)
Date: Thu, 4 Feb 2016 10:28:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Request for information on bloated writes using Swift
Message-ID: <20160203232834.GH459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
	<CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
	<20160203083016.GD459@dastard> <56B21690.2070304@sandeen.net>
	<20160203215144.GE459@dastard>
	<CAFHL4X1gxP8B_JLHoOKxhX553nkOH+D_2DjgXXq7hPjxTi2t0g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFHL4X1gxP8B_JLHoOKxhX553nkOH+D_2DjgXXq7hPjxTi2t0g@mail.gmail.com>
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
To: Dilip Simha <nmdilipsimha@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Feb 03, 2016 at 02:43:27PM -0800, Dilip Simha wrote:
> On Wed, Feb 3, 2016 at 1:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Wed, Feb 03, 2016 at 09:02:40AM -0600, Eric Sandeen wrote:
> > >
> > >
> > > On 2/3/16 2:30 AM, Dave Chinner wrote:
> > > > On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:
> > > >> Hi Dave,
> > > >>
> > > >> On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <david@fromorbit.com>
> > wrote:
> > > >>
> > > >>> On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> > > >>>> Hi Eric,
> > > >>>>
> > > >>>> Thank you for your quick reply.
> > > >>>>
> > > >>>> Using xfs_io as per your suggestion, I am able to reproduce the
> > issue.
> > > >>>> However, I need to falloc for 256K and write for 257K to see this
> > issue.
> > > >>>>
> > > >>>> # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k"
> > /srv/node/r1/t1.txt
> > > >>>> # stat /srv/node/r1/t4.txt | grep Blocks
> > > >>>>   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
> > > >>>
> > > >>> Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
> > > >>>
> > > >>> When you writing *past the preallocated area* and do delayed
> > > >>> allocation, the speculative preallocation beyond EOF is double the
> > > >>> size of the extent at EOF. i.e. 512k, leading to 768k being
> > > >>> allocated to the file (1536 blocks, exactly).
> > > >>>
> > > >>
> > > >> Thank you for the details.
> > > >> This is exactly where I am a bit perplexed. Since the reclamation
> > logic
> > > >> skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the
> > > >> allocation logic allot more blocks on such an inode?
> > > >
> > > > To store the data you wrote outside the preallocated region, of
> > > > course.
> > >
> > > I think what Dilip meant was, why does it do preallocation, not
> > > why does it allocate blocks for the data.  That part is obvious
> > > of course.  ;)
> > >
> > > IOWS, if XFS_DIFLAG_PREALLOC prevents speculative preallocation
> > > from being reclaimed, why is speculative preallocation added to files
> > > with that flag set?
> > >
> > > Seems like a fair question, even if Swift's use of preallocation is
> > > ill-advised.
> > >
> > > I don't have all the speculative preallocation heuristics in my
> > > head like you do Dave, but if I have it right, and it's i.e.:
> > >
> > > 1) preallocate 256k
> > > 2) inode gets XFS_DIFLAG_PREALLOC
> > > 3) write 257k
> > > 4) inode gets speculative preallocation added due to write past EOF
> > > 5) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC
> > >
> > > that seems suboptimal.
> >
> > So do things the other way around:
> >
> > 1) write 257k
> > 2) preallocate 256k beyond EOF and speculative prealloc region
> > 3) inode gets XFS_DIFLAG_PREALLOC
> > 4) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC
> >
> > This is correct behaviour.
> >
> 
> I am sorry, but I don't agree to this. How can an user application know
> about step2.

Step 2 is fallocate(keep size) to a range well beyond EOF. e.g. in
preparation for a bunch of sparse writes that are about to take
place. So userspace will most definitely know about it. It's now the
kernel that now doesn't have a clue what to do about the speculative
preallocation it already has because the application is mixing it's
IO models.

Fundamentally, if you mix writes across persistent preallocation and
adjacent holes, you are going to get a mess no matter what
filesystem you do this to. If you don't like the way XFS handles it,
either fix the application to not do this, or use the mount option
to turn off speculative preallocation.

Just like we say "don't mix direct IO and buffered IO on the same
file", it's a really good idea not to mix preallocated and
non-preallocated writes to the same file.

> > But if we decide that we don't do speculative prealloc when
> > XFS_DIFLAG_PREALLOC is set, then workloads that mis-use fallocate
> > (like swift), or use fallocate to fill sparse holes in files are
> > going fragment the hell out of their files when they extending
> > them.
> >
> 
> I don't understand why would this be the case. If XFS doesn't do
> speculative preallocation then for the 256 byte write after the end of EOF
> will simply result in pushing the EOF ahead. So I see no harm if XFS
> doesn't do speculative preallocation when XFS_DIFLAG_PREALLOC is set.

I see *potential harm* in changing a long standing default
behaviour.

> > In reality, if swift is really just writing 1k past the prealloc'd
> > range it creates, then that is clearly an application bug. Further,
> > if swift is only ever preallocating the first 256k of each file it
> > writes, regardless of size, then that is also an application bug.
> 
> Its not a bug. Assume a use-case like appending to a file. Would you say
> append is a buggy operation?

If the app is using preallocation to reduce append workload file
fragmenation, and then doesn't use preallocation once it is used up,
the the app is definitely buggy because it's not being consistent in
it's IO behaviour.  The app should always use fallocate() to control
file layout, or it should never use fallocate and leave the
filesystem to optimise the layout at it sees best.

In my experience, the filesystem will almost always do a better job
of optimising allocation for best throughput and minimum seeks than
applications using fallocate().

IOWs, the default behaviour of XFS has been around for more than 15
years and is sane for the majority of applications out there. Hence
the solution here is to either fix the application that is doing
stupid things with fallocate(), or use the allocasize mount option
to minimise the impact of the stupid thing the buggy application is
doing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
