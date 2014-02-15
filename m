Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DA177F50
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 09:23:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 075123040CE
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 07:23:26 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id DCDkrlnZat4p6JgT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Feb 2014 07:23:02 -0800 (PST)
Date: Sat, 15 Feb 2014 15:22:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215152251.GY18016@ZenIV.linux.org.uk>
References: <20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
	<CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
	<20140215052531.GX18016@ZenIV.linux.org.uk>
	<20140215142700.GA15540@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140215142700.GA15540@redhat.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Feb 15, 2014 at 03:27:00PM +0100, Oleg Nesterov wrote:

> 1. info->q can be already freed if SIGQUEUE_PREALLOC.
> 
>    Once get_signal_to_deliver() or any other caller drops ->siglock
>    another thread can do sys_timer_delete()->sigqueue_free().

How the devil would it find the sucker?  It's off the list already.

> 2. We need to move do_schedule_next_timer() from dequeue_signal()
>    here.
> 
>    Otherwise ->q can be reused/overwritten by the next send_sigqueue()
>    right affter ->siglock is dropped.

Ditto.  We rip them out of queue on collect_signal(); the only thing we do
not do is actual __sigqueue_free().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
