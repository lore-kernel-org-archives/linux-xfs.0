Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F1EC7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 10:21:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BCE4CAC003
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 08:21:39 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id JFFA9mRVx3NScBac (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 08:21:37 -0700 (PDT)
Date: Wed, 18 Jun 2014 17:21:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: require 64-bit sector_t
Message-ID: <20140618152135.GA11821@lst.de>
References: <1402937045-31103-1-git-send-email-hch@lst.de>
	<20140617141431.GA8905@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140617141431.GA8905@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jun 17, 2014 at 10:14:31AM -0400, Brian Foster wrote:
> Given that the existence of the string indicates large block/inode
> numbers, shouldn't we leave it to avoid any confusion? That aside, the
> rest of the patch looks fine to me.

As these have been enabled in any sane configuration I don't really see
a point in printing these.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
