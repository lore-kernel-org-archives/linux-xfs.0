Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EDD207F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 20:52:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E8B1AC003
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 18:52:21 -0800 (PST)
Received: from mail-vc0-f179.google.com (mail-vc0-f179.google.com
	[209.85.220.179]) by cuda.sgi.com with ESMTP id
	J41MeJPARuAR73WV (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 18:52:20 -0800 (PST)
Received: by mail-vc0-f179.google.com with SMTP id lh14so6541322vcb.38
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 18:52:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140212010941.GM18016@ZenIV.linux.org.uk>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
Date: Tue, 11 Feb 2014 18:52:19 -0800
Message-ID: <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Feb 11, 2014 at 5:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Slap the check in vfs_create(), see if interrupts had been disabled by it or
> by something in ->create().  Since it's reproducible...

path_openat() starts off with a get_empty_filp(), which allocates a
file pointer with GFP_KERNEL. So that should have triggered the
might_sleep warning if irq's were already disabled at that point.

So it's not before that - in particular, it's not in the signal
handling or do_coredump() paths.

Also, at least xfs_buf_lock() - which is much deeper in that chain -
does a down(&bp->b_sema). I'm disguested that that doesn't have a
might_sleep() in it.

Dave, mind adding a "might_sleep()" to the top of
"down[_interruptible]()". It's silly to not have coverage of semaphore
use in bad contexts.

             Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
