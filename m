Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KCAmWi229160 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 07:10:48 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3F658373E
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 05:10:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id cqAjJgQZSAbsySNt
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 05:10:47 -0700 (PDT)
Message-ID: <4E26C5C5.1090802@hardwarefreak.com>
Date: Wed, 20 Jul 2011 07:10:45 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 30 TB RAID6 + XFS slow write performance
References: <4E24907F.6020903@johnbokma.com>
	<20110719103719.18c4773f@galadriel.home>
	<4E260725.4040003@hardwarefreak.com>
	<20110720002053.GD9359@dastard>
	<4E26649F.7040202@hardwarefreak.com>
	<20110720064419.GG9359@dastard>
In-Reply-To: <20110720064419.GG9359@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: John Bokma <contact@johnbokma.com>, xfs@oss.sgi.com

On 7/20/2011 1:44 AM, Dave Chinner wrote:
> On Wed, Jul 20, 2011 at 12:16:15AM -0500, Stan Hoeppner wrote:
>> On 7/19/2011 7:20 PM, Dave Chinner wrote:
>>> On Tue, Jul 19, 2011 at 05:37:25PM -0500, Stan Hoeppner wrote:
>>>> On 7/19/2011 3:37 AM, Emmanuel Florac wrote:
>>>>> Le Mon, 18 Jul 2011 14:58:55 -0500 vous =E9criviez:
>>>>>
>>>>>> card: MegaRAID SAS 9260-16i
>>>>>> disks: 14x Barracuda=AE XT ST33000651AS 3TB (2 hot spares).
>>>>>> RAID6
>>>>>> ~ 30TB
>>>>
>>>>> This card doesn't activate the write cache without a BBU present. Be
>>>>> sure you have a BBU or the performance will always be unbearably awfu=
l.
>>>>
>>>> In addition to all the other recommendations, once the BBU is installe=
d,
>>>> disable the individual drive caches (if this isn't done automatically),
>>>> and set the controller cache mode to 'write back'.  The write through
>>>> and direct I/O cache modes will deliver horrible RAID6 write performan=
ce.
>>>>
>>>> And, BTW, RAID6 is a horrible choice for a parallel, small file, high
>>>> random I/O workload such as you've described.  RAID10 would be much mo=
re
>>>> suitable.  Actually, any striped RAID is less than optimal for such a
>>>> small file workload.  The default stripe size for the LSI RAID
>>>> controllers, IIRC, is 64KB.  With 14 spindles of stripe width you end =
up
>>>> with 64*14 =3D 896KB. =

>>>
>>> All good up to here.
>>
>> And then my lack of understanding of XFS internals begins to show. :(
> =

> The fact you are trying to understand them is the important bit!

I've always found XFS fascinating (as with most of SGI's creations).
The more I use XFS, and the more I participate here, the more I want to
understand how the cogs turn.  And as you mentioned previously, it's
beneficial to this list if users can effectively answer other users'
questions, giving devs more time for developing. :)

> ....
>>> So if you have a small file workload, specifying sunit/swidth can
>>> actually -decrease- performance because it allocates the file
>>> extents sparsely. IOWs, stripe alignment is important for bandwidth
>>> intensive applications because it allows full stripe writes to occur
>>> much more frequently, but can be harmful to small file performance
>>> as the aligned allocation pattern can prevent full stripe writes
>>> from occurring.....
>>
>> I don't recall reading this before Dave.  Thank you for this tidbit.
> =

> I'm sure I've said this before, but it's possible I've said it this
> time in away that is obvious and understandable. Most people
> struggle with the concept of allocation alignment and why it might be
> important, let alone understand it well enough to discuss intricate
> details of the allocator and tuning it for different workloads...

In general I've understood for quite some time that large stripes were
typically bad for small file performance due to the partial stripe write
issue.  However, I misunderstood something you said quite some time ago
about XFS having some tricks to somewhat mitigate partial stripe writes
during writeback.  I thought this was packing multiple small files into
a single stripe write, which you just explained XFS does not do.
Thinking back you were probably talking about some other aggregation
that occurs in the allocator to cut down on the number of physical IOs
required to write the data, or something like that.

...
>> An mkfs.xfs of an
>> mdraid striped array will by default create sunit/swidth values right?
>> And thus this lower performance w/small files.
> =

> In general, sunit/swidth being specified provides a better tradeoff
> for maintaining consistent performance on files across the
> filesystem. it might cost a little for small files, but unaligned IO
> on large files cause much more noticable performace problems...

The reason I asked is to get something in Google.  If a user has a
purely small file workload, such as maildir, but insists on using an
mdraid striped array, would it be better to override the mkfs.xfs
defaults here so sunit/swidth aren't defined?  If so, would one specify
zero for each parameter on the command line?

> ....
> =

>>>> If you read the list archives you'll see
>>>> recommendations for an optimal storage stack setup for this workload.
>>>> It goes something like this:
>>>>
>>>> 1.  Create a linear array of hardware RAID1 mirror sets.
>>>>     Do this all in the controller if it can do it.
>>>>     If not, use Linux RAID (mdadm) to create a '--linear' array of the
>>>>     multiple (7 in your case, apparently) hardware RAID1 mirror sets
>>>>
>>>> 2.  Now let XFS handle the write parallelism.  Format the resulting
>>>>     7 spindle Linux RAID device with, for example:
>>>>
>>>>     mkfs.xfs -d agcount=3D14 /dev/md0
>>>>
>>>> By using this configuration you eliminate the excessive head seeking
>>>> associated with the partial stripe write problems of RAID6, restoring
>>>> performance efficiency to the array.  Using 14 allocation groups allows
>>>> XFS to write write, at minimum, 14 such files in parallel.
>>>
>>> That's not correct. 14 AG means that if the files are laid out
>>> across all AGs then there can be 14 -allocations- in parallel at
>>> once. If Io does not require allocation, then they don't serialise
>>> at all on the AGs.  IOWs, If allocation takes 1ms of work in an AG,
>>> then you could have 1,000 allocations per second per AG. With 14
>>> AGs, that gives allocation capability of up to 14,000/s
>>
>> So are you saying that we have no guarantee, nor high probability, that
>> the small files in this case will be spread out across all AGs, thus
>> making more efficient use of each disk's performance in the concatenated
>> array, vs a striped array?  Or, are you merely pointing out a detail I
>> have incorrect, which I've yet to fully understand?
> =

> Yet to fully understand. It's not limited to small files, either.
> =

> XFS doesn't guarantee that specific allocations are evenly
> distributed across AGs, but it does try to spread the overall
> contents of the filesystem across all AGs. It does have concepts of
> locality of reference, but they change depending on the allocator in
> use.
> =

> Take, for example, inode32 vs inode64 which are the two most common
> allocation strategies and assume we have a 16TB fs with 1TB AGs.
> The inode32 allocator will place all inodes and most directory
> metadata in the first AG, below one TB. There is basically no
> metadata allocation parallelism in this strategy, so metadata
> performance is limited and will often serialise. Metadata tends to
> have good locality of reference - all directories and inodes will
> tend to be close together on disk because they are in the same AG.

I'd forgotten this.  I do recall discussions of all the directories and
inodes being in the first 1TB on an inode32 filesystem.  IIRC, those
were focused on people "running out of space" when they still had many
hundreds of Gigs or a TB free, simply because they ran out of space for
inodes.  Until now I hadn't tied this together with the potential
metadata performance issue, and specifically with a linear concat setup.

> Data, on the other had is rotored around AGs 2-16 on a per file
> basis, so there is no locality between inodes and their data, nor of
> data between two adjacent files in the same directory. There is,
> however, data allocation parallelism because files are spread
> across allocation groups...
> =

> Hence for inode32, metadata is closely located, but data is spread
> out widely. Hence metadata operations don't scale at all well on a
> linear concat (e.g. hit only one disk/mirror pair), but data
> allocations are spread effectively and hence parallelise and scale
> quite well. The downside to this is that data lookups involve large
> seeks if you have a stripe, and hence can be quite slow. Data reads
> on a linear concat are not guaranteed to evenly load the disks,
> either, simply because there's no correlation between the location
> of the data and the access patterns.

Got it.

> For inode64, locality of reference clusters around the directory
> structure. The inodes for files in a directory will be allocated in
> the same AG as the directory inode, and the data for each file will
> be allocated in the same AG as the file inodes. When you create a
> new directory, it gets placed in a different AG, and the pattern
> repeats. So for inode64, distributing files across all AGs is caused
> by distributing the directory structure. =


And this is why maildir works very well with a linear concat on an
inode64 filesystem, as each mailbox is in a different directory, thus
spreading all the small mail files and metadata across all AGs.  Which
is why I've been recommending it.  I don't think I've been specifying
inode64 though in my previous recommendations.  I should probably be
doing that.  I guess I assumed everyone running XFS today is running a
64bit kernel/user space--probably not good to simply assume that.

> FWIW, an example is a
> kernel source tree:
> =

> ~/src/kern/xfsdev$ find . -type d -exec sudo xfs_bmap -v {} \; | awk '/ 0=
: / { print $4 }' |sort -n |uniq -c
>      76 0
>      66 1
>      85 2
>      81 3
>      82 4
>      69 5
>      89 6
>      74 7
>      90 8
>      81 9
>      96 10
>      84 11
>      85 12
>      84 13
>      86 14
>      71 15
> =

> As you can see, there's a relatively even spread of the directories
> across all 16 AGs in that directory structure, and the file data
> will follow this pattern. Because of it's better metadata<->data
> locality of reference, inode64 tends to be signficantly faster on
> workloads that mix metadata operations with data operations (e.g.
> recursive grep across a kernel source tree) as the seek cost between
> the inode and it's data is much less than for inode32....

Right.

> However, if youre workload does not spread across directories, then
> IO will tend to be limited to specific silos in the linear concat
> while other disks sit idle. If you have a stripe, then the seeks to
> get to the data are small, and hence much faster than inode32 on
> similar workloads.

And now I understand your previous comment that we don't know enough
about the user's workload to make the linear concat recommendation.  If
he's writing all those hundreds of thousands of small files into the
same directory the performance of a linear concat would be horrible.

> This is all ignoring stripe aligned allocation - that is often lost
> in the noise comapred to bigger issues like seeking from AG 0 to AG
> 15 when reading the inode then the data or having a workload only
> use a single AG because it is all confined to a single directory.
> =

> IOWs, the best, most optimal filesystem layout and allocation
> stratgey is both workload and hardware dependent, and there's no one
> right answer. The defaults select the best balance for typical usage
> - beyond that benchmarking the workload is the only way to really
> measure whether your tweaks are the right ones or not. IOWs, you
> need to understand the filesystem, your storage hardware and -the
> application IO patterns- to make the right tuning decisions.

Got it.  When I prematurely recommended the linear concat I'd simply
forgotten that our AG parallelism is dependent on having many of
directories, not just many small files.

>>> And given that not all writes require allocation and allocation is
>>> usually only a small percentage of the total IO time. You can have
>>> many, many more write IOs in flight than you can do allocations in
>>> an AG....
>>
>> Ahh, I think I see your point.  For the maildir case, more of the IO is
>> likely due to things like updating message flags, etc, than actually
>> writing new mail files into the directory. =

> =

> I wasn't really talking about maildir here, just pointing out that
> allocation is generally not the limiting factor in doing large
> amounts of concurrent write IO.

Got it.  In the specific case the OP posted about, hundreds of thousands
of small file writes, allocation could be a limiting factor though, correct?

>> Such operations don't
>> require allocation.  With the workload mentioned by the OP, it's
>> possible that all of the small file writes may indeed require
>> allocation, unlike the maildir workload.  But if this is the case,
>> wouldn't the concatenated array still yield better overall performance
>> than RAID6, or any other striped array?
> =

> <shrug>
> =

> Quite possibly, butI can't say conclusively - I simply don't know
> enough about the workload or the fs configuration.

Don't shrug Dave. :)  You already answered this question up above.
Well, you provided me some new information, and reminded me of things I
already knew, which allowed me to answer this for my self.

Thanks for spending the time you have in this thread to do some serious
teaching.  You provided some valuable information that isn't in the XFS
User Guide, nor the XFS File System Structure document.  If it is there,
it's not in a format that a mere mortal such as my self can digest.  You
make deeper aspects of XFS understandable, and I really appreciate that.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
