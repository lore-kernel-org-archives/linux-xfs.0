Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 438F87F3F
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 10:09:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 131D9304043
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:09:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dVvuWqppi236XFZ8 for
	<xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:09:41 -0800 (PST)
Date: Fri, 14 Feb 2014 17:08:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214160854.GA21011@redhat.com>
References: <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140212214411.GQ18016@ZenIV.linux.org.uk>
	<20140213205146.GS18016@ZenIV.linux.org.uk>
	<20140214132503.GA23265@infradead.org> <52FE1A3A.9090301@nod.at>
	<20140214152028.GT18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140214152028.GT18016@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Richard Weinberger <richard@nod.at>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>

On 02/14, Al Viro wrote:
>
> BTW, Oleg, could you explain why does PTRACE_PEEK_SIGINFO copy ->si_code
> separately?  IOW, why do we want the upper 16 bits of ->si_code exposed?
> It used to be a strictly internal thing IIRC (it's been what, 2.3.late?)

Yes, but checkpoint/restart tools want to dump/restore the internal part
of ->si_code too.

See also the "task_pid_vnr(current) == pid" hack in do_rt_sigqueueinfo(),
this allows to queue a SI_FROMKERNEL() siginfo.

Oleg.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
