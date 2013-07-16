Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E63E7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 22:25:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 103CA8F8033
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 20:25:20 -0700 (PDT)
Received: from mail-ve0-f176.google.com (mail-ve0-f176.google.com
	[209.85.128.176]) by cuda.sgi.com with ESMTP id
	3DCdoCZa2e4YA6vM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 20:25:15 -0700 (PDT)
Received: by mail-ve0-f176.google.com with SMTP id c13so123745vea.35
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 20:25:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130716023847.GA31481@redhat.com>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
Date: Mon, 15 Jul 2013 20:25:14 -0700
Message-ID: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
Subject: Re: splice vs execve lockdep trace.
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
To: Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 15, 2013 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
>
>   The recent trinity changes shouldn't have really made
> any notable difference here.

Hmm. I'm not aware pf anything that has changed in this area since
3.10 - neither in execve, xfs or in splice. Not even since 3.9.

But I may certainly have missed something.

> Interestingly, the 'soft lockups' I was
> seeing all the time on that box seem to have gone into hiding.

Honestly, I'm somewhat inclined to blame the whole perf situation, and
saying that we hopefully got that fixed. In between the silly do_div()
buglets and all the indications that the time was spent in nmi
handlers, I'd be willing to just ignore them as false positives
brought on by the whole switch to the perf irq..

>  > Or is the XFS i_iolock required for this thing to happen at all?
>  > Adding Ben Myers to the cc just for luck/completeness.
>
> It is only happening (so far) on the XFS test box, but I don't have
> enough data to say that's definite yet.

.. so there's been a number of xfs changes, and I don't know the code,
but none of them seem at all relevant to this.

The "pipe -> cred_guard_mutex" lock chain is pretty direct, and can be
clearly attributed to splicing into /proc. Now, whether that is a
*good* idea or not is clearly debatable, and I do think that maybe we
should just not splice to/from proc files, but that doesn't seem to be
new, and I don't think it's necessarily *broken* per se, it's just
that splicing into /proc seems somewhat unnecessary, and various proc
files do end up taking locks that can be "interesting".

At the other end of the spectrum, the "cred_guard_mutex -> FS locks"
thing from execve() is also pretty clear, and probably not fixable or
necessarily something we'd even want to fix.

But the "FS locks -> pipe" part is a bit questionable. Honestly, I'd
be much happier if XFS used generic_file_splice_read/write().

And looking more at that, I'm actually starting to think this is an
XFS locking problem. XFS really should not call back to splice while
holding the inode lock.

But that XFS code doesn't seem new either. Is XFS a new thing for you
to test with?

Ben? Comments? I added the xfs list too now that I'm starting to
possibly blame XFS more actively..

                  Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
