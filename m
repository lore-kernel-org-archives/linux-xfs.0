Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 970D77FA7
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 15:55:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AFBB30405F
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 13:55:30 -0700 (PDT)
Date: Fri, 12 Sep 2014 13:55:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140912205528.GB11717@infradead.org>
References: <20140911203735.GA19952@sgi.com> <20140912100230.GB4267@dastard>
	<5412DF37.9030005@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5412DF37.9030005@sgi.com>
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
Cc: Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On Fri, Sep 12, 2014 at 01:55:35PM +0200, Olaf Weber wrote:
> I looked up those discussions in the archives.  For example, here's
> Christoph about rejecting filenames if they're not well-formed unicode.
>    http://marc.info/?l=linux-fsdevel&m=120876935526856&w=2
> And Jamie Lokier making a similar point:
>    http://oss.sgi.com/archives/xfs/2008-04/msg01263.html

And I might now disagree with my past self.  While non-ut8 characters
are perfectly valid unix filenames, and I think everyones life is easier
if we generally stay out of the utf8 business it seems that for this
particular use case (shared filesystem with Windows, right) just
accepting utf8 should be fine.  ZFS is doing, MacOS X apparently is,
and NFSv4 requires it, although as far as I know most implementations
ignore that requirement.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
