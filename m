Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 375FC7FF7
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 15:54:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 016C88F8035
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 13:54:18 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZBnLq0Sk6PjfOfOR for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 13:54:16 -0800 (PST)
Date: Tue, 4 Feb 2014 08:54:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: relationship of nested stripe sizes, was: Question regarding XFS
	on LVM over hardware RAID.
Message-ID: <20140203215411.GS13997@dastard>
References: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>
	<52ED4143.6090303@hardwarefreak.com>
	<EDBD7355-F1EC-4773-9138-CA864CB2E84B@colorremedies.com>
	<52ED6AAF.6030703@hardwarefreak.com>
	<98961D3F-769D-44A9-98A8-FC7867893138@colorremedies.com>
	<20140202213030.GQ2212@dastard>
	<52EF1D76.6070302@hardwarefreak.com>
	<20140203052415.GQ13997@dastard>
	<52EF6301.5040406@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52EF6301.5040406@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs <xfs@oss.sgi.com>

On Mon, Feb 03, 2014 at 03:36:01AM -0600, Stan Hoeppner wrote:
> On 2/2/2014 11:24 PM, Dave Chinner wrote:
> > On Sun, Feb 02, 2014 at 10:39:18PM -0600, Stan Hoeppner wrote:
> >> On 2/2/2014 3:30 PM, Dave Chinner wrote:
> ...
> >>> And that is why this is a perfect example of what I'd like to see
> >>> people writing documentation for.
> >>>
> >>> http://oss.sgi.com/archives/xfs/2013-12/msg00588.html
> >>>
> >>> This is not the first time we've had this nested RAID discussion,
> >>> nor will it be the last. However, being able to point ot a web page
> >>> or or documentation makes it a whole lot easier.....
> >>>
> >>> Stan - any chance you might be able to spare an hour a week to write
> >>> something about optimal RAID storage configuration for XFS?
> >>
> >> I could do more, probably rather quickly.  What kind of scope, format,
> >> style?  Should this be structured as reference manual style
> >> documentation, FAQ, blog??  I'm leaning more towards reference style.
> > 
> > Agreed - reference style is probably best. As for format style, I'm
> > tending towards a simple, text editor friendly markup like asciidoc.
> > From there we can use it to generate PDFs, wiki documentation, etc
> > and so make it available in whatever format is convenient.
> 
> Works for me, I'm a plain text kinda guy.

Ok, I'll put together a basic repository and build framework for us
to work from.

> > The only thing I can think of that is obviously missing from this is
> > the process of problem diagnosis. e.g. what to do when something
> > goes wrong. The most common the mistake we see is trying to repair
> > the filesystem when th storage is still broken and making a bigger
> > mess. Having something that describes what to look for (e.g. raid
> > reconstruction getting disks out of order) and how to recover from
> > problems with as little risk and data loss as possible would be
> > invaluable.
> 
> Ahh ok.  So you're going for the big scope described in your Dec 13
> email, not the paltry "optimal RAID storage configuration for XFS"
> described above.  Now I understand the 1 hour a week question. :)

Well, that's where I'd like such a document to end up. Let's plan
for the big picture, but start with small chunks of work that slowly
fill in the big picture.

> I'll brain dump as much as I can, in a hopefully somewhat coherent
> starting doc.  I'll do my best starting the XFS troubleshooting part,
> but I'm much weaker here than with XFS architecture and theory.

That's fine, I don't expect you to write everything ;)

> >> I should be able to knock most of this out fairly quickly, but I'll need
> >> help on some of it.  For example I don't have any first hand experience
> >> with large high end workloads.  I could make up a plausible theoretical
> >> example but I'd rather have as many real-world workloads as possible.
> >> What I have in mind for workload examples is something like the
> >> following.  It would be great if list members who have one the workloads
> >> below would contribute their details and pointers, any secret sauce,
> >> etc.  Thus when we refer someone to this document they know they're
> >> reading of an actual real world production configuration.  Though I
> >> don't plan to name sites, people, etc, just the technical configurations.
> > 
> > 1. General purpose (i.e. unspecialised) configuration that should be
> > good for most users.
> 
> Format with XFS defaults.  Done. :)
> 
> What detail should go with this?  Are you thinking SOHO server here,
> single disk web server.  Anything with low IO rate and a smallish disk/RAID?

I'm not really thinking of a specific configuration here. This is
more a case of "don't [want to] care about optimisation" or "don't
know enough about the workload to optimise it", etc. So not really a
specific configuration, but more of "get the basics right"
configuration guideline.

> >> 1.  Small file, highly parallel, random IO
> >>  -- mail queue, maildir mailbox storage
> >>  -- HPC, filesystem as a database
> >>  -- ??
> > 
> > The hot topic of the moment that fits into this category is object
> > stores for distributed storage. i.e. gluster and ceph running
> > openstack storage layers like swift to store large numbers of
> > pictures of cats.
> 
> The direction I was really wanting to go here is highlighting the
> difference between striped RAID and linear concat, how XFS AG
> parallelism on concat can provide better performance than striping for
> some workloads, and why.  For a long time I've wanted to create a
> document about this with graphs containing "disk silo" icons, showing
> the AGs spanning the striped RAID horizontally and spanning the concat
> disks vertically, explaining the difference in seek patterns and how
> they affect a random IO workload.

I would expect that to be part of the "theory of operation" section
more than an example.

> Maybe I should make concat a separate topic entirely, as it can benefit
> multiple workload types, from the smallest to the largest storage
> setups.  XFS' ability to scale IO throughput nearly infinitely over
> concatenated storage is unique to Linux, and fairly unique to
> filesystems in general TTBOMK.  It is one of its greatest strengths.
> I'd like to cover this in good detail.

Right - and that's one of the reasons I mentioned that the NFS
server setups should be dealt with specially, as they are prime
candidates for optimisation via linear concatentation of RAID
stripes rather than nested stripes....

> >> 2.  Virtual machine consolidation w/mixed guest workload
> > 
> > There's a whole lot of stuff here that is dependent on exactly how
> > the VM infrastructure is set up, so this might be difficult to
> > simplify enough to be useful.
> 
> I was thinking along the lines of consolidating lots of relatively low
> IO throughput guests with thin provisioning, like VPS hosting.  For
> instance a KVM host and a big XFS, sparse files exported to Linux guests
> as drives.  Maybe nobody is doing this with XFS.

If you consider me nobody, then nobody is doing that. All my test
VMs are hosted this way using either sparse or preallocated files.
Make sure that you describe the use of extent size hints for sparse
image files to minimise fragmentation....

> >> Lemme know if this is ok or if you'd like it to take a different
> >> direction, if you have better or additional example workload classes,
> >> etc.  If mostly ok, I'll get started on the first 2 sections and fill in
> >> the 3rd as people submit examples.
> > 
> > It sounds good to me - I think that the first 2 sections are the
> > core of the work - it's the theory that is in our heads (i.e. the
> > black magic) that is simply not documented in a way that people can
> > use.
> 
> Agreed.
> 
> I'll get started.

Ok, I'll get a repo and build skeleton together, and we can go from
there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
