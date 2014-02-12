Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E4537F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 19:09:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 240A2304070
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 17:09:49 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id INKmZrJr5ZTSg8G4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 17:09:48 -0800 (PST)
Date: Wed, 12 Feb 2014 01:09:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212010941.GM18016@ZenIV.linux.org.uk>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212004403.GA17129@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, Feb 11, 2014 at 07:44:03PM -0500, Dave Jones wrote:

> The 'good' news is I seem to be able to reproduce it fairly quickly.
> I've seen it 3-4 times this afternoon. (Always from the coredump path)
> 
> I was on vacation last week, but I wasn't hitting this before then, so it's a
> fairly recent change that's introduced this.

Slap the check in vfs_create(), see if interrupts had been disabled by it or
by something in ->create().  Since it's reproducible...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
