Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IFGlPK058973 for <xfs@oss.sgi.com>; Tue, 18 May 2010 10:16:47 -0500
Received: from mail-qy0-f187.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FAA9156A674
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 08:20:06 -0700 (PDT)
Received: from mail-qy0-f187.google.com (mail-qy0-f187.google.com
	[209.85.221.187]) by cuda.sgi.com with ESMTP id
	aGcrRWifbr7w5SFn for <xfs@oss.sgi.com>;
	Tue, 18 May 2010 08:20:06 -0700 (PDT)
Received: by qyk17 with SMTP id 17so8288031qyk.12
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 08:19:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BF219A6.4010900@hardwarefreak.com>
References: <AANLkTikek9K8-BqNgee_tXz72beHpWEUl41YtDPrD-3P@mail.gmail.com>
	<4BF1EC44.7070803@hardwarefreak.com>
	<AANLkTin_WoxWP3JXHvflVVP_2fGzgbSVfpPW1KGiyd1z@mail.gmail.com>
	<4BF219A6.4010900@hardwarefreak.com>
Date: Tue, 18 May 2010 08:19:01 -0700
Message-ID: <AANLkTim93-4YueMBizXKLGRFka2vwqzJzDx5_P5gs0bl@mail.gmail.com>
Subject: Re: mounting hixfs (Hitachi "tuned" XFS) on 2.6 kernel
From: big beer <bigbeerjr@gmail.com>
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
To: xfs@oss.sgi.com

On Mon, May 17, 2010 at 9:37 PM, Stan Hoeppner <stan@hardwarefreak.com> wro=
te:
> big beer put forth on 5/17/2010 10:34 PM:
>>> On Mon, May 17, 2010 at 6:24 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
>>> big beer put forth on 5/17/2010 7:08 PM:
>>>
>>>> If anyone has any ideas on what to do, and/or where to start, I'd
>>>> greatly appreciate it.
>>>
>>> Why are you avoiding the obvious solution in favor of hacking?
>>>
>> Sending back to the list this time instead of Stan directly (Sorry Stan)=
 :)
>
> No problem. =A0I love my Tbird "reply-to-list" option. :)
>
>> The obvious solution for me would be a backup or rsync. Unfortunately
>> both of those have issues with this particular setup.
>>
>> Using a backup over the network to migrate will be way too slow
>> (days). There are way too many files to index and this poor little nas
>> box is already falling over with cpu load from daily activities. I can
>> quickly make a mirror on the storage, and move it over to another
>> larger host quickly (minutes). Mounting the FS on another machine will
>> greatly improve the time and accuracy, as I won't have to worry about
>> inconsistencies as it's a block level copy.
>
>> The black-box solution is also very painful to work with, no gcc, no
>> automake, no rsync, etc.
>> I would also think that for some reason I can't think of, it would be
>> nice to have support for this version of XFS be available for free for
>> others. Some other poor sap might find some value.
>>
>> So I went and changed the magic number to 0x58465342 by dumping the
>> 1st 512 bytes off the volume, editing, and writing back, now I'm
>> getting "Can't verify primary superblock". Using xfs_db to look at the
>> other superblocks indeed still shows HXFS. Any advise how I can
>> find/dump/re-write one of the other superblocks? I'd like to see if I
>> can change another one of them if xfs_repair will run.
>
> Seems to me you're taking some big chances with live data. =A0One wrong t=
urn
> and you could hose the FS and lose all the data, yes? =A0I'd rather give =
you
> recommendations not related to this current path you're taking. =A0Would =
you
> please provide the model or part number of this Hitachi NAS so I can get =
an
> idea of what exactly it is you're dealing with, and possibly offer other
> solutions?
>
> Maybe someone else here can help you pull this off via XFS. =A0I can't. =
=A0But
> I'll gladly spend some time researching other possible solutions, mainly
> getting a high capacity drive connected so you can do a cp -a or tar and =
be
> done with this overnight, in a data-safe manner.
>
> --
> Stan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>


It's called a eNAS, but it's really just 2 linux 2.4 blades (debian
woody), with failsafe (think heartbeat), LVM, custom XFS, samba, nfs,
and a pile of sudo available scripts that are 700 and a web based gui
to manage it.

I though about moving it via another FS on the NAS and then connecting
it to my target migration host also. The only exposed connections on
the hardware are ethernet, and it's integrated in the storage
subsystem. I'd have to call a tech  to even come take it out. So I'm
limited to something that is fiber attached to the sub-system, ok
that's fine, just means no USB disk or the like. The real problem is
that since I don't have root there is no way to create or mount any
other devices that contain another FS. The restrictive GUI/scripts
automatically creates and mounts FS's with their modified XFS version,
and there are no options to do otherwise.

I'm playing it "safe" by taking a block level copy of the luns that
are exposed to this thing, and then presenting the copy over to my
target host. I'm not brave enough to totally trash live data. I'm
going to give some of the suggestions a go with a fresh copy of the
data and see what comes of it.

Of course the 1st thing I did was call Hitachi support and ask them
what the deal is, dropping words like "GPL" and "license bound to
distribute", but to no avail. Of course I'm dealing with low level
support people that more than likely didn't work for the big H when
this thing was built. I've escalated through the channels I have
available to me.

We'll see what comes of it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
