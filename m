Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0052B7F54
	for <xfs@OSS.SGI.com>; Sat, 25 Oct 2014 06:00:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4867304039
	for <xfs@OSS.SGI.com>; Sat, 25 Oct 2014 04:00:22 -0700 (PDT)
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	yVmLlBPDrICdMFoE for <xfs@OSS.SGI.com>;
	Sat, 25 Oct 2014 04:00:20 -0700 (PDT)
Received: from ty.sabi.co.UK (94.192.123.208) by woodbine.london.02.net
	(8.5.140)
	id 53BD9B4503C4A41B for xfs@OSS.SGI.com; Sat, 25 Oct 2014 12:31:29 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1Xhz4w-0002hp-9U
	for <xfs@OSS.SGI.com>; Sat, 25 Oct 2014 12:00:14 +0100
MIME-Version: 1.0
Message-ID: <21579.33469.878654.99125@tree.ty.sabi.co.uk>
Date: Sat, 25 Oct 2014 12:00:13 +0100
Subject: Re: Problem about very high Average Read/Write Request Time
In-Reply-To: <20141024214525.GA4317@dastard>
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>
	<20141018143848.3baf3266@galadriel.home>
	<21571.36364.518119.806191@tree.ty.sabi.co.uk>
	<5444C122.4080104@fastmail.fm>
	<21574.42382.795064.152229@tree.ty.sabi.co.uk>
	<54492AD5.3040704@fastmail.fm>
	<21577.24715.712978.617220@tree.ty.sabi.co.uk>
	<20141024214525.GA4317@dastard>
From: pg@xfs.list.sabi.co.UK (Peter Grandi)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@OSS.SGI.com>

> [ ... ] entitled to point out how tenuous your thread of logic
> is - if he didn't I was going to say exactly the same thing

You are both entitled to your opinions, but not to have them
unchallenged, also when they are bare statements.

> based entirely on a house of assumptions you haven't actually
> verified.

That seems highly imaginative as my guesses that conclusion that:

  http://oss.sgi.com/archives/xfs/2014-10/msg00335.html
  > This issue should be moved to the 'linux-raid' mailing list as
  > from the reported information it has nothing to do with XFS.
    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

were factually based:

  http://oss.sgi.com/archives/xfs/2014-10/msg00335.html
  > There is a ratio of 31 (thirty one) between 'swidth' and
  > 'sunit' and assuming that this reflects the geometry of the
  > RAID5 set and given commonly available disk sizes it can be
  > guessed that with amazing "bravery" someone has configured a
  > RAID5 out of 32 (thirty two) high capacity/low IOPS 3TB
  > drives, or something similar.

That there is a ratio of 31 is a verified fact, and so is that
the reported size of the block device was 100TB. Much of the
rest is arithmetic and I indicated that there were was some
guesswork involved, mostly assuming that those reported facts
were descriptive of the actual configuration.

Simply for brevity I did not also point out specifically that
the reported facts that =ABhigh r_await(160) and w_await(200000)=BB
and the "Subject:" =ABvery high Average Read/Write Request Time=BB
contributed to indicating a (big) issue with the storage layer.
and that the presumed width of the array of 32 is congruentn with
typical enclosure capacities.

Another poster went far further in guesswork, and stated what I
was describing as guesses instead as obvious facts:

  http://oss.sgi.com/archives/xfs/2014-10/msg00337.html
  > As others mentioned this isn't an XFS problem. The problem is that
  > your RAID geometry doesn't match your workload. Your very wide
  > parity stripe is apparently causing excessive seeking with your
  > read+write workload due to read-modify-write operations.

and went on to make a whole discussion wholly unrelated to XFS
based on that:

  > To mitigate this, and to increase resiliency, you should
  > switch to RAID6 with a smaller chunk. If you need maximum
  > capacity make a single RAID6 array with 16 KiB chunk size.
  > This will yield a 496 KiB stripe width, increasing the odds
  > that all writes are a full stripe, and hopefully eliminating
  > much of the RMW problem.
  =

  > A better option might be making three 10 drive RAID6 arrays
  > (two spares) with 32 KiB chunk, 256 KiB stripe width, and
  > concatenating the 3 arrays with mdadm --linear.

The above assumptions and offtopic suggestions have been
unquestioned; by myself too, even if I disagree with some of the
recommendations, also as I think them premature because we don't
know what the requirements really are beyond what can be guessed
from =ABthe reported information=BB. That's also why I suggested to
continue the discussion on the Linux RAID list.

The guess that the filesystem was meant to be an object store is
also based on a verified fact:

  > if the device name "/data/fhgfs/fhgfs_storage" is dedscriptive,
  > this "brave" RAID5 set is supposed to hold the object storage
  > layer of a BeeFS

Also BP did not initially question my analysis of the 100TB
filesystem case, but asked a wholly separate question asking to
explain this aside:

  > the object storage layer of a BeeFS highly parallel filesystem,
  > and therefore will likely have mostly-random accesses.

To that question I provided a reasonable and detailed
*technical* explanation, both as to the specific case and in
general, and linking it to both the original question by QH and
to the list topic which is XFS. As a reminder this thread seems
to me to contain 3 distinct even if connected *technical*
topics:

  * Whether the report about the 100TB RAID based XFS filesystem
    contained evidence indicating an XFS issue or a RAID issue;
    this was introduced by QH.
  * Whether concurrent randomish read-writes tend to be the
    workload observed by object stores in large parallel HPC
    systems; this was introduced by BP.
  * Whether concurrent randomish read-write would happen in the
    use of that specific filesystem as an object store; this was
    introduced by myself to link QH's original question to BP's
    new question, because strictly speaking BP's question seemed
    to me offtopic in the XFS mailing list.

Then BP seemed to switch topics again by mentioning 1 and 2
threaded read-write in the context of the general issue of the
access patterns of large parallel HPC filesystem object stores,
and that seemed strange to me, as I commented, so I ignore it.

> appropriate response would be to ask the OP to describe their
> workload and storage in more detail

Indeed, and I suggested to move the discussion to the Linux RAID
mailing list for that purpose, because the evidence quoted above
seemed to indicate that a 32-wide RAID5 was involved, as in:

  > This issue should be moved to the 'linux-raid' mailing list as
  > from the reported information it has nothing to do with XFS.
    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

This left free QH to report more information as someone asked to
indicate the issue was relevant more to the XFS list than to the
Linux RAID list, or to move to the Linux RAID list with more
details.

Again, the suggestion to continue the discussion in another list
that seemed more useful to QH was based on simple inferences
based on 3 reported facts: 31 ratio, 100TB size, "fast" single
threaded speed vs. slow concurrent read/write speeds (and the
concurrent high wait times).

You and BP are entitled to think those are not good guesses
(just as SH instead took them as good ones) and it would be
interesting if you provided substantive reason why the
suggestion to continue the discussion in the Linux RAID list was
inappropriate, but you haven't contributed any other than your
say-so.

Also while suggestions have been made to QH to provide more
details and/or move the discussion to the Linux RAID list by
different people, notably this has not happened yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
