Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F40B17F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 09:36:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D2E4D8F8035
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:36:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id MObrCpFIGRIQqvQo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:36:25 -0800 (PST)
Date: Tue, 17 Nov 2015 07:36:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: clone ioctl return values
Message-ID: <20151117153623.GA27322@infradead.org>
References: <20151116120431.GA2860@infradead.org>
	<20151117002822.GA32467@birch.djwong.org>
	<20151117105433.GA18093@infradead.org>
	<20151117135745.GF17545@ret.masoncoding.com>
	<20151117152251.GA5392@infradead.org>
	<20151117153320.GU22011@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117153320.GU22011@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com

On Tue, Nov 17, 2015 at 03:33:20PM +0000, Al Viro wrote:
> On Tue, Nov 17, 2015 at 07:22:52AM -0800, Christoph Hellwig wrote:
> 
> > Yes, I saw that.  So so far I'd suggest something like the following
> > for btrfs:
> > 
> >  - return EBADFD for missing read/wite permissions
> 
> Yowwwch...  What the hell does that have to do with STREAMS?  Or are you
> using EBADFD as "nobody uses that error value anyway, let's assign it
> whatever meaning we need"?
> 
> Besides, that'll be confused with EBADF all the time.  I strongly
> recommend against that.

Yes, I meant EBADF.  That's what we normally use for missing
FMODE_READ/WRITE or fget failures, so why would this call be different
from everything else?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
