Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4624A7CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 09:54:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03AFA304051
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 07:54:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xyln8YJTycv8mLi4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 07:54:21 -0700 (PDT)
Date: Wed, 16 Mar 2016 22:54:18 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs/073: filter out finobt warning from mkfs.xfs
Message-ID: <20160316145418.GT11419@eguan.usersys.redhat.com>
References: <1458129204-31882-1-git-send-email-eguan@redhat.com>
	<20160316120416.GA18030@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160316120416.GA18030@infradead.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 16, 2016 at 05:04:16AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 16, 2016 at 07:53:24PM +0800, Eryu Guan wrote:
> > When testing xfs/073 with MKFS_OPTIONS="-m crc=1,finobt=1" set, it fails
> > due to extra warning about disabling finobt feature:
> > 
> >  +warning: finobt not supported without CRC support, disabled.
> > 
> > Because xfs/073 disables crc unconditionally and finobt can not be
> > enabled either.
> 
> How about explicitly disabling finobt as well?

I think that's a cleaner way to fix it. Just that some extra work is
needed to let the test pass with old mkfs.xfs without metadata suport.

Will send v2 shortly. Thanks for the review!

Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
