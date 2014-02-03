Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B12B57F62
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 22:39:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 772C0304043
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 20:39:22 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id TZaFHO4nsd0iC2PB
	for <xfs@oss.sgi.com>; Sun, 02 Feb 2014 20:39:18 -0800 (PST)
Message-ID: <52EF1D76.6070302@hardwarefreak.com>
Date: Sun, 02 Feb 2014 22:39:18 -0600
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
In-Reply-To: <20140202213030.GQ2212@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Chris Murphy <lists@colorremedies.com>
Cc: xfs <xfs@oss.sgi.com>

On 2/2/2014 3:30 PM, Dave Chinner wrote:
> On Sun, Feb 02, 2014 at 11:09:11AM -0700, Chris Murphy wrote:
>> On Feb 1, 2014, at 2:44 PM, Stan Hoeppner <stan@hardwarefreak.com>
>> wrote:
>>> On 2/1/2014 2:55 PM, Chris Murphy wrote:
>>>> On Feb 1, 2014, at 11:47 AM, Stan Hoeppner
>>>> <stan@hardwarefreak.com> wrote:
>>> When nesting stripes, the chunk size of the outer stripe is
>>> -always- equal to the stripe width of each inner striped array,
>>> as I clearly demonstrated earlier:
>>
>> Except when it's hardware raid6, and software raid0, and the user
>> doesn't know they need to specify the chunk size in this manner.
>> And instead they use the mdadm default. What you're saying makes
>> complete sense, but I don't think this is widespread knowledge or
>> well documented anywhere that regular end users would know this by
>> and large.
> 
> And that is why this is a perfect example of what I'd like to see
> people writing documentation for.
> 
> http://oss.sgi.com/archives/xfs/2013-12/msg00588.html
> 
> This is not the first time we've had this nested RAID discussion,
> nor will it be the last. However, being able to point ot a web page
> or or documentation makes it a whole lot easier.....
> 
> Stan - any chance you might be able to spare an hour a week to write
> something about optimal RAID storage configuration for XFS?

I could do more, probably rather quickly.  What kind of scope, format,
style?  Should this be structured as reference manual style
documentation, FAQ, blog??  I'm leaning more towards reference style.

How about starting with a lead-in explaining why the workload should
always drive storage architecture.  Then I'll describe the various
standard and nested RAID levels, concatenations, etc and some
dis/advantages of each.  Finally I'll give examples of a few common and
a high end workloads, one or more storage architectures suitable for
each and why, and how XFS should be configured optimally for each
workload and stack combination WRT geometry, AGs, etc.  I could also
touch on elevator selection and other common kernel tweaks often needed
with XFS.

I could provide a workload example with each RAID level/storage
architecture in lieu of the separate workload section.  Many readers
would probably like to see it presented in that manner as they often
start at the wrong end of the tunnel.  However, that would be
antithetical to the assertion that the workload drives the stack design,
which is a concept we want to reinforce as often as possible I think.
So I think the former 3 section layout is better.

I should be able to knock most of this out fairly quickly, but I'll need
help on some of it.  For example I don't have any first hand experience
with large high end workloads.  I could make up a plausible theoretical
example but I'd rather have as many real-world workloads as possible.
What I have in mind for workload examples is something like the
following.  It would be great if list members who have one the workloads
below would contribute their details and pointers, any secret sauce,
etc.  Thus when we refer someone to this document they know they're
reading of an actual real world production configuration.  Though I
don't plan to name sites, people, etc, just the technical configurations.

1.  Small file, highly parallel, random IO
 -- mail queue, maildir mailbox storage
 -- HPC, filesystem as a database
 -- ??

2.  Virtual machine consolidation w/mixed guest workload

3.  Large scale database
 -- transactional
 -- warehouse, data mining
 -- ??

4.  High bandwidth parallel streaming
 -- video ingestion/playback
 -- satellite data capture
 -- other HPC ??

5.  Large scale NFS server, mixed client workload

Lemme know if this is ok or if you'd like it to take a different
direction, if you have better or additional example workload classes,
etc.  If mostly ok, I'll get started on the first 2 sections and fill in
the 3rd as people submit examples.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
