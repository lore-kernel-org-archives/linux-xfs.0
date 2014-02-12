Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2EA67F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 22:22:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E4068F804C
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 20:22:23 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id CMfDp8y2x7yR7KbN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 20:22:21 -0800 (PST)
Date: Wed, 12 Feb 2014 04:22:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212042215.GN18016@ZenIV.linux.org.uk>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212040358.GA25327@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Feb 11, 2014 at 11:03:58PM -0500, Dave Jones wrote:
> [ 3111.414202]  [<ffffffff8d1f9036>] bio_alloc_bioset+0x156/0x210
> [ 3111.414855]  [<ffffffffc0314231>] _xfs_buf_ioapply+0x1c1/0x3c0 [xfs]
> [ 3111.415517]  [<ffffffffc03858f2>] ? xlog_bdstrat+0x22/0x60 [xfs]
> [ 3111.416175]  [<ffffffffc031449b>] xfs_buf_iorequest+0x6b/0xf0 [xfs]
> [ 3111.416843]  [<ffffffffc03858f2>] xlog_bdstrat+0x22/0x60 [xfs]
> [ 3111.417509]  [<ffffffffc0387a87>] xlog_sync+0x3a7/0x5b0 [xfs]
> [ 3111.418175]  [<ffffffffc0387d9f>] xlog_state_release_iclog+0x10f/0x120 [xfs]
> [ 3111.418846]  [<ffffffffc0388840>] xlog_write+0x6f0/0x800 [xfs]
> [ 3111.419518]  [<ffffffffc038a061>] xlog_cil_push+0x2f1/0x410 [xfs]

Very interesting.  The first thing xlog_cil_push() is doing is blocking
kmalloc().  So at that point it still hadn't been atomic.  I'd probably
slap may_sleep() in the beginning of xlog_sync() and see if that triggers...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
