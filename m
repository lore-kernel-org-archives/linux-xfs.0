Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A85747F37
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 00:31:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 933E4304039
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 22:31:50 -0700 (PDT)
Date: Tue, 16 Jul 2013 06:31:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716053140.GK4165@ZenIV.linux.org.uk>
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
Cc: Peter Zijlstra <peterz@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>

On Mon, Jul 15, 2013 at 08:25:14PM -0700, Linus Torvalds wrote:

> The "pipe -> cred_guard_mutex" lock chain is pretty direct, and can be
> clearly attributed to splicing into /proc. Now, whether that is a
> *good* idea or not is clearly debatable, and I do think that maybe we
> should just not splice to/from proc files, but that doesn't seem to be
> new, and I don't think it's necessarily *broken* per se, it's just
> that splicing into /proc seems somewhat unnecessary, and various proc
> files do end up taking locks that can be "interesting".

FWIW, we might attack that one - after all, we could have ->splice_write()
for that guy that would grab cred_guard_mutex, then call splice_from_pipe()
with actor that would map/do security_setprocattr/unmap...  Said that,
considering what it does on write, it really does *not* want to deal with
partial writes, so...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
