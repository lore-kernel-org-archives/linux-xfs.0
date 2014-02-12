Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 923017F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 00:28:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6611A8F8039
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 22:28:15 -0800 (PST)
Received: from mail-ve0-f177.google.com (mail-ve0-f177.google.com
	[209.85.128.177]) by cuda.sgi.com with ESMTP id
	Ix2Dy99kBCGFvJzZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 22:28:13 -0800 (PST)
Received: by mail-ve0-f177.google.com with SMTP id jz11so6866591veb.22
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 22:28:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140212054043.GB13997@dastard>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
Date: Tue, 11 Feb 2014 22:28:12 -0800
Message-ID: <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
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
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, Feb 11, 2014 at 9:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> None of the XFS code disables interrupts in that path, not does is
> call outside XFS except to dispatch IO. The stack is pretty deep at
> this point and I know that the standard (non stacked) IO stack can
> consume >3kb of stack space when it gets down to having to do memory
> reclaim during GFP_NOIO allocation at the lowest level of SCSI
> drivers. Stack overruns typically show up with symptoms like we are
> seeing.

That would also explain why it shows up for do_coredump(), even though
clearly interrupts are not disabled at that point. It's just because
do_coredump() opens a filename at a deeper point in the stack than the
more normal system call paths do.

It looks like just "do_signal()" has a stack frame that is about 230
bytes even under normal circumstancs (largely due to "struct ksignal"
- which in turn is largely due to the insane 128-byte padding in
siginfo_t). Add a few other frames in there, and I guess that if it
was close before, the coredump path just makes it go off.

And some of the debug options that I'm sure DaveJ has enabled tend to
make the stack usage worse (simply because they make a lot of data
structures bigger).

             Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
