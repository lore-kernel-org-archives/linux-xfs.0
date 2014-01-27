Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 724147F58
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 01:41:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20C8DAC003
	for <xfs@oss.sgi.com>; Sun, 26 Jan 2014 23:41:53 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Q7LZQhcdiQTCqsu3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jan 2014 23:41:49 -0800 (PST)
Date: Sun, 26 Jan 2014 23:41:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [NOISE] merge window blues, XFS broken
Message-ID: <20140127074147.GA13100@infradead.org>
References: <52E56386.5040802@gmail.com>
 <20140127015614.GD2212@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140127015614.GD2212@dastard>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 27, 2014 at 12:56:14PM +1100, Dave Chinner wrote:
> Hmmmm - that would point to struct xfs_log_iovec being 12 bytes on
> ia32, similarly the struct xfs_log_vec may not be 8 byte aligned
> when allocated because pointers only require 4 byte alignement.
> 
> Hence the initial data buffer may be 4 byte aligned and so that will
> break the alignment requirement.


Yeah.  Shoulkd be enough to just align the initial lv_buf allocation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
