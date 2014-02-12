Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B59377F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 15:14:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 976FF304077
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 13:14:32 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id ltpq2t8C2xtMAOjx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 13:14:30 -0800 (PST)
Date: Wed, 12 Feb 2014 21:14:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212211421.GP18016@ZenIV.linux.org.uk>
References: <52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
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
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Feb 12, 2014 at 12:13:19PM -0800, Linus Torvalds wrote:
> On Wed, Feb 12, 2014 at 3:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Feb 11, 2014 at 10:28:12PM -0800, Linus Torvalds wrote:
> >
> >> It looks like just "do_signal()" has a stack frame that is about 230
> >> bytes even under normal circumstancs (largely due to "struct ksignal"
> >> - which in turn is largely due to the insane 128-byte padding in
> >> siginfo_t). Add a few other frames in there, and I guess that if it
> >> was close before, the coredump path just makes it go off.
> >
> > We could, in principle, put it into task_struct and make get_signal()
> > return its address - do_signal() is called only in the code that does
> > assorted returns to userland...
> 
> We have better uses for random buffers in "struct task_struct", I'd
> hate to put a siginfo_t there.

*nod*

> The thing is, siginfo_t has that idiotic 128-byte area, but it's all
> "for future expansion". I think it's some damn glibc disease - we've
> seen these kinds of insane paddings before.
> 
> The actual *useful* part of siginfo_t is on the order of 32 bytes. If that.
> 
> Sad.

Umm...  What if we delay __sigqueue_free()?  After all, that's where the
fat sucker normally comes from.  That way we might get away with much
smaller structure on stack...

Just introduce a small structure that would contain signr, uid, pid and
pointer to struct sigqueue.  And pass a pointer to _that_ all the way down
to collect_signal().  Pointer's NULL == it's SI_USER with signr/uid/pid
from the small struct and all other fields are zero.  Pointer isn't NULL -
use &small_struct->p->info.  And have struct sigqueue actually freed
via task_work_add() in that case.

Do you see any fundamental problems with that?  Looks like it would be
faster as well - less copying involved...


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
