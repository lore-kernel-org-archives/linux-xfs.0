Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2I29wDo160264 for <xfs@oss.sgi.com>; Sat, 17 Mar 2012 21:09:59 -0500
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	tQvHqnowkqvh32Na for <xfs@oss.sgi.com>;
	Sat, 17 Mar 2012 19:09:57 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <20325.10093.799412.765971@tree.ty.sabi.co.UK>
Date: Sun, 18 Mar 2012 00:08:13 +0000
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier (GiB alignment)
In-Reply-To: <4F650493.7080709@gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
	<20324.44842.473837.511238@tree.ty.sabi.co.UK>
	<4F650493.7080709@gmail.com>
From: pg@lxra2.for.to.sabi.co.UK (Peter Grandi)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

>> I often recommend aligning partitions to 1GiB, also because I
>> like to have 1GiB or so of empty space at the very beginning
>> and end of a drive.

> I'm really curious why do you use such alignment? I can think
> about few reasons, but most practical I think you like to
> slice in gigabyte sizes.

Indeed, and to summarize:

* As mentioned before, I usually leave a chunk of unused space
  at the very start and end of a drive. This also because:
  - Many head landing accidents happen at the start or end of a
    drive.
  - Free space at the start: sometimes it is useful to have a
    few seconds of grace at the start when duplicating a drive
    to realize one has mistyped the name, and many partitioning
    or booting schemes can use a bit of free space at the start.
    Consider XFS and its use of sector 0.
  - Free space at the end: many drives have slightly different
    sizes, and this can cause problems when for example
    rebuilding arrays, or doing backups, and leaving some bit
    unused can avoid a lot of trouble.

* Having even sizes for partitions means that it may be easier
  to image copy them from one drive to another. I often to do
  that. Indeed I usually create partitions of a few "standard"
  sizes, usually tailored to fit drives that tend also to come
  in fairly standard increments, because drive manufacturers in
  each new platter generation usually aim at a fairly standard
  factor of improvement. Standard drive sizes tend to be, in
  gigabytes: 80 160 250 500 1000 1500 2000 3000. Since 80 and
  160 are somewhat old and no longer used, I currently tend to
  do partitions in sizes like 230GiB, 460GiB, 920GiB etc. SSDs
  have somewhat complicated this.

* On a contemporary drive 1GiB is a rather small fraction of the
  capacity of a drive, so why not just align everything to 1GiB,
  even if it seems pretty large in absolute terms? And if you
  align the first partition to start at 1GiB, and leave free
  space at the end, it is farily natural to align everything in
  between on 1GiB boundaries.

In this as in many other cases I like to buy myself some extra
degrees of freedom if they are cheap.

Another example I have written about previously is specifying
advisedly chosen 'sunit' and 'swidth' even on non-RAID volumes,
or non-parity RAID setups, not because they really improve
things, but because the cost is minimal and it might come useful
later.

  Note: I *really* like to be able to do partition image copies,
    because they are so awesomely faster than treewise ones.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
