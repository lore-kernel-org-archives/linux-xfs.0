Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 207897F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 12:11:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 004F3304064
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 10:11:16 -0700 (PDT)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	vEXh2SZaqabKGBp8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 10:11:12 -0700 (PDT)
Received: by mail-ig0-f179.google.com with SMTP id hn18so662376igb.12
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 10:11:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140513090321.GR26353@dastard>
References: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
	<20140305233551.GK6851@dastard>
	<CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
	<CANGgnMa80WwQ8zSkL52yYegmQURVQeZiBFv41=FQXMZJ_NaEDw@mail.gmail.com>
	<20140513034647.GA5421@dastard>
	<CANGgnMZ0q9uE3NHj2i0SBK1d0vdKLx7QBJeFNb+YwP-5EAmejQ@mail.gmail.com>
	<20140513063943.GQ26353@dastard>
	<CANGgnMYn++1++UyX+D2d9GxPxtytpQJv0ThFwdxM-yX7xDWqiA@mail.gmail.com>
	<20140513090321.GR26353@dastard>
Date: Tue, 13 May 2014 10:11:11 -0700
Message-ID: <CANGgnMZqQc_NeaDpO_aX+bndmHrQ9VWo9mkfxhPBkRD-J=N6sQ@mail.gmail.com>
Subject: Re: XFS crash?
From: Austin Schuh <austin@peloton-tech.com>
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

On Tue, May 13, 2014 at 2:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, May 13, 2014 at 12:02:18AM -0700, Austin Schuh wrote:
>> On Mon, May 12, 2014 at 11:39 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, May 12, 2014 at 09:03:48PM -0700, Austin Schuh wrote:
>> >> On Mon, May 12, 2014 at 8:46 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Mon, May 12, 2014 at 06:29:28PM -0700, Austin Schuh wrote:
>> >> >> On Wed, Mar 5, 2014 at 4:53 PM, Austin Schuh <austin@peloton-tech.com> wrote:
>> >> >> > Hi Dave,
>> >> >> >
>> >> >> > On Wed, Mar 5, 2014 at 3:35 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> >> >> On Wed, Mar 05, 2014 at 03:08:16PM -0800, Austin Schuh wrote:
>> >> >> >>> Howdy,
>> >> >> >>>
>> >> >> >>> I'm running a config_preempt_rt patched version of the 3.10.11 kernel,
>> >> >> >>> and I'm seeing a couple lockups and crashes which I think are related
>> >> >> >>> to XFS.
>> >> >> >>
>> >> >> >> I think they ar emore likely related to RT issues....
>> >> >> >>
>> >> >> >
>> >> >> > That very well may be true.
>> >> >> >
>> >> >> >> Cheers,
>> >> >> >>
>> >> >> >> Dave.
>> >> >> >> --
>> >> >> >> Dave Chinner
>> >> >>
>> >> >> I had the issue reproduce itself today with just the main SSD
>> >> >> installed.  This was on a new machine that was built this morning.
>> >> >> There is a lot less going on in this trace than the previous one.
>> >> >
>> >> > The three blocked threads:
>> >> >
>> >> >         1. kworker running IO completion waiting on an inode lock,
>> >> >            holding locked pages.
>> >> >         2. kworker running writeback flusher work waiting for a page lock
>> >> >         3. direct flush work waiting for allocation, holding page
>> >> >            locks and the inode lock.
>> >> >
>> >> > What's the kworker thread running the allocation work doing?
>> >> >
>> >> > You might need to run `echo w > proc-sysrq-trigger` to get this
>> >> > information...
>> >>
>> >> I was able to reproduce the lockup.  I ran `echo w >
>> >> /proc/sysrq-trigger` per your suggestion.  I don't know how to figure
>> >> out what the kworker thread is doing, but I'll happily do it if you
>> >> can give me some guidance.
>> >
>> > There isn't a worker thread blocked doing an allocation in that
>> > dump, so it doesn't shed any light on the problem at all. try
>> > `echo l > /proc/sysrq-trigger`, followed by `echo t >
>> > /proc/sysrq-trigger` so we can see all the processes running on CPUs
>> > and all the processes in the system...
>> >
>> > Cheers,
>> >
>> > Dave.
>>
>> Attached is the output of the two commands you asked for.
>
> Nothing there. There's lots of processes waiting for allocation to
> run, and no kworkers running allocation work. This looks more
> like a rt-kernel workqueue issue, not an XFS problem.
>
> FWIW, it woul dbe really helpful if you compiled your kernels with
> frame pointers enabled - the stack traces are much more precise and
> readable (i.e. gets rid of all the false/stale entrys) and that
> helps understanding where things are stuck immensely.
>
> Cheers,
>
> Dave.

Thanks Dave.

I'll go check with the rt-kernel guys and take it from there.  Thanks
for the frame pointers suggestion.  I'll make that change the next
time I build a kernel.

Austin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
