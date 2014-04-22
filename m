Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7A0957F4E
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 04:14:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C7988F8049
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:14:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oowRsFHs2g9USuIA for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 02:14:46 -0700 (PDT)
Date: Tue, 22 Apr 2014 19:14:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Message-ID: <20140422091443.GG15995@dastard>
References: <20140421204023.GB960@wallace>
	<20140422062816.GB31337@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140422062816.GB31337@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>

On Mon, Apr 21, 2014 at 11:28:16PM -0700, Christoph Hellwig wrote:
> > +# check that xfs_io, kernel, and filesystem all support fallocate with zero
> > +# range
> > +_require_xfs_io_falloc_zero()
> > +{
> > +	_require_xfs_io_command "fzero"
> > +}
> 
> I'd rather remove all the wrappers around _require_xfs_io_command, they
> don't actually add any value.

I don't really care either way, as long as all the checks are done
consistently. Send a patch to change them all... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
