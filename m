Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41FSiZ5181704 for <xfs@oss.sgi.com>; Sun, 1 May 2011 10:28:44 -0500
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15B421E18FD2
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 08:32:19 -0700 (PDT)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id du2xyqD4r3AoZsbG for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 08:32:19 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <19901.31958.368144.832086@tree.ty.sabi.co.UK>
Date: Sun, 1 May 2011 16:31:34 +0100
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
In-Reply-To: <20110501082717.5116e575@notabene.brown>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
	<20110501082717.5116e575@notabene.brown>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>, Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>> * Can Linux MD do "abbreviated" read-modify-write RAID6
>> updates like for RAID5? [ ... ]

> No. (patches welcome).

Ahhhm, but let me dig a bit deeper, even if it may be implied in
the answer: would it be *possible*?

That is, is the double parity scheme used in MS such that it is
possible to "subtract" the old content of a page and "add" the
new content of that page to both parity pages?

[ ... ]

> The ideal config for a journalled filesystem is for put the
> journal on a separate smaller lower-latency device.  e.g. a
> small RAID1 pair.

> In a previous work place I had good results with:
>   RAID1 pair of small disks with root, swap, journal
>   Large RAID5/6 array with bulk of filesystem.

Sound reasonable, except that I am allergic to RAID5 (except in
two cases) and RAID6 (in general). :-), but would work equally
well I guess with RAID10 and its delightful MD implementation.

[ ... ]

Thanks for the information!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
