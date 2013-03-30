Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90FB27F93
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 12:40:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7231C8F8049
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 10:40:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nkm3H0mWWh5K9OnQ for <xfs@oss.sgi.com>;
	Sat, 30 Mar 2013 10:40:10 -0700 (PDT)
Message-ID: <5157237A.40006@sandeen.net>
Date: Sat, 30 Mar 2013 12:40:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling  --  EXT4 journal replay discussion
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	(sfid-20130319_091205_759083_BA6F1AD2)
	<201303190924.29362.Martin@lichtvoll.de>
	<51483A7D.9050202@hardwarefreak.com>
	<5156DF72.1090703@hardwarefreak.com>
In-Reply-To: <5156DF72.1090703@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On 3/30/13 7:49 AM, Stan Hoeppner wrote:
> On 3/19/2013 5:14 AM, Stan Hoeppner wrote:
>> On 3/19/2013 3:24 AM, Martin Steigerwald wrote:
> ...
>>> Heck, even I was confused at first. Cause the manpage of fsck.ext4 IMHO is 
>>> not really clear about that topic to say the least. I tested it out for a 
>>> reason.
>>
>> I already contacted Ted off list hoping he can point me to the relevant
>> kernel documentation, so I don't make such a mistake again with EXT.
> 
> Ok, so here's the skinny on the source of our confusion WRT how/when
> EXT4 replays journals, and it's rather interesting.  Ted Ts'o explained
> the following.

Where was this, out of curiosity?

> The EXT4 kernel module does have code to perform journal replay, but it
> is rarely executed.  The reasons for this are:
> 
> 1.  EXT4 journal replay can take a lot of time (whereas XFS is instant)
> 2.  EXT4 systems tend to have multiple filesystems, often one per drive
>     (whereas XFS systems tend to have few filesystems)

Those are, I think, gross generalizations.  Journal replay takes as
long as it takes to replay all the IO required, which can vary greatly.
And TBH I have no idea where the notion came from that systems have many
ext4 filesystems but few xfs filesystems.

> 3.  Linux mounts filesystems serially during startup

I think that is correct.

> To prevent potentially lengthy boot times, the init scripts run e2fsck
> to replay all EXT4 filesystem journals in parallel, well before the
> mount stage.  

I'd never heard this rationale before, but I could believe that maybe
parallel log replays from userspace are faster, although it probably
depends a lot on how many spindles are available to do the work - fsck
avoids running in parallel for filesystems on the same physical disk,
at least according to the manpage.

> Thus the only case where the EXT4 kernel module performs
> journal replay is when doing a mount while the system is running, e.g.
> USB hard drive.

Or when running xfstests ;)  Technically, it does replay when the kernel
mount code finds a dirty log.  That's interesting, though, I hadn't thought
about how most systems probably don't get a ton of coverage of kernelspace
ext[34] log replay.

> There are other reasons e2fsck was chosen to perform journal replay at
> boot in addition to the speed issue, but as I understood Ted this is the
> main reason.

Ok, I can see some rationale to parallel userspace log replays; it'd be
interesting to actually measure that result, though.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
