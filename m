Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FFC57F7B
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 16:18:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1670AC003
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 14:18:13 -0700 (PDT)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	l8dpRPLtCMdCbTWL (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 14:18:12 -0700 (PDT)
Received: by mail-ie0-f172.google.com with SMTP id lx4so2354653iec.31
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 14:18:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140730081858.GN26465@dastard>
References: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>
	<20140729123815.GA13120@bfoster.bfoster>
	<20140729234151.GJ26465@dastard>
	<CAFLt3phu1kJUjFyP8-+zkRPEsiv8ue=c+W+Ym8PYS1zd3kHyzw@mail.gmail.com>
	<20140730081858.GN26465@dastard>
Date: Wed, 30 Jul 2014 23:18:11 +0200
Message-ID: <CAFLt3pjdwdSOxVhbTFemReyNr9HnUodA-NL5bND2yRJGX2GBuA@mail.gmail.com>
Subject: Re: Delaylog information enquiry
From: Grozdan <neutrino8@gmail.com>
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
Cc: Brian Foster <bfoster@redhat.com>, "Frank ." <frank_1005@msn.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jul 30, 2014 at 10:18 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jul 30, 2014 at 07:42:32AM +0200, Grozdan wrote:
>> On Wed, Jul 30, 2014 at 1:41 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > Note that this does not change file data behaviour. In this case you
>> > need to add the "sync" mount option, which forces all buffered IO to
>> > be synchronous and so will be *very slow*. But if you've already
>> > turned off the BBWC on the RAID controller then your storage is
>> > already terribly slow and so you probably won't care about making
>> > performance even worse...
>>
>> Dave, excuse my ignorant questions
>>
>> I know the Linux kernel keeps data in cache up to 30 seconds before a
>> kernel daemon flushes it to disk, unless
>> the configured dirty ratio (which is 40% of RAM, iirc) is reached
>
> 10% of RAM, actually.
>
>> before these 30 seconds so the flush is done before it
>>
>> What I did is lower these 30 seconds to 5 seconds so every 5 seconds
>> data is flushed to disk (I've set the dirty_expire_centisecs to 500).
>> So, are there any drawbacks in doing this?
>
> Depends on your workload. For a desktop, you probably won't notice
> anything different. For a machine that creates lots of temporary
> files and then removes them (e.g. build machines) then it could
> crater performance completely because it causes writeback before the
> files are removed...
>
>> I mean, I don't care *that*
>> much for performance but I do want my dirty data to be on
>> storage in a reasonable amount of time. I looked at the various sync
>> mount options but they all are synchronous so it is my
>> impression they'll be slower than giving the kernel 5 seconds to keep
>> data and then flush it.
>>
>> From XFS perspective, I'd like to know if this is not recommended or
>> if it is? I know that with setting the above to 500 centisecs
>> means that there will be more writes to disk and potentially may
>> result in tear & wear, thus shortening the lifetime of the
>> storage
>>
>> This is a regular desktop system with a single Seagate Constellation
>> SATA disk so no RAID, LVM, thin provision or anything else
>>
>> What do you think? :)
>
> I don't think it really matters either way. I don't change
> the writeback time on my workstations, build machines or test
> machines, but I actually *increase* it on my laptops to save power
> by not writing to disk as often. So if you want a little more
> safety, then reducing the writeback timeout shouldn't have any
> significant affect on performance or wear unless you are doing
> something unusual....
>
> Cheers,
>
> Dave.

Thanks Dave :)

I don't want to start another thread as this is my last question but
it's one unrelated to the original question from Frank

One of my partitions was almost full (there was 5 GB over according to
df -h). I had about 8 torrents open in the client, all sizes between 4
and 6 GB (they were all downloaded and got never "released" from the
client as I was seeding back). When I tried to add a torrent to
download which was 3 GB, the client reported that there was no more
space left over on the partition. I suspect this is related to
speculative preallocation and because the 8 torrents were all "open"
they still had extra space allocated by the speculative preallocation
and thus I couldn't add the 3GB torrent even though df says there was
5GB over but in reality it was much less. Am I correct on this or is
there something completely else that happened?

Thanks ;)

> --
> Dave Chinner
> david@fromorbit.com



-- 
Yours truly

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
