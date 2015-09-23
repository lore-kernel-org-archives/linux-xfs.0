Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 845707F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 17:12:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14620AC006
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 15:12:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DfLOG6IcQwoC0D6g for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 15:12:38 -0700 (PDT)
Date: Thu, 24 Sep 2015 08:04:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests, bad generic tests 009 and 308
Message-ID: <20150923220444.GP19114@dastard>
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com> <20150921225244.GD19114@dastard>
	<56028249.7040103@univ-nantes.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56028249.7040103@univ-nantes.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Yann Dupont - Veille Techno <veilletechno-irts@univ-nantes.fr>
Cc: xfs@oss.sgi.com

On Wed, Sep 23, 2015 at 12:43:21PM +0200, Yann Dupont - Veille Techno wrote:
> Le 22/09/2015 00:52, Dave Chinner a =E9crit :
> >As it is, I highly recommend that you try a current 4.3 kernel, as
> >there are several code fixes in the XFS kernel code that work
> >around compiler issues we know about. AFAIA, the do_div() asm bug
> >that trips recent gcc optimisations isn't in the upstream kernel
> >yet, but that can be worked around by setting
> >CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy in your build.
> =

> Hi dave,
> =

> I can confirm that CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy is (was ?) the only
> way for me to have reliable XFS kernel code on different arm
> platforms (Marvell kirkwood, Allwinner A20, Amlogic S805), no matter
> what recent gcc version I've been using.
> =

> I must admit I was cross-compiling from X86-64 too, but I think (not
> sure) that it was also the case with native gcc.
> =

> I must also admit that I didn't tried since some months, because
> CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy was the silver bullet for arm xfs
> kernel crashes. This crash was difficult to understand because it
> occurs quite randomly (I.e it can take several hours to trigger)
> =

> If there's a patch floating around for gcc (or kernel), I'm
> interested to test.

See this subthread from august:

http://oss.sgi.com/archives/xfs/2015-08/msg00234.html

AFAICT, the do_div patch to fix the problem has not yet been picked
up - it's not in the 4.3-rc2 kernel...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
