Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99C3F7FC4
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 03:36:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F710AC001
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 01:36:04 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 8pkUbpazcuGWs5Ih
	for <xfs@oss.sgi.com>; Mon, 03 Feb 2014 01:36:00 -0800 (PST)
Message-ID: <52EF6301.5040406@hardwarefreak.com>
Date: Mon, 03 Feb 2014 03:36:01 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: relationship of nested stripe sizes, was: Question regarding
	XFS on LVM over hardware RAID.
References: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>
	<52ED4143.6090303@hardwarefreak.com>
	<EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>
	<52ED6AAF.6030703@hardwarefreak.com>
	<98961D3F-769D-44A9-98A8-FC7867893138@colorremedies.com>
	<20140202213030.GQ2212@dastard>
	<52EF1D76.6070302@hardwarefreak.com>
	<20140203052415.GQ13997@dastard>
In-Reply-To: <20140203052415.GQ13997@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

On 2/2/2014 11:24 PM, Dave Chinner wrote:
> On Sun, Feb 02, 2014 at 10:39:18PM -0600, Stan Hoeppner wrote:
>> On 2/2/2014 3:30 PM, Dave Chinner wrote:
...
>>> And that is why this is a perfect example of what I'd like to see
>>> people writing documentation for.
>>>
>>> http://oss.sgi.com/archives/xfs/2013-12/msg00588.html
>>>
>>> This is not the first time we've had this nested RAID discussion,
>>> nor will it be the last. However, being able to point ot a web page
>>> or or documentation makes it a whole lot easier.....
>>>
>>> Stan - any chance you might be able to spare an hour a week to write
>>> something about optimal RAID storage configuration for XFS?
>>
>> I could do more, probably rather quickly.  What kind of scope, format,
>> style?  Should this be structured as reference manual style
>> documentation, FAQ, blog??  I'm leaning more towards reference style.
> 
> Agreed - reference style is probably best. As for format style, I'm
> tending towards a simple, text editor friendly markup like asciidoc.
> From there we can use it to generate PDFs, wiki documentation, etc
> and so make it available in whatever format is convenient.

Works for me, I'm a plain text kinda guy.

> (Oh, wow, 'apt-get install asciidoc' wants to pull in about 1.1GB of
> dependencies)
> 
>> How about starting with a lead-in explaining why the workload should
>> always drive storage architecture.  Then I'll describe the various
>> standard and nested RAID levels, concatenations, etc and some
>> dis/advantages of each.  Finally I'll give examples of a few common and
>> a high end workloads, one or more storage architectures suitable for
>> each and why, and how XFS should be configured optimally for each
>> workload and stack combination WRT geometry, AGs, etc. 
> 
> That sounds like a fine plan.
> 
> The only thing I can think of that is obviously missing from this is
> the process of problem diagnosis. e.g. what to do when something
> goes wrong. The most common the mistake we see is trying to repair
> the filesystem when th storage is still broken and making a bigger
> mess. Having something that describes what to look for (e.g. raid
> reconstruction getting disks out of order) and how to recover from
> problems with as little risk and data loss as possible would be
> invaluable.

Ahh ok.  So you're going for the big scope described in your Dec 13
email, not the paltry "optimal RAID storage configuration for XFS"
described above.  Now I understand the 1 hour a week question. :)

I'll brain dump as much as I can, in a hopefully somewhat coherent
starting doc.  I'll do my best starting the XFS troubleshooting part,
but I'm much weaker here than with XFS architecture and theory.

>> I could also touch on elevator selection and other common kernel
>> tweaks often needed with XFS.
> 
> I suspect you'll need to deal with elevators and IO schedulers and
> the impact of BBWC on reordering and merging early on in the storage
> architecture discussion. ;)

Definitely bigger scope than I originally was thinking, but I'm all in.

> As for kernel tweaks outside the storage stack, i wouldn't bother
> right now - we can always add it later it it's appropriate.

'k

>> I could provide a workload example with each RAID level/storage
>> architecture in lieu of the separate workload section.  Many readers
>> would probably like to see it presented in that manner as they often
>> start at the wrong end of the tunnel.  However, that would be
>> antithetical to the assertion that the workload drives the stack design,
>> which is a concept we want to reinforce as often as possible I think.
>> So I think the former 3 section layout is better.
> 
> Rearranging text is much easier than writing it in the first place,
> so I think we can worry about that once the document starts to take
> place.

Yep.

>> I should be able to knock most of this out fairly quickly, but I'll need
>> help on some of it.  For example I don't have any first hand experience
>> with large high end workloads.  I could make up a plausible theoretical
>> example but I'd rather have as many real-world workloads as possible.
>> What I have in mind for workload examples is something like the
>> following.  It would be great if list members who have one the workloads
>> below would contribute their details and pointers, any secret sauce,
>> etc.  Thus when we refer someone to this document they know they're
>> reading of an actual real world production configuration.  Though I
>> don't plan to name sites, people, etc, just the technical configurations.
> 
> 1. General purpose (i.e. unspecialised) configuration that should be
> good for most users.

Format with XFS defaults.  Done. :)

What detail should go with this?  Are you thinking SOHO server here,
single disk web server.  Anything with low IO rate and a smallish disk/RAID?

>> 1.  Small file, highly parallel, random IO
>>  -- mail queue, maildir mailbox storage
>>  -- HPC, filesystem as a database
>>  -- ??
> 
> The hot topic of the moment that fits into this category is object
> stores for distributed storage. i.e. gluster and ceph running
> openstack storage layers like swift to store large numbers of
> pictures of cats.

The direction I was really wanting to go here is highlighting the
difference between striped RAID and linear concat, how XFS AG
parallelism on concat can provide better performance than striping for
some workloads, and why.  For a long time I've wanted to create a
document about this with graphs containing "disk silo" icons, showing
the AGs spanning the striped RAID horizontally and spanning the concat
disks vertically, explaining the difference in seek patterns and how
they affect a random IO workload.

Maybe I should make concat a separate topic entirely, as it can benefit
multiple workload types, from the smallest to the largest storage
setups.  XFS' ability to scale IO throughput nearly infinitely over
concatenated storage is unique to Linux, and fairly unique to
filesystems in general TTBOMK.  It is one of its greatest strengths.
I'd like to cover this in good detail.

>> 2.  Virtual machine consolidation w/mixed guest workload
> 
> There's a whole lot of stuff here that is dependent on exactly how
> the VM infrastructure is set up, so this might be difficult to
> simplify enough to be useful.

I was thinking along the lines of consolidating lots of relatively low
IO throughput guests with thin provisioning, like VPS hosting.  For
instance a KVM host and a big XFS, sparse files exported to Linux guests
as drives.  Maybe nobody is doing this with XFS.

>> 3.  Large scale database
>>  -- transactional
>>  -- warehouse, data mining
> 
> They are actually two very different workloads. Data mining is
> really starting to move towards distributed databases that
> specialise in high bandwidth sequential IO so I'm not sure that it
> really is any different these days to a traditional HPC
> application in terms of IO...

Yeah, I wasn't sure if anyone was still doing it on singe hosts at scale
but through it in just in case.  The big TPC-H systems have all been
clusters with shared nothing storage for about a decade.

>> 4.  High bandwidth parallel streaming
>>  -- video ingestion/playback
>>  -- satellite data capture
>>  -- other HPC ??
> 
> Large scale data archiving (i.e. write-once workloads), pretty much
> anything HPC...
> 
>> 5.  Large scale NFS server, mixed client workload
> 
> I'd just say large scale NFS server, because - apart from modifying
> the structure to suit NFS access patterns - the underly config
> is still going to be driven by the dominant workloads.
> storage config is still

I figured you'd write this section since you have more experience with
big NFS than anyone here.

>> Lemme know if this is ok or if you'd like it to take a different
>> direction, if you have better or additional example workload classes,
>> etc.  If mostly ok, I'll get started on the first 2 sections and fill in
>> the 3rd as people submit examples.
> 
> It sounds good to me - I think that the first 2 sections are the
> core of the work - it's the theory that is in our heads (i.e. the
> black magic) that is simply not documented in a way that people can
> use.

Agreed.

I'll get started.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
