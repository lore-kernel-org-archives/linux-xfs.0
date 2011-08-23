Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7NJw0pt219874 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 14:58:00 -0500
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
	<CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
Date: Tue, 23 Aug 2011 14:57:56 -0500
Message-ID: <1314129476.2898.28.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, 2011-08-23 at 11:46 -0700, Linus Torvalds wrote:
> On Tue, Aug 23, 2011 at 10:39 AM, Alex Elder <aelder@sgi.com> wrote:
> >
> > Linus, please pull the following XFS changes.  Their effect is to
> > remove the subdirectory structure from the XFS source hierarchy.
> > There are no functional changes to the XFS code itself.  Thanks.
> 
> Pulled.
> 
> Any plans to further sanitize the namespace?

We haven't discussed it but it's not a bad idea.

> It's kind of crazy to have filenames like
> 
>    fs/xfs/xfs_trace.c
> 
> which just duplicate the "xfs" part for no good reason. Why not just
> do something like
> 
>   for i in xfs_*; do j=$(echo $i | sed 's/^xfs_//'); git mv $i $j; done
> 
> to get rid of the silly "xfs_" prefix that adds nothing?
> 
> You could use the bytes you save to rename "qm.c" to "quota_manager.c"
> instead. Wouldn't it be nice to have *good* names, instead of a jumble
> of crazy and mostly redundant letters?

We're getting there, gradually.  The code is certainly
evolving in that direction, though that hasn't happened
in the file names.  Doing that would require my fingers
to get used to skipping over the "xfs_" spasm though...

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
