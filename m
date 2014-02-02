Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 256D27FA9
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 18:13:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1CE1AC008
	for <xfs@oss.sgi.com>; Sat,  1 Feb 2014 16:13:43 -0800 (PST)
Received: from mail-ve0-f180.google.com (mail-ve0-f180.google.com
	[209.85.128.180]) by cuda.sgi.com with ESMTP id
	ZLzqWqJgec6IitSQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Feb 2014 16:13:37 -0800 (PST)
Received: by mail-ve0-f180.google.com with SMTP id db12so4118918veb.11
	for <xfs@oss.sgi.com>; Sat, 01 Feb 2014 16:13:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140201224301.GS10323@ZenIV.linux.org.uk>
References: <20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
Date: Sat, 1 Feb 2014 16:13:36 -0800
Message-ID: <CA+55aFxtfMZ82CUmxFKb1zqB2Qy9JAztpPYXgimzya653NY3Og@mail.gmail.com>
Subject: Re: [RFC] unifying write variants for filesystems
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Anton Altaparmakov <anton@tuxera.com>

On Sat, Feb 1, 2014 at 2:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, Linus, when did you comment on that patchset?  I've found an iteration
> of that patchset circa last October (v9, apparently the latest posted),
> but it looks like your comments had either got lost or had been on the
> earlier iteration of that thing...

I commented on the pull request in November. Something like this:

  http://lkml.indiana.edu/hypermail/linux/kernel/1311.2/02278.html

and then I have a follow-up in a reply to that that at least outlines
a few things that could be done to make it less barfy.

But judging from your email, you actually went through that
patch-series with a finer comb, I don't think there is anything in
that commentary of mine that adds anything to yours, apart on a
comment on the naming that I hated.

            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
