Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F318C7F52
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 10:12:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EAA6AC00A
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 08:12:27 -0800 (PST)
Date: Tue, 10 Dec 2013 08:12:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/10] xfs: format log items write directly into the
	linear CIL buffer
Message-ID: <20131210161223.GC19510@infradead.org>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084001.028583376@bombadil.infradead.org>
	<20131204003712.GE10988@dastard> <20131209190028.GW1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209190028.GW1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Dec 09, 2013 at 01:00:28PM -0600, Ben Myers wrote:
> > And if we need to guarantee alignment, then maybe roundup here to
> > ensure we don't end up with bad offsets?  That would require padding
> > the allocation of the buffer to take it into account, too....
> > 
> > Other than this concern, the code looks fine.
> 
> Christoph, what about this alignment issue?

I think Dave is right, but I haven't had time to look at the issue in
detail and respin the patchset yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
