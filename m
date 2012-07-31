Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VCG4o8175682 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 07:16:04 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QsUR7GsR9IYNNaBp for
	<xfs@oss.sgi.com>; Tue, 31 Jul 2012 05:16:03 -0700 (PDT)
Date: Tue, 31 Jul 2012 14:15:56 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: Change fstrim behaviour to be consistent with
	upstream version
In-Reply-To: <1148424756.1249426.1343730266948.JavaMail.root@redhat.com>
Message-ID: <alpine.LFD.2.00.1207311402440.2118@(none)>
References: <1148424756.1249426.1343730266948.JavaMail.root@redhat.com>
MIME-Version: 1.0
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Tue, 31 Jul 2012, Tomas Racek wrote:

> Date: Tue, 31 Jul 2012 06:24:26 -0400 (EDT)
> From: Tomas Racek <tracek@redhat.com>
> To: Dave Chinner <david@fromorbit.com>
> Cc: lczerner@redhat.com, xfs@oss.sgi.com
> Subject: Re: [PATCH] xfstests: Change fstrim behaviour to be consistent with
>     upstream version
> 
> > If we have duplicate code (i.e. a copy of the upstream utility) or
> > the local tool can be completely replaced by the upstream tool,
> > then we should use upstream and remove the local copy completely.
> > Distros have been shipping fstrim for long enough now that most
> > people running testing on upstream kernels will have it installed...
> > 
> 
> OK, I'll create the patch which drops local version.
> 
> > Adding a _require_fstrim() function that checks for the upstream
> > version of fstrim to be installed for each test that requires it
> > would go along with this.
> 
> Did you mean something like
> 
> _require_fstrim()
> {
>          which fstrim &>/dev/null || _notrun "This test requires fstrim utility."
> }
> 
> in common.rc or locally in each test?

I think that having this test in common.rc along with others is definitely
better option.

And while you're in it, you can also add another _require_ for the
actual FITRIM support. Although calling it _require_fitrim seems
rather confusing, so maybe _require_batched_discard with the device
as an argument ?

Thanks!
-Lukas

> 
> Thanks for comments!
> 
> Tomas
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
