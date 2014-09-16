Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3B417F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:54:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DEBDC30404E
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 13:54:22 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	N1uLFZaJd10eE0hJ for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 13:54:21 -0700 (PDT)
Date: Wed, 17 Sep 2014 06:54:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140916205406.GJ4322@dastard>
References: <20140911203735.GA19952@sgi.com> <20140912100230.GB4267@dastard>
	<5412DF37.9030005@sgi.com> <20140912205528.GB11717@infradead.org>
	<54169248.1090105@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54169248.1090105@sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On Mon, Sep 15, 2014 at 09:16:24AM +0200, Olaf Weber wrote:
> On 12-09-14 22:55, Christoph Hellwig wrote:
> >On Fri, Sep 12, 2014 at 01:55:35PM +0200, Olaf Weber wrote:
> >>I looked up those discussions in the archives.  For example, here's
> >>Christoph about rejecting filenames if they're not well-formed unicode.
> >>    http://marc.info/?l=linux-fsdevel&m=120876935526856&w=2
> >>And Jamie Lokier making a similar point:
> >>    http://oss.sgi.com/archives/xfs/2008-04/msg01263.html
> >
> >And I might now disagree with my past self.  While non-ut8 characters
> >are perfectly valid unix filenames, and I think everyones life is easier
> >if we generally stay out of the utf8 business it seems that for this
> >particular use case (shared filesystem with Windows, right) just
> >accepting utf8 should be fine.  ZFS is doing, MacOS X apparently is,
> >and NFSv4 requires it, although as far as I know most implementations
> >ignore that requirement.
> >
> 
> One issue is working in environments that are not UTF-8 clean.  For
> example, unpacking a tarball with non-UTF-8 filenames in it. The
> names would have to be transcoded, which is only really possible if
> you know the original character set. And if the filesystem flat out
> rejects non-UTF-8 filenames, then you'd be unable to unpack the
> tarball at all.

So how do existing utf8/unicode enabled filesystems handle this? 

I think we should be consistent with ZFS, MacOS and others that
already deal with this problem if at all possible. However, this
really is a wider policy decision for the kernel/VFS as we want
consistent behaviour across all linux filesystems, hence this
patchset really needs to discussed at the lkml/-fsdevel level...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
