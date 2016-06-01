Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C08B7CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:31:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DFAF304059
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 05:31:25 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 5DM4eIzlRAuZuiKA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 05:31:23 -0700 (PDT)
Date: Wed, 1 Jun 2016 14:31:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap infrastructure and multipage writes V4
Message-ID: <20160601123121.GA23101@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
	<20160601063553.GI12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160601063553.GI12670@dastard>
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
Cc: rpeterso@redhat.com, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jun 01, 2016 at 04:35:53PM +1000, Dave Chinner wrote:
> I just pulled this forward to 4.7-rc1, and I get an immediate
> failure in generic/346:

> Maybe I screwed up the forward merge sorting out all the bits that
> conflicted with what went into 4.7-rc1. Perhaps it would be best if
> you rebased and reposted, Christoph?

No, I screwed up and enabled that BUG_ON for the buffered read
case accidentally - it was only supposed to be there for direct I/O.

I've rebase three and fixed it up.  I'll resend it as soon as the
xfstests run completes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
