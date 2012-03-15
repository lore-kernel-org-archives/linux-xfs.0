Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2FGIiT7151961 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 11:18:44 -0500
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id KYO7ppcWtlgvDEwu
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Mar 2012 09:18:42 -0700 (PDT)
Received: by lahc1 with SMTP id c1so2722412lah.26
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 09:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20321.63389.586851.689070@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
Date: Fri, 16 Mar 2012 00:18:41 +0800
Message-ID: <CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
From: Jessie Evangelista <jessie.evangelista@gmail.com>
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

Hey Peter,

On Thu, Mar 15, 2012 at 10:07 PM, Peter Grandi <pg@lxra2.to.sabi.co.uk> wro=
te:
>>>> I want to create a raid10,n2 using 3 1TB SATA drives.
>>>> I want to create an xfs filesystem on top of it. The
>>>> filesystem will be used as NFS/Samba storage.
>
> Consider also an 'o2' layout (it is probably the same thing for a
> 3 drive RAID10) or even a RAID5, as 3 drives and this usage seems
> one of the few cases where RAID5 may be plausible.

Thanks for reminding me about raid5. I'll probably give it a try and
do some benchmarks. I'd also like to try raid10f2.

>> [ ... ] I've run some benchmarks with dd trying the different
>> chunks and 256k seems like the sweetspot. =A0dd if=3D/dev/zero
>> of=3D/dev/md0 bs=3D64k count=3D655360 oflag=3Ddirect
>
> That's for bulk sequential transfers. Random-ish, as in a
> fileserver perhaps with many smaller files, may not be the same,
> but probably larger chunks are good.
>>> [ ... ] What kernel version? =A0This can make a significant
>>> difference in XFS metadata performance.
>
> As an aside, that's a myth that has been propagandaized by DaveC
> in his entertaining presentation not long ago.
>
> There have been decent but no major improvements in XFS metadata
> *performance*, but weaker implicit *semantics* have been made an
> option, and these have a different safety/performance tradeoff
> (less implicit safety, somewhat more performance), not "just"
> better performance.
>
> http://lwn.net/Articles/476267/
> =A0=ABIn other words, instead of there only being a maximum of 2MB of
> =A0transaction changes not written to the log at any point in time,
> =A0there may be a much greater amount being accumulated in memory.
>
> =A0Hence the potential for loss of metadata on a crash is much
> =A0greater than for the existing logging mechanism.
>
> =A0It should be noted that this does not change the guarantee that
> =A0log recovery will result in a consistent filesystem.
>
> =A0What it does mean is that as far as the recovered filesystem is
> =A0concerned, there may be many thousands of transactions that
> =A0simply did not occur as a result of the crash.
>
> =A0This makes it even more important that applications that care
> =A0about their data use fsync() where they need to ensure
> =A0application level data integrity is maintained.=BB
>
>>> =A0Your NFS/Samba workload on 3 slow disks isn't sufficient to
>>> need that much in memory journal buffer space anyway.
>
> That's probably true, but does no harm.
>
>>> =A0XFS uses relatime which is equivalent to noatime WRT IO
>>> reduction performance, so don't specify 'noatime'.
>
> Uhm, not so sure, and 'noatime' does not hurt either.
>
>> I just wanted to be explicit about it so that I know what is
>> set just in case the defaults change
>
> That's what I do as well, because relying on remembering exactly
> what the defaults are can cause sometimes confusion. But it is a
> matter of taste to a large degree, like 'noatime'.
>
>>> In fact, it appears you don't need to specify anything in
>>> mkfs.xfs or fstab, but just use the defaults. =A0Fancy that.
>
> For NFS/Samba, especially with ACLs (SMB protocol), and
> especially if one expects largish directories, and in general I
> would recommend a larger inode size, at least 1024B, if not even
> 2048B.

thanks for this tip. will look into adjusting inode size.

>
> Also, as a rule I want to make sure that the sector size is set
> to 4096B, for future proofing (and recent drives not only have
> 4096B sectors but usually lie).
>

it seems the 1TB drivers that I have still have 512byte sectors

>>> =A0And the one thing that might actually increase your
>>> performance a little bit you didn't specify--sunit/swidth.
>
> Especially 'sunit', as XFS ideally would align metadata on chunk
> boundaries.
>
>>> =A0However, since you're using mdraid, mkfs.xfs will calculate
>>> these for you (which is nice as mdraid10 with odd disk count
>>> can be a tricky calculation).
>
> Ambiguous more than tricky, and not very useful, except the chunk
> size.
>
>>>> Will my files be safe even on sudden power loss?
>
> The answer is NO, if you mean "absolutely safe". But see the
> discussion at the end.
>
>>> [ ... ] =A0Application write behavior does play a role.
>
> Indeed, see the discussion at the end and ways to mitigate.
>
>>> =A0UPS with shutdown scripts, and persistent write cache prevent
>>> this problem. [ ... ]
>
> There is always the problem of system crashes that don't depend
> on power....
>
>>>> Is barrier=3D1 enough? =A0Do i need to disable the write cache?
>>>> with: hdparm -W0 /dev/sdb /dev/sdc /dev/sdd
>
>>> Disabling drive write caches does decrease the likelihood of
>>> data loss.
>
>>>> I tried it but performance is horrendous.
>
>>> And this is why you should leave them enabled and use
>>> barriers. =A0Better yet, use a RAID card with BBWC and disable
>>> the drive caches.
>
>> Budget does not allow for RAID card with BBWC
>
> You'd be surprised by how cheap you can get one. But many HW host
> adapters with builtin cache have bad performance or horrid bugs,
> so you'd have to be careful.

could you please suggest a hardware raid card with BBU that's cheap?

>
> In any case that's not the major problem you have.
>
>>>> Am I better of with ext4? Data safety/integrity is the
>>>> priority and optimization affecting it is not acceptable.
>
> XFS is the filesystem of the future ;-). I would choose it over
> 'ext4' in every plausible case.
>
>> nightly backups will be stored on an external USB disk
>
> USB is an unreliable, buggy transport, and slow, eSATA is
> enormously better and faster.
>
>> is xfs going to be prone to more data loss in case the
>> non-redundant power supply goes out?
>
> That's the wrong question entirely. Data loss can happen for many
> other reasons, and XFS is probably one of the safest designs, if
> properly used and configured. The problems are elsewhere.

Can you please elaborate how xfs can be properly used and configured?
>
>> I just updated the kernel to 3.0.0-16. =A0Did they take out
>> barrier support in mdraid? or was the implementation replaced
>> with FUA? =A0Is there a definitive test to determine if the off
>> the shelf consumer sata drives honor barrier or cache flush
>> requests?
>
> Usually they do, but that's the least of your worries. Anyhow a
> test that occurs to me is to write a know pattern to a file,
> let's say 1GiB, then 'fsync', and as soon as 'fsync' completes,
> power off. Then check whether the whole 1GiB is the known pattern.
>
>> I think I'd like to go with device cache turned ON and barrier
>> enabled.
>
> That's how it is supposed to work.
>
> As to general safety issues, there seem to be some misunderstanding,
> and I'll try to be more explicit than "lob the grenade" notion.
>
> It matters a great deal what "safety" means in your mind and that
> of your users. As a previous comment pointed out, that usually
> involves backups, that is data that has already been stored.
>
> But your insistence on power off and disk caches etc. seems to
> indicate that "safety" in your mind means "when I click the
> 'Save' button it is really saved and not partially".
>
let me define safety as needed by the usecase:
fileA is a 2MB open office document file already existing on the file syste=
m.
userA opens fileA locally, modifies a lot of lines and attempts to save it.
as the saving operation is proceeding, the PSU goes haywire and power
is cut abruptly.
When the system is turned on, i expect some sort of recovery process
to bring the filesystem to a consistent state.
I expect fileA should be as it was before the save operation and
should not be corrupted in anyway.
Am I asking/expecting too much?

> As to that there quite a lot of qualifiers:
>
> =A0* Most users don't understand that even in the best scenario a
> =A0 =A0file is really saved not when they *click* the 'Save' button,
> =A0 =A0but when they get the "Saved!" message. In between anything
> =A0 =A0can happen. Also, work in progress (not yet saved explicitly)
> =A0 =A0is fair game.
>
> =A0* "Really saved" is an *application* concern first and foremost.
> =A0 =A0The application *must* say (via 'fsync') that it wants the
> =A0 =A0data really saved. Unfortunately most applications don't do
> =A0 =A0that because "really saved" is a very expensive operation, and
> =A0 =A0usually sytems don't crash, so the application writer looks
> =A0 =A0like a genius if he has an "optimistic" attitude. If you do a
> =A0 =A0web search look for various O_PONIES discussions. Some intros:
>
> =A0 =A0 =A0http://lwn.net/Articles/351422/
> =A0 =A0 =A0http://lwn.net/Articles/322823/
>
> =A0* XFS (and to a point 'ext4') is designed for applications that
> =A0 =A0work correctly and issue 'fsync' appropriately, and if they do
> =A0 =A0it is very safe, because it tries hard to ensure that either
> =A0 =A0'fsync' means "really saved" or you know that it does not. XFS
> =A0 =A0takes advantage of the assumption that applications do the
> =A0 =A0right thing to do various latency-based optimizations between
> =A0 =A0calls to 'fsync'.
>
> =A0* Unfortunately most GUI applications don't do the right thing,
> =A0 =A0but fortunately you can compensate for that. The key here is
> =A0 =A0to make sure that the flusher's parameter are set for rather
> =A0 =A0more frequent flushing than the default, which is equivalent
> =A0 =A0to issuing 'fsync' systemwide fairly frequently. Ideally set
> =A0 =A0'vm/dirty_bytes' to something like 1-3 seconds of IO transfer
> =A0 =A0rate (and in reversal on some of my previous advice leave
> =A0 =A0'vm/dirty_background_bytes' to something quite large unless
> =A0 =A0you *really* want safety), and to shorten significantly
> =A0 =A0'vm/dirty_expire_centisecs', 'vm/dirty_writeback_centisecs'.
> =A0 =A0This defeats some XFS optimizations, but that's inevitable.
>
> =A0* In any case you are using NFS/Samba, and that opens a much
> =A0 =A0bigger set of issues, because caching happens on the clients
> =A0 =A0too: http://www.sabi.co.uk/0707jul.html#070701b
>
> Then Von Neuman help you if your users or you decide to store lots
> of messages in MH/Maildir style mailstores, or VM images on
> "growable" virtual disks.

what's wrong with VM images on "growable" virtual disks. are you
saying not to rely on lvm2 volumes?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
