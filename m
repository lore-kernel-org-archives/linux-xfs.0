Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 18:56:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0N2uRfb010311
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 18:56:30 -0800
Date: Wed, 23 Jan 2008 13:57:37 +1100
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local> <20080119004018.GH155407@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local>
Message-ID: <op.t5c3ubfg3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F0253596D@pvn-3001.purevideo.local>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: xfs@oss.sgi.com

On Wed, 23 Jan 2008 06:40:52 +1100, Mark Magpayo <mmagpayo@purevideo.com>  
wrote:

>
>> -----Original Message-----
>> From: David Chinner [mailto:dgc@sgi.com]
>> Sent: Friday, January 18, 2008 4:40 PM
>> To: Mark Magpayo
>> Cc: David Chinner; xfs@oss.sgi.com
>> Subject: Re: Repairing a possibly incomplete xfs_growfs command?
>>
>> On Fri, Jan 18, 2008 at 09:50:37AM -0800, Mark Magpayo wrote:
>> > > > So is this all I need then prior to an xfs_repair?:
>> > > >
>> > > > > # for i in `seq 0 1 63`; do
>> > > > > > xfs_db -x -c "sb $i" -c 'write agcount 64' -c 'write dblock
>> > > 4761733120'
>> > > > > /dev/vg0/lv0
>> > >
>> > > Yes, I think that is all that is necessary (that+repair was what
> fixed
>> > > the problem at the customer site successfully).
>> > >
>> >
>> > Is this supposed to be the proper output to the command above?
>> >
>> > purenas:~# for i in `seq 0 1 63`; do xfs_db -x -c "sb $i" -c 'write
>> > agcount 64' -c 'write dblock 4761733120' /dev/vg0/lv0; done
>> > agcount = 64
>> > field dblock not found
>> > parsing error
>>
>> Ah - As eric pointed out, that should be "dblocks".
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> Principal Engineer
>> SGI Australian Software Group
>
> Any ideas on how long the xfs_repair is supposed to take on 18TB?  I
> started it Friday nite, and it's now Tuesday afternoon.  It's stuck
> here:
>
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>
> I figure traversing a filesystem of 18TB takes a while, but does 4 days
> sound right?

Was it stuck on Phase 6 all that time? With only 1GB of RAM (from your
meminfo output) and 18TB filesystem, Phases 3 and 4 will take a very
long time due to swapping.

Phase 6 in your scenario should be relatively quick and light on
memory usage (500MB as reported in your other email).

It is feasible it is deadlocked by trying to double-access a buffer,
or access a buffer that wasn't released. This is an unlikely scenario,
but it is possible.

Regards,
Barry.
