Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0909D7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 16:02:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA0E2304051
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 14:02:37 -0700 (PDT)
Date: Tue, 16 Sep 2014 14:02:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140916210235.GA24591@infradead.org>
References: <20140911203735.GA19952@sgi.com> <20140912100230.GB4267@dastard>
	<5412DF37.9030005@sgi.com> <20140912205528.GB11717@infradead.org>
	<54169248.1090105@sgi.com> <20140916205406.GJ4322@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140916205406.GJ4322@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, tinguely@sgi.com, Olaf Weber <olaf@sgi.com>, xfs@oss.sgi.com

On Wed, Sep 17, 2014 at 06:54:06AM +1000, Dave Chinner wrote:
> So how do existing utf8/unicode enabled filesystems handle this? 
> 
> I think we should be consistent with ZFS, MacOS and others that
> already deal with this problem if at all possible. However, this
> really is a wider policy decision for the kernel/VFS as we want
> consistent behaviour across all linux filesystems, hence this
> patchset really needs to discussed at the lkml/-fsdevel level...

Absolutely.  I've also talked to a few Samba folks at SDC, and one
thing they would love to see is conditional case insensitive lookups,
e.g.:

 - we hash case insensitive with collisions, but perform normal case
   sensitive lookups.
 - with a new AT_CASE_INSENSTIVE flag to the various *at calls that
   gets passed down to the dcache we enable CI lookups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
