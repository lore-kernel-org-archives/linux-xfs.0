Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A935E7F5D
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 17:02:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 807C28F8040
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 15:02:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BLhmvlCpsrn5KglJ for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 15:02:04 -0700 (PDT)
Date: Wed, 19 Aug 2015 08:01:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfsprogs: replace obsolete memalign with
	posix_memalign
Message-ID: <20150818220119.GL714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-9-git-send-email-jtulak@redhat.com>
	<20150817193624.GA8444@infradead.org>
	<CACj3i73JFbDaOtggH2JQX6+5hQU3dJFBMObD3qq_BrfEkYA8mw@mail.gmail.com>
	<20150818082046.GK714@dastard>
	<CACj3i714tHuRxmNGve5-Gqn-1yMQaPntyj7ZJYWKw16gkw9bEw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i714tHuRxmNGve5-Gqn-1yMQaPntyj7ZJYWKw16gkw9bEw@mail.gmail.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 18, 2015 at 10:33:49AM +0200, Jan Tulak wrote:
> On Tue, Aug 18, 2015 at 10:20 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Tue, Aug 18, 2015 at 09:04:24AM +0200, Jan Tulak wrote:
> > > I thought about it. However, with memalign from malloc marked obsolete
> > > (and with posix_memalign having guaranteed alignment restrictions [1]), I
> > > saw it better
> > > to use the posix variant everywhere.
> >
> > Putting a sane wrapper around an nasty library function is just
> > fine. The memalign wrapper makes sense from this perspective - even
> > gcc can't tell if variables passed to posix_memalign are correctly
> > initialised or not, whereas no such problems exist for memalign().
> >
> > > I could make a wrapper simulating the old memalign behaviour, but I don't
> > > think it would make sense.
> >
> > I think it makes more sense than using posix_memalign() everywhere
> > and then ignoring the return variable that tells you it failed...
> >
> > > I searched for this, but didn't find any reasonable answer:
> > > How long can be things in standard libraries marked obsolete before
> > > removing?
> >
> > With a wrapper, we don't care.
> >
> > > [1] man memalign:
> > >        On many systems there are alignment restrictions, for example, on
> > buf-
> > >        fers  used  for  direct  block  device  I/O.  POSIX specifies the
> > path-
> > >        conf(path,_PC_REC_XFER_ALIGN) call that tells what alignment is
> > needed.
> > >        Now one can use posix_memalign() to satisfy this requirement.
> > >
> > >        posix_memalign()  verifies  that  alignment  matches  the
> > requirements
> > >        detailed above.  memalign() may not check that the  alignment
> > argument
> > >        is correct.
> >
> > Yes, you can get it wrong with memalign. But we don't, because we
> > follow the rules for DIO buffer alignment and set it correctly.
> > Being able to directly control the alignment of the memory buffer is
> > a reason for using memalign() over posix_memalign(), not the other
> > way around.
> >
> 
> So a wrapper used on all platforms is an acceptable solution? All right,
> this explanation makes sense. I will change it that way. The only question
> I have now is whether to use posix_memalign on every platform, or whether to
> make it platform_memalign and use the old memalign inside for Linux.

No need for a wrapper on platforms that support memalign. We can add
a wrapper when and if memalign ever goes away (which, FWIW, will
break lots of code). Indeed, we alreadyhave these platform dependent
"wrappers":

include/darwin.h:#define memalign(a,sz) valloc(sz)
include/freebsd.h:#define memalign(a,sz)        valloc(sz)

The question now is - do we even need to change anything?

https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/valloc.3.html

"The valloc() function allocates size bytes of memory and returns a
 pointer to the allocated memory.  The allocated memory is
 aligned on a page boundary"

Which means it does pretty exactly the same thing as
posix_memalign(), and so we don't need to change anything, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
