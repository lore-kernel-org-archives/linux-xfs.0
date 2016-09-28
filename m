Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E4997CA1
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 21:09:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3713AC003
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 19:09:50 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CecLIo8D8GC7Z1C5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2016 19:09:49 -0700 (PDT)
Date: Tue, 27 Sep 2016 19:09:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxfs: remove unused libxfs_iget arg
Message-ID: <20160928020948.GB4428@infradead.org>
References: <355fec5f-f7ef-8472-c71b-7bfa9d9ab8bd@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <355fec5f-f7ef-8472-c71b-7bfa9d9ab8bd@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 27, 2016 at 01:10:28PM -0500, Eric Sandeen wrote:
> libxfs_iget() is always called with bno == 0.
> Which is probably a good thing, because it then passes
> bno to xfs_iread as iget_flags!
> 
> So remove the libxfs_iget arg, and explicitly pass
> 0 to xfs_iread for flags.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (or should we just rename/re-type bno to a flags arg?)

Killing it seems fine to me.  Any argument not actually used is just
asking for bugs like the one you just fixed.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
