Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 126FD7F52
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 15:32:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E852230406A
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 13:32:57 -0800 (PST)
Received: from mail-vb0-f50.google.com (mail-vb0-f50.google.com
	[209.85.212.50]) by cuda.sgi.com with ESMTP id BzJmBENzgITAUFBi
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 12 Feb 2014 13:32:56 -0800 (PST)
Received: by mail-vb0-f50.google.com with SMTP id w8so7691100vbj.9
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 13:32:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140212211421.GP18016@ZenIV.linux.org.uk>
References: <52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
Date: Wed, 12 Feb 2014 13:32:55 -0800
Message-ID: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
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
To: Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Feb 12, 2014 at 1:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...  What if we delay __sigqueue_free()?  After all, that's where the
> fat sucker normally comes from.  That way we might get away with much
> smaller structure on stack...

Sounds like the RightThing(tm) to do to me, and I don't see why it
wouldn't work.

We'd have to teach each user of "dequeue_signal()" to free the siginfo
thing. Which shouldn't be too bad - I think we've collected all of
that into generic code, and there isn't the mass or architecture code
that knows about these things any more. But there are a few odd
drivers etc and signalfd. I didn't look at what the lifetimes were.

Adding Oleg to the cc, since any time we touch any of that code, he
should be involved. Oleg - the issue is the biggish size of 'struct
ksignal' on stack, brought on by the silly "put a whole siginfo_t in
it".

            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
