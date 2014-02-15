Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A62229DF8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 16:43:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CCA90304043
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 14:43:06 -0800 (PST)
Received: from mail-vc0-f177.google.com (mail-vc0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	7OhHUnV7CXIrZ39B (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Feb 2014 14:43:05 -0800 (PST)
Received: by mail-vc0-f177.google.com with SMTP id if11so10163364vcb.8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 14:43:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140215222844.GA18201@redhat.com>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard> <20140214002427.GN13997@dastard>
	<20140214160123.GA28125@redhat.com>
	<20140215222356.GU13997@dastard>
	<20140215222844.GA18201@redhat.com>
Date: Sat, 15 Feb 2014 14:43:03 -0800
Message-ID: <CA+55aFyGgjSgdJm=cBXGdrSO1pV95yxjVymC1QbjvonB-_GF8g@mail.gmail.com>
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
To: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Feb 15, 2014 at 2:28 PM, Dave Jones <davej@redhat.com> wrote:
>
> I've got a shitload of debug options enabled, which may explain it.
> Or perhaps that new STACK_PROTECTOR_STRONG stuff ?

Well, a lot of it is just the callee-saved registers. The compiler
will tend to preferentially allocate registers in the callee-trashed
registers, but if the function isn't a leaf function, any registers
that are live around a function call will have to be saved somewhere -
either explicitly around the function call, or - more likely - in
callee-saved registers that then get saved in the prologue/epilogue of
the function. And this will happen even in leaf functions when there
is enough register pressure that the callee-trashed registers aren't
sufficient (which is pretty common).

So saving 5-6 registers on the stack (in addition to any actual stack
frame) is pretty much the norm for anything but the very simplest
cases.

But yeah, I'm sure some config options make it worse.
STACK_PROTECTOR_STRONG could easily be one of those.

            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
