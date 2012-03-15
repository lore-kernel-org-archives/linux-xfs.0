Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2FE89dr134760 for <xfs@OSS.SGI.com>; Thu, 15 Mar 2012 09:08:09 -0500
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id dbVW4L14GwGQNqtW for
	<xfs@OSS.SGI.com>; Thu, 15 Mar 2012 07:08:07 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <20321.63389.586851.689070@tree.ty.sabi.co.UK>
Date: Thu, 15 Mar 2012 14:07:25 +0000
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
In-Reply-To: <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
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
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

>>> I want to create a raid10,n2 using 3 1TB SATA drives.
>>> I want to create an xfs filesystem on top of it. The
>>> filesystem will be used as NFS/Samba storage.

Consider also an 'o2' layout (it is probably the same thing for a
3 drive RAID10) or even a RAID5, as 3 drives and this usage seems
one of the few cases where RAID5 may be plausible.

> [ ... ] I've run some benchmarks with dd trying the different
> chunks and 256k seems like the sweetspot.  dd if=3D/dev/zero
> of=3D/dev/md0 bs=3D64k count=3D655360 oflag=3Ddirect

That's for bulk sequential transfers. Random-ish, as in a
fileserver perhaps with many smaller files, may not be the same,
but probably larger chunks are good.

>> [ ... ] What kernel version? =A0This can make a significant
>> difference in XFS metadata performance.

As an aside, that's a myth that has been propagandaized by DaveC
in his entertaining presentation not long ago.

There have been decent but no major improvements in XFS metadata
*performance*, but weaker implicit *semantics* have been made an
option, and these have a different safety/performance tradeoff
(less implicit safety, somewhat more performance), not "just"
better performance.

http://lwn.net/Articles/476267/
 =ABIn other words, instead of there only being a maximum of 2MB of
  transaction changes not written to the log at any point in time,
  there may be a much greater amount being accumulated in memory.

  Hence the potential for loss of metadata on a crash is much
  greater than for the existing logging mechanism.

  It should be noted that this does not change the guarantee that
  log recovery will result in a consistent filesystem.

  What it does mean is that as far as the recovered filesystem is
  concerned, there may be many thousands of transactions that
  simply did not occur as a result of the crash.

  This makes it even more important that applications that care
  about their data use fsync() where they need to ensure
  application level data integrity is maintained.=BB

>> =A0Your NFS/Samba workload on 3 slow disks isn't sufficient to
>> need that much in memory journal buffer space anyway.

That's probably true, but does no harm.

>> =A0XFS uses relatime which is equivalent to noatime WRT IO
>> reduction performance, so don't specify 'noatime'.

Uhm, not so sure, and 'noatime' does not hurt either.

> I just wanted to be explicit about it so that I know what is
> set just in case the defaults change

That's what I do as well, because relying on remembering exactly
what the defaults are can cause sometimes confusion. But it is a
matter of taste to a large degree, like 'noatime'.

>> In fact, it appears you don't need to specify anything in
>> mkfs.xfs or fstab, but just use the defaults. =A0Fancy that.

For NFS/Samba, especially with ACLs (SMB protocol), and
especially if one expects largish directories, and in general I
would recommend a larger inode size, at least 1024B, if not even
2048B.

Also, as a rule I want to make sure that the sector size is set
to 4096B, for future proofing (and recent drives not only have
4096B sectors but usually lie).

>> =A0And the one thing that might actually increase your
>> performance a little bit you didn't specify--sunit/swidth.

Especially 'sunit', as XFS ideally would align metadata on chunk
boundaries.

>> =A0However, since you're using mdraid, mkfs.xfs will calculate
>> these for you (which is nice as mdraid10 with odd disk count
>> can be a tricky calculation).

Ambiguous more than tricky, and not very useful, except the chunk
size.

>>> Will my files be safe even on sudden power loss?

The answer is NO, if you mean "absolutely safe". But see the
discussion at the end.

>> [ ... ] =A0Application write behavior does play a role.

Indeed, see the discussion at the end and ways to mitigate.

>> =A0UPS with shutdown scripts, and persistent write cache prevent
>> this problem. [ ... ]

There is always the problem of system crashes that don't depend
on power....

>>> Is barrier=3D1 enough?  Do i need to disable the write cache?
>>> with: hdparm -W0 /dev/sdb /dev/sdc /dev/sdd

>> Disabling drive write caches does decrease the likelihood of
>> data loss.

>>> I tried it but performance is horrendous.

>> And this is why you should leave them enabled and use
>> barriers. =A0Better yet, use a RAID card with BBWC and disable
>> the drive caches.

> Budget does not allow for RAID card with BBWC

You'd be surprised by how cheap you can get one. But many HW host
adapters with builtin cache have bad performance or horrid bugs,
so you'd have to be careful.

In any case that's not the major problem you have.

>>> Am I better of with ext4? Data safety/integrity is the
>>> priority and optimization affecting it is not acceptable.

XFS is the filesystem of the future ;-). I would choose it over
'ext4' in every plausible case.

> nightly backups will be stored on an external USB disk

USB is an unreliable, buggy transport, and slow, eSATA is
enormously better and faster.

> is xfs going to be prone to more data loss in case the
> non-redundant power supply goes out?

That's the wrong question entirely. Data loss can happen for many
other reasons, and XFS is probably one of the safest designs, if
properly used and configured. The problems are elsewhere.

> I just updated the kernel to 3.0.0-16.  Did they take out
> barrier support in mdraid? or was the implementation replaced
> with FUA?  Is there a definitive test to determine if the off
> the shelf consumer sata drives honor barrier or cache flush
> requests?

Usually they do, but that's the least of your worries. Anyhow a
test that occurs to me is to write a know pattern to a file,
let's say 1GiB, then 'fsync', and as soon as 'fsync' completes,
power off. Then check whether the whole 1GiB is the known pattern.

> I think I'd like to go with device cache turned ON and barrier
> enabled.

That's how it is supposed to work.

As to general safety issues, there seem to be some misunderstanding, =

and I'll try to be more explicit than "lob the grenade" notion.

It matters a great deal what "safety" means in your mind and that
of your users. As a previous comment pointed out, that usually
involves backups, that is data that has already been stored.

But your insistence on power off and disk caches etc. seems to
indicate that "safety" in your mind means "when I click the
'Save' button it is really saved and not partially".

As to that there quite a lot of qualifiers:

  * Most users don't understand that even in the best scenario a
    file is really saved not when they *click* the 'Save' button,
    but when they get the "Saved!" message. In between anything
    can happen. Also, work in progress (not yet saved explicitly)
    is fair game.

  * "Really saved" is an *application* concern first and foremost.
    The application *must* say (via 'fsync') that it wants the
    data really saved. Unfortunately most applications don't do
    that because "really saved" is a very expensive operation, and
    usually sytems don't crash, so the application writer looks
    like a genius if he has an "optimistic" attitude. If you do a
    web search look for various O_PONIES discussions. Some intros:

      http://lwn.net/Articles/351422/
      http://lwn.net/Articles/322823/

  * XFS (and to a point 'ext4') is designed for applications that
    work correctly and issue 'fsync' appropriately, and if they do
    it is very safe, because it tries hard to ensure that either
    'fsync' means "really saved" or you know that it does not. XFS
    takes advantage of the assumption that applications do the
    right thing to do various latency-based optimizations between
    calls to 'fsync'.

  * Unfortunately most GUI applications don't do the right thing,
    but fortunately you can compensate for that. The key here is
    to make sure that the flusher's parameter are set for rather
    more frequent flushing than the default, which is equivalent
    to issuing 'fsync' systemwide fairly frequently. Ideally set
    'vm/dirty_bytes' to something like 1-3 seconds of IO transfer
    rate (and in reversal on some of my previous advice leave
    'vm/dirty_background_bytes' to something quite large unless
    you *really* want safety), and to shorten significantly
    'vm/dirty_expire_centisecs', 'vm/dirty_writeback_centisecs'.
    This defeats some XFS optimizations, but that's inevitable.

  * In any case you are using NFS/Samba, and that opens a much
    bigger set of issues, because caching happens on the clients
    too: http://www.sabi.co.uk/0707jul.html#070701b

Then Von Neuman help you if your users or you decide to store lots
of messages in MH/Maildir style mailstores, or VM images on
"growable" virtual disks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
