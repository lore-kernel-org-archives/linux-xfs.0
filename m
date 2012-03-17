Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2HFZDK1086942 for <xfs@oss.sgi.com>; Sat, 17 Mar 2012 10:35:15 -0500
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id rcHrtxyAqAKilqjG for
	<xfs@oss.sgi.com>; Sat, 17 Mar 2012 08:35:12 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <20324.44842.473837.511238@tree.ty.sabi.co.UK>
Date: Sat, 17 Mar 2012 15:35:06 +0000
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
In-Reply-To: <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
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

[ ... ]

> I've read a recommendation to start the partition on the 1MB
> mark. Does this make sense?

As a general principle it is good, that has almost no cost.
Indeed recent versions of some partitionig tools do that by
default.

I often recommend aligning partitions to 1GiB, also because I
like to have 1GiB or so of empty space at the very beginning and
end of a drive.

> I'd like to read about the NFS blog entry but the link you
> included results in a 404.  I forgot to mention in my last
> reply.

Oops I forgot a bit of the URL:
  http://www.sabi.co.uk/blog/0707jul.html#070701b

Note that currently I suggest different values from:

 =ABvm/dirty_ratio                  =3D4
  vm/dirty_background_ratio       =3D2=BB

Because:

  * 4% of memory "dirty" today is often a gigantic amount.
    I had provided an elegant patch to specify the same in
    absolute terms in
      http://www.sabi.co.uk/blog/0707jul.html#070701
    but now the official way is the "_bytes" alternative.

  * 2% as the level at which writing becomes uncached is too
    low, and the system become unresposive when that level is
    crossed. Sure it is risky, but, regretfully, I think that
    maintaining responsiveness is usually better than limiting
    outstanding background writes.

> Based on what I understood from your thoughts above, if an
> applications issues a flush/fsync and it does not complete due
> to some catastrophic crash, xfs on its own can not roll back
> to the prev version of the file in case of unfinished write
> operation. disabling the device caches wouldn't help either
> right?

If your goal is to make sure incomplete updates don't get
persisted, disabling device caches might help with that, in a
very perverse way (if the whole partial update is still in the
device cache, it just vanishes). Forget that of course :-).

The main message is that filesystems in UNIX-like system should
not provide atomic transactions, just the means to do them at
the applications level, because they are both difficult and very
expensive.

The secondary message is that some applications and the firmware
of some host adpters and drives don't do the right thing, and
if your really want to make sure about atomic transactions it is
an expensive and difficult system integration challenge.

> [ ... ] only filesystems that do COW can do this at the
> expense of performance? (btrfs and zfs, please hurry and grow
> up!)

Filesystems that do COW sort-of do *global* "rolling" updates,
that is filtree level snapshots, but that's a side effect of a
choice made for other reasons (consistency more than currency).

> [ ... ] If you were in my place with the resource constraints,
> you'd go with: xfs with barriers on top of mdraid10 with
> device cache ON and setting vm/dirty_bytes, [ ... ]

Yes, that seems a reasonable overall tradeoff, because XFS is
implemented to provide well defined (and documented) semantics,
to check whether the underlying storage layer actually does
barriers, and to perform decently even if "delayed" writing is
not that delayed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
