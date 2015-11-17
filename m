Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B9467F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 04:54:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29D6EAC002
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 02:54:38 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id aoKnDlRpXyo67PF5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 02:54:34 -0800 (PST)
Date: Tue, 17 Nov 2015 02:54:33 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: clone ioctl return values
Message-ID: <20151117105433.GA18093@infradead.org>
References: <20151116120431.GA2860@infradead.org>
	<20151117002822.GA32467@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117002822.GA32467@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 16, 2015 at 04:28:22PM -0800, Darrick J. Wong wrote:
> >  Try to reflink a device
> > -XFS_IOC_CLONE_RANGE: Invalid argument
> > +/mnt/test/test-157/dev1: No such device or address
> 
> Huh.  How did you get -ENODEV here?  I ran this on 4.3 and got -EINVAL.

This is current 4.4-rc.  The error seems accidental I think.

> Errrgh, the golden output of this test reflects the changes to the input
> checking in Anna/Peng's copy_file_range/clone_file_range patches.
> 
> So, I guess the question is, should I reset the golden output to whatever
> btrfs spits out before that patchset, and we'll consider the alterations
> to be bugs/regressions/whatever that ought to be fixed in their patches?

Some bits in btrfs don't seem kosher.  But it would be good to
explicitly send patches for btrfs to adopt to what might make more
sense, and then follow it in the other implementations.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
