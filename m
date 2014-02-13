Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 34E987F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 11:58:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1C32AC00A
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 09:58:50 -0800 (PST)
Received: from mail-ve0-f177.google.com (mail-ve0-f177.google.com
	[209.85.128.177]) by cuda.sgi.com with ESMTP id
	dEjOVuvYzRJ3gk9e (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 09:58:48 -0800 (PST)
Received: by mail-ve0-f177.google.com with SMTP id jz11so8678897veb.36
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 09:58:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140213174020.GA14455@redhat.com>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
Date: Thu, 13 Feb 2014 09:58:47 -0800
Message-ID: <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
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
To: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>

On Thu, Feb 13, 2014 at 9:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> And we should be careful with SIGQUEUE_PREALLOC, at least
> collect_signal() should not do list_del_init()... Plus we need to
> handle the SEND_SIG_FORCED-like case.

I don't think the users need to care. They'd just call
"sigqueue_free()" not knowing about our preallocations etc. That kind
of detail should be confined to inside signal.c.

But there really aren't that many users. There's a couple of
"dequeue_signal_lock()" users, but they don't actually *want* the
siginfo at all (they're kernel threads), so we can just make that
function free the siginfo immediately (and get rid of the totally
unnecessay kernel stack allocation). And outside of signal.c only
signalfd uses "dequeue_signal()" itself, and that would be the only
one that would need to be taught to use (in signalfd_copyinfo()) and
then free the sigqueue entry.

So it really looks like the right thing to do, and fairly
straightforward. But I'm leaving the coding proof to Al, since he
already offered ;)

             Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
