Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 267797F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 08:58:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0AAAD304039
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 06:58:51 -0700 (PDT)
Received: from smtpauth05.mfg.siteprotect.com (smtpauth05.mfg.siteprotect.com
	[64.26.60.144]) by cuda.sgi.com with ESMTP id FxQD08ZJNAnNgehV
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 06:58:47 -0700 (PDT)
Date: Tue, 16 Jul 2013 09:59:35 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
Subject: Re: splice vs execve lockdep trace.
In-Reply-To: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1307160956370.15153@pianoman.cluster.toy>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
MIME-Version: 1.0
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Mon, 15 Jul 2013, Linus Torvalds wrote:

> On Mon, Jul 15, 2013 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
> 
> > Interestingly, the 'soft lockups' I was
> > seeing all the time on that box seem to have gone into hiding.
> 
> Honestly, I'm somewhat inclined to blame the whole perf situation, and
> saying that we hopefully got that fixed. In between the silly do_div()
> buglets and all the indications that the time was spent in nmi
> handlers, I'd be willing to just ignore them as false positives
> brought on by the whole switch to the perf irq..

Did the perf soft lockups go away with 3.11-rc1?

734df5ab549ca44f40de0f07af1c8803856dfb18 finally got committed,
and it fixes a major long-standing perf-related NMI soft lockup bug I 
found when fuzzing.

Vince

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
