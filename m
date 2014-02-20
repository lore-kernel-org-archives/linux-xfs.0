Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 463F87FAD
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 16:40:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21C798F8040
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 14:40:29 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7DhNHeSqfwanqiE5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 14:40:27 -0800 (PST)
Date: Thu, 20 Feb 2014 14:40:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: add support for O_TMPFILE opens
Message-ID: <20140220224026.GA25054@infradead.org>
References: <20140220220000.GA17541@infradead.org>
	<20140220221518.GR4916@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140220221518.GR4916@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Feb 21, 2014 at 09:15:18AM +1100, Dave Chinner wrote:
> Can you also push this into the main CLI interface similar to how
> all the other open flags can be specified?

Sure.

> FWIW, any plans to add a "link" command to be able to link the
> tmpfile into the namespace once it is created?

I was planning to do that, but as pointed out in my next mail it seems
we don't actually have any other namespace commands in xfs_io, so I'm
starting to wonder if it's the right place.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
