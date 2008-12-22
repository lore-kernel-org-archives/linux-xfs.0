Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMDJ5EN019314 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 07:19:05 -0600
Received: from out1.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1E4A1B9DC09
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 05:19:03 -0800 (PST)
Received: from out1.smtp.messagingengine.com (out1.smtp.messagingengine.com
	[66.111.4.25]) by cuda.sgi.com with ESMTP id OltR1VG7cNWGrKN6
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 05:19:03 -0800 (PST)
Message-Id: <1229951942.11189.1291310985@webmail.messagingengine.com>
From: "Leon Woestenberg" <leonw@mailcan.com>
Content-Disposition: inline
MIME-Version: 1.0
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<1229225480.16555.152.camel@localhost>
	<18757.4606.966139.10342@tree.ty.sabi.co.uk>
	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<494971B2.1000103@tmr.com> <494A07BA.1080008@mailcan.com>
	<18766.38416.161254.375311@tree.ty.sabi.co.uk>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
In-Reply-To: <18766.38416.161254.375311@tree.ty.sabi.co.uk>
Date: Mon, 22 Dec 2008 14:19:02 +0100
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Peter Grandi <pg_mh@sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>

Hello,

On Sun, 21 Dec 2008 19:16:32 +0000, "Peter Grandi" <pg_mh@sabi.co.UK>
said:
 
> > The drive itself may still re-order writes, thus can cause
> > corruption if halfway the power goes down. [ ... ] Barriers need
> > to travel all the way down to the point where-after everything
> > remains in-order. [ ... ] Whether the data has made it to the
> > drive platters is not really important from a barrier point of
> > view, however, iff part of the data made it to the platters, then
> > we want to be sure it was in-order. [ ... ]
> 
> But this discussion is backwards, as usual: the *purpose* of any
> kind of barriers cannot be just to guarantee consistency, but also
> stability, because ordered commits are not that useful without
> commit to stable storage.
>
I do not see in what sense you mean "stability"? Stable as in BIBO or
non-volatile?

Barriers are time-related. Once data is on storage, there is no relation
with time.

So I do not see how barriers help to "stabilize" storage.

Ordered commits is a strong-enough condition to ensure consistency in
the sense that
atomic transactions either made it to the disk completely or not at all.

> If barriers guarantee transaction stability, then consistency is
> also a consequence of serial dependencies among transactions (and
> as to that per-device barriers are a coarse and very underoptimal
> design).
>
Of course, the higher level should ensure that between transactions, the
(meta)data is always consistent.

In filesystem design, we see that some FS's decide to split metadata and
data in this regard.

 
> Anyhow, barriers for ordering only have been astutely patented
> quite recently:
> 
>   http://www.freshpatents.com/Transforming-flush-queue-command-to-memory-barrier-command-in-disk-drive-dt20070719ptan20070168626.php
> 
> Amazing new from the patent office.y
> 
Grand. Another case of no prior art. :-)

Leon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
