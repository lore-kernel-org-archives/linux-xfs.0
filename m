Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C39D27F75
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 07:30:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45E27AC002
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 05:30:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bFm1AidHb3AU3h0X (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jun 2014 05:30:25 -0700 (PDT)
Date: Thu, 26 Jun 2014 08:30:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/6] xfs: document log sysfs attributes in testing ABI
Message-ID: <20140626123022.GC37470@bfoster.bfoster>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
	<1402060414-22075-7-git-send-email-bfoster@redhat.com>
	<20140626050345.GZ4453@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140626050345.GZ4453@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 26, 2014 at 03:03:45PM +1000, Dave Chinner wrote:
> On Fri, Jun 06, 2014 at 09:13:34AM -0400, Brian Foster wrote:
> > Create a sysfs-fs-xfs ABI documentation file for newly added sysfs
> > attributes. This is created under the testing section.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Looks fine, but I'm not sure we ever want people to think these are
> going to form part of the stable XFS ABI - they are encodings of
> deeply internal functionality of XFS. We're not going to be tied to
> an implementation because of diagnostic information we expose to
> to sysfs, so users need to know that this is a volatile interface.
> 

I was under the impression that sysfs in general was considered a stable
ABI. Perhaps not to the degree of things like system call interfaces,
but the Documentation/ABI/README describes the expected lifecycle for
these attributes (i.e., testing->stable->obsolete->removed).

> Hence I'd suggest adding a disclaimer indicating that these not ever
> guaranteed to be stable and could change or be removed at any time
> without warning. Say, for example, we add another description line
> like this:
> 
>    Stability:		Volatile
> 
> We can then point out the entries that are we'll never guarantee are
> stable, those that we are stabilising, and those that are considered
> stable easily?
> 

I'm not against adding another keyword, though I'm curious how this is
different from the above. Wouldn't we use the location of the
documentation to identify how stable the interface is expected to be? To
put it another way, this seems fine under the testing section (but that
suggests volatility already), but I wouldn't ever place a "Stability:
volatile" attribute under the stable section.

Taking a look at the ABI/testing/sysfs-fs-ext4 file, it goes back to
2009 with the most recent update in 2012 and it's still under the
testing section. It's not clear if that's by design or just stale
documentation, but perhaps that is technically the right approach. E.g.,
while clearly those attributes aren't still under "testing," they aren't
ever going to be considered "stable ABI." That means use them for
informational and tuning purposes, don't ever build userspace programs
with significant dependence on them, etc. Anything that does grow unique
importance (i.e., a future spaceman dependency) can get moved over to
stable as we'll expect to provide some kind of deprecation warning and
period of backwards compatibility for supported tools. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
