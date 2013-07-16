Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 260717F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 22:29:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1D6E304039
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 20:29:16 -0700 (PDT)
Date: Mon, 15 Jul 2013 23:28:41 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716032841.GB1578@redhat.com>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>

On Mon, Jul 15, 2013 at 08:25:14PM -0700, Linus Torvalds wrote:
 
 
 > And looking more at that, I'm actually starting to think this is an
 > XFS locking problem. XFS really should not call back to splice while
 > holding the inode lock.
 > 
 > But that XFS code doesn't seem new either. Is XFS a new thing for you
 > to test with?

I started pounding on it fairly recently and have shook out a number
of bugs (now fixed) since I started, so relatively new, but on the order of 'months' now.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
