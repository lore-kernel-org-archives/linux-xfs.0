Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB1307F55
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 09:20:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 795018F8052
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 07:20:52 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id XxdpgdPnzYCEyfWs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 07:20:50 -0800 (PST)
Date: Fri, 14 Feb 2014 15:20:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214152028.GT18016@ZenIV.linux.org.uk>
References: <20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140212214411.GQ18016@ZenIV.linux.org.uk>
	<20140213205146.GS18016@ZenIV.linux.org.uk>
	<20140214132503.GA23265@infradead.org> <52FE1A3A.9090301@nod.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FE1A3A.9090301@nod.at>
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
To: Richard Weinberger <richard@nod.at>
Cc: Eric Sandeen <sandeen@sandeen.net>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>

On Fri, Feb 14, 2014 at 02:29:30PM +0100, Richard Weinberger wrote:
> Am 14.02.2014 14:25, schrieb Christoph Hellwig:
> > On Thu, Feb 13, 2014 at 08:51:46PM +0000, Al Viro wrote:
> >> On Wed, Feb 12, 2014 at 09:44:11PM +0000, Al Viro wrote:
> >>
> >>> I'll try to put something along those lines together, if you or Oleg don't
> >>> do it first.
> >>
> >> OK, having looked at that stuff...
> >>
> >> 1) things become much more compact if we finish conversion to get_signal()
> >> first.
> > 
> > I have vague memories that Richard sent out a series to convert over all
> > architectures a while ago.  Hopefully he has better memory than I do.
> 
> Yeah. Sending v2 of that series is on my overflowing TODO list. :-\
> I think this is a good reason for me to start working on that series again.
> Stay tuned.

Would be great.   I have several done here, but I'll be glad to replace them
with something tested...

BTW, Oleg, could you explain why does PTRACE_PEEK_SIGINFO copy ->si_code
separately?  IOW, why do we want the upper 16 bits of ->si_code exposed?
It used to be a strictly internal thing IIRC (it's been what, 2.3.late?)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
