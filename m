Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E29107F88
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 11:54:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C62F58F8037
	for <xfs@oss.sgi.com>; Mon, 17 Feb 2014 09:54:13 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id 1Ft3MgQ3AATv9Yft (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Feb 2014 09:54:12 -0800 (PST)
Date: Mon, 17 Feb 2014 17:54:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140217175407.GE18016@ZenIV.linux.org.uk>
References: <20140215142700.GA15540@redhat.com>
	<20140215152251.GY18016@ZenIV.linux.org.uk>
	<20140215153631.GZ18016@ZenIV.linux.org.uk>
	<20140215155838.GA18016@ZenIV.linux.org.uk>
	<20140215174345.GA24799@redhat.com>
	<20140215180520.GC18016@ZenIV.linux.org.uk>
	<20140215184531.GA27314@redhat.com>
	<20140217165735.GA29173@redhat.com>
	<20140217174059.GD18016@ZenIV.linux.org.uk>
	<20140217174648.GA6176@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140217174648.GA6176@redhat.com>
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

On Mon, Feb 17, 2014 at 06:46:48PM +0100, Oleg Nesterov wrote:
> > pulling the logics *out* of kernel/signal.c and into arch/*.
> 
> Not really, I think.

How so?  You propose to make all architectures call do_coredump()
themselves, instead of having it done centrally.  It's more boilerplate
for all of them to get wrong.  And IME any boilerplate in that are
*will* be gotten wrong - I've gone through signal handling on all
architectures more than a few times and every time it caught a pile
of bugs...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
