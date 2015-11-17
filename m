Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5ACB7F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 09:12:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C685F8F8035
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:12:31 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0TK1Y6Uex0ZAuWgU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:12:27 -0800 (PST)
Date: Tue, 17 Nov 2015 07:12:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: clone ioctl return values
Message-ID: <20151117151226.GA12860@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 16, 2015 at 04:28:22PM -0800, Darrick J. Wong wrote:
> > -XFS_IOC_CLONE_RANGE: Invalid argument
> > +reflink: Invalid argument
> >  Try reflink past EOF
> > -XFS_IOC_CLONE_RANGE: Invalid argument
> > +reflink: Invalid argument
> >  Try to reflink a dir
> > -XFS_IOC_CLONE_RANGE: Is a directory
> > +reflink: Is a directory
> 
> >  Try to reflink a device
> > -XFS_IOC_CLONE_RANGE: Invalid argument
> > +/mnt/test/test-157/dev1: No such device or address
> 
> Huh.  How did you get -ENODEV here?  I ran this on 4.3 and got -EINVAL.

Turns out this is because my system doesn't have the ramdisk driver
built into the kernel, so opening your block device with major 8, minor
0 already fails.  Might be better to create a char device with
major 1, minor 3 (dev null) as that should always be present.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
