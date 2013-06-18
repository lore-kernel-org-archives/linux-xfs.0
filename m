Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E35529DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 23:55:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B315304032
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 21:55:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id H3GhYdaBMjV1zZOu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 21:55:35 -0700 (PDT)
Date: Mon, 17 Jun 2013 21:55:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls
Message-ID: <20130618045529.GA20365@infradead.org>
References: <1371238877-5722-1-git-send-email-cmaiolino@redhat.com>
	<20130618044931.GQ29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618044931.GQ29338@dastard>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 02:49:31PM +1000, Dave Chinner wrote:
> 	xfs_set_mode()
> 	{
> 		setup iattr
> 		return xfs_setattr_nonsize_nomodecheck()
> 	}

I'd rather opencode updating the mode here, it's really just a tiny bit
of boilerplate code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
