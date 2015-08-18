Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0EA927F50
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 03:21:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2B7930405F
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 01:20:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PDG6RzRgnORKYOPZ for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 01:20:54 -0700 (PDT)
Date: Tue, 18 Aug 2015 18:20:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfsprogs: replace obsolete memalign with
	posix_memalign
Message-ID: <20150818082046.GK714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-9-git-send-email-jtulak@redhat.com>
	<20150817193624.GA8444@infradead.org>
	<CACj3i73JFbDaOtggH2JQX6+5hQU3dJFBMObD3qq_BrfEkYA8mw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACj3i73JFbDaOtggH2JQX6+5hQU3dJFBMObD3qq_BrfEkYA8mw@mail.gmail.com>
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

On Tue, Aug 18, 2015 at 09:04:24AM +0200, Jan Tulak wrote:
> On Mon, Aug 17, 2015 at 9:36 PM, Christoph Hellwig <hch@infradead.org>
> wrote:
> 
> > On Mon, Aug 17, 2015 at 06:23:23PM +0200, Jan Tulak wrote:
> > > Memalign from <malloc.h> was marked obsolete in favor of a posix
> > > variant from <stdlib.h>. So replace all calls and remove <malloc.h>
> > > includes. This also enhances support on other posix platforms,
> > > which doesn't have <malloc.h>.
> > >
> > > Because posix_memalign returns any error as a return code, not in
> > > errno, change relevant checks in code (and add a missing one).
> >
> > I have to say I hate the posix_memalign calling convention.  Any chance
> > you could just provide a memalign impementation using posix_memalign for
> > MacOS?
> >
> 
> I thought about it. However, with memalign from malloc marked obsolete
> (and with posix_memalign having guaranteed alignment restrictions [1]), I
> saw it better
> to use the posix variant everywhere.

Putting a sane wrapper around an nasty library function is just
fine. The memalign wrapper makes sense from this perspective - even
gcc can't tell if variables passed to posix_memalign are correctly
initialised or not, whereas no such problems exist for memalign().

> I could make a wrapper simulating the old memalign behaviour, but I don't
> think it would make sense.

I think it makes more sense than using posix_memalign() everywhere
and then ignoring the return variable that tells you it failed...

> I searched for this, but didn't find any reasonable answer:
> How long can be things in standard libraries marked obsolete before
> removing?

With a wrapper, we don't care.

> [1] man memalign:
>        On many systems there are alignment restrictions, for example, on buf-
>        fers  used  for  direct  block  device  I/O.  POSIX specifies the path-
>        conf(path,_PC_REC_XFER_ALIGN) call that tells what alignment is needed.
>        Now one can use posix_memalign() to satisfy this requirement.
>
>        posix_memalign()  verifies  that  alignment  matches  the  requirements
>        detailed above.  memalign() may not check that the  alignment argument
>        is correct.

Yes, you can get it wrong with memalign. But we don't, because we
follow the rules for DIO buffer alignment and set it correctly.
Being able to directly control the alignment of the memory buffer is
a reason for using memalign() over posix_memalign(), not the other
way around.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
