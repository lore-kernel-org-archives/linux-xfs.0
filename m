Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTA1r5h023846 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 04:01:53 -0600
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CC82179274B
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 02:01:52 -0800 (PST)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.149])
	by cuda.sgi.com with ESMTP id rSuxM1mTkHtzCsJK for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 02:01:52 -0800 (PST)
Received: by qw-out-1920.google.com with SMTP id 5so16256186qwc.32
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 02:01:51 -0800 (PST)
Message-ID: <43d009740812290201x30cadf9bx61c525f380746e64@mail.gmail.com>
Date: Mon, 29 Dec 2008 17:01:51 +0700
From: "Igor Podlesny" <for.poige+linux@gmail.com>
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest
	stable version of the Linux kernel is".
In-Reply-To: <20081229092124.GA18987@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <43d009740812282139x7597aafbn4474455c1aa1e0e8@mail.gmail.com>
	<20081229092124.GA18987@infradead.org>
Reply-To: for.poige+linux@gmail.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

2008/12/29 Christoph Hellwig <hch@infradead.org>:
> On Mon, Dec 29, 2008 at 12:39:55PM +0700, Igor Podlesny wrote:
>> -- Copying several rather big files (~ 25--45 GiB) from XFS on LVM-2
>> on MDraid partition to another one, I had the system rebooted both
>> with 2.6.28 and 2.6.27.10 (accomplished using 2.6.24.7-rt(sic!)25). As
>> you probably understand, that's the case you even can't trace where's
>> the problem, at least on a desktop with GUI, not on server with plain
>> text display. Although, I'm afraid even text display wouldn't had a
>> chance to show anything, tracing that problem.
>
> You don't have 4K_STACKs enabled by default, do you?

	x86_64, so it's not applicable.
	
	I see you've included XFS guys, but that's hard to guess which
sub-system is related to that crash, cause it's a stacked construction
XFS/LVM-2/Linux Software RAID/sata_nv. Also, I've found there were
some complaints bout netfilter's ipt_recent, which I was using, so
I've decided to turn it off and see.
>
> And instead of these rants bug reports would be more useful.
>
	Yeah, I'll try to get backtraces, using null-modem cable, but alas, I
don't have it yet. Nowadays it's not a thing easy to buy at a computer
store. Also, my message (feedback) was written due to concerns bout
quality degradation I saw. May be I was mistaken or not, but I felt
it's better to talk about it to people who really cared and knew.

-- 
End of message. Next message?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
