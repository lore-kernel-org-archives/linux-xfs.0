Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C83497F4E
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 08:47:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 99D94304067
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 06:46:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VVo0FzDHRaRJ0t93 for
	<xfs@oss.sgi.com>; Sat, 15 Feb 2014 06:46:58 -0800 (PST)
Date: Sat, 15 Feb 2014 15:46:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215144635.GA16759@redhat.com>
References: <20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140214161302.GA16416@infradead.org>
	<20140214161623.GU18016@ZenIV.linux.org.uk>
	<20140214161912.GB20909@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140214161912.GB20909@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>

On 02/14, Christoph Hellwig wrote:
>
> Might aswell stick the discmiss into what was dequeue_signal_lock().
> Which at that point should get a saner name (maybe thread_dequeue_signal ?)
> and lose all argument except maybe task_struct

No, task_struct argument should die, I think. It is misleading.

spin_lock(tsk->sighand->siglock) is simply wrong unless tsk == current.

And dequeue_signal() assumes that tsk == current too, otherwise
recalc_sigpending() is wrong.

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
