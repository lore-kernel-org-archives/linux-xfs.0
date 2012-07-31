Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VC1jAv174410 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 07:01:45 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 65oAm9VlGsPdXamW for
	<xfs@oss.sgi.com>; Tue, 31 Jul 2012 05:01:44 -0700 (PDT)
Date: Tue, 31 Jul 2012 14:01:32 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: Change fstrim behaviour to be consistent with
	upstream version
In-Reply-To: <20120731023335.GA31494@infradead.org>
Message-ID: <alpine.LFD.2.00.1207311357520.2118@(none)>
References: <1343649963-14079-1-git-send-email-tracek@redhat.com>
	<20120730220413.GI2877@dastard>
	<20120731023335.GA31494@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>, xfs@oss.sgi.com

On Mon, 30 Jul 2012, Christoph Hellwig wrote:

> Date: Mon, 30 Jul 2012 22:33:36 -0400
> From: Christoph Hellwig <hch@infradead.org>
> To: Dave Chinner <david@fromorbit.com>
> Cc: Tomas Racek <tracek@redhat.com>, lczerner@redhat.com, xfs@oss.sgi.com
> Subject: Re: [PATCH] xfstests: Change fstrim behaviour to be consistent with
>     upstream version
> 
> On Tue, Jul 31, 2012 at 08:04:13AM +1000, Dave Chinner wrote:
> > If we have duplicate code (i.e. a copy of the upstream utility) or
> > the local tool can be completely replaced by the upstream tool,
> > then we should use upstream and remove the local copy completely.
> > Distros have been shipping fstrim for long enough now that most
> > people running testing on upstream kernels will have it installed...
> > 
> > Adding a _require_fstrim() function that checks for the upstream
> > version of fstrim to be installed for each test that requires it
> > would go along with this.
> 
> I would also vote for just using the upstream util-linux fstrim.  Not
> quite sure what the history was here, but it might have been that the
> xfstests one actually was the earlier version.  Lukas, any opinions?
> 

The local xfstests version was indeed the earlier version and it was
not even in the util-linux back then. So now, when we already have
fstrim in util-linux and most distributions already ship it, I do
not see any reason for maintaining the local copy anymore.

I agree that we should be using upstream fstrim and remove the local
version completely.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
