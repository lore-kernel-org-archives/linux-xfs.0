Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2080D7F52
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 15:44:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98441AC005
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 13:44:18 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id cVYF2E8HzewVDFsx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 13:44:15 -0800 (PST)
Date: Wed, 12 Feb 2014 21:44:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212214411.GQ18016@ZenIV.linux.org.uk>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Oleg Nesterov <oleg@redhat.com>, xfs@oss.sgi.com, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, Feb 12, 2014 at 01:32:55PM -0800, Linus Torvalds wrote:
> On Wed, Feb 12, 2014 at 1:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Umm...  What if we delay __sigqueue_free()?  After all, that's where the
> > fat sucker normally comes from.  That way we might get away with much
> > smaller structure on stack...
> 
> Sounds like the RightThing(tm) to do to me, and I don't see why it
> wouldn't work.
> 
> We'd have to teach each user of "dequeue_signal()" to free the siginfo
> thing. Which shouldn't be too bad - I think we've collected all of
> that into generic code, and there isn't the mass or architecture code
> that knows about these things any more. But there are a few odd
> drivers etc and signalfd. I didn't look at what the lifetimes were.

Only signalfd, AFAICS.  And there we'd want to use the same small structure -
it's used in
        do {
                ret = signalfd_dequeue(ctx, &info, nonblock);
                if (unlikely(ret <= 0))
                        break;
                ret = signalfd_copyinfo(siginfo, &info);
                if (ret < 0)
                        break;
                siginfo++;
                total += ret;
                nonblock = 1;
        } while (--count);
and using a smaller struct would actually speed the things up - skips one
copying.  sigqueue would be freed as soon as we'd done signalfd_copyinfo()
(if not by signalfd_copyinfo() itself).

I'll try to put something along those lines together, if you or Oleg don't
do it first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
