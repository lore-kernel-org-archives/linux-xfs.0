Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3FCD7F37
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 01:42:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56069AC002
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 23:42:04 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id UAD1fjaaCJpiuZS7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Nov 2015 23:42:01 -0800 (PST)
Date: Mon, 23 Nov 2015 23:41:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
	output
Message-ID: <20151124074159.GA32289@infradead.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
	<20151121005014.20398.22316.stgit@birch.djwong.org>
	<20151121180644.GA23916@infradead.org>
	<20151123212533.GC10589@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151123212533.GC10589@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Mon, Nov 23, 2015 at 01:25:33PM -0800, Darrick J. Wong wrote:
> > Shouldn't these be Invalid argument just like the
> > to a device case above or the clone case?
> 
> I was trying to mirror the behavior of reflink, which spits out
> EOPNOTSUPP when the destination isn't a regular file and EINVAL
> when the source isn't a regular file.

clone is called on the destination and takes the source from the
ioctl argument.  dedupe is called on the source and then opens the
destinations, so they're not really comparable.  Btrfs currently
returns EACCES for non-dir, non-regular destinations which look
wrong and I think EINVAL for a mismatch between source and destination
types would make most sense.  I've also prepared a btrfs patch for
this and clone, but I'd like to have consensus on the exact error
first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
