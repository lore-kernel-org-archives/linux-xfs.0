Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBC3629DF8
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 16:28:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E065AC001
	for <xfs@oss.sgi.com>; Sat, 15 Feb 2014 14:28:56 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 81BEbCOHYn2xf3ZC for
	<xfs@oss.sgi.com>; Sat, 15 Feb 2014 14:28:55 -0800 (PST)
Date: Sat, 15 Feb 2014 17:28:44 -0500
From: Dave Jones <davej@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215222844.GA18201@redhat.com>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212071829.GE13997@dastard> <20140214002427.GN13997@dastard>
	<20140214160123.GA28125@redhat.com>
	<20140215222356.GU13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140215222356.GU13997@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sun, Feb 16, 2014 at 09:23:56AM +1100, Dave Chinner wrote:
 
 > There's a pretty massive difference between the actual stack usage
 > of the local variables and the amount of stack being used by the
 > compiled code.
 > 
 > What it appears to be is that the compiler is pushing 6-10 registers
 > to the stack on every function call. So a function that only has 3
 > local variables and does very little but allocate a structure and
 > call other functions saves an 6 registers to the stack before it
 > starts:

I've got a shitload of debug options enabled, which may explain it.
Or perhaps that new STACK_PROTECTOR_STRONG stuff ?

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
