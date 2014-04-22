Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA1057F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 01:28:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B98CF304053
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 23:28:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id PWCPibAmplYD0xiL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 23:28:17 -0700 (PDT)
Date: Mon, 21 Apr 2014 23:28:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Message-ID: <20140422062816.GB31337@infradead.org>
References: <20140421204023.GB960@wallace>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140421204023.GB960@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

> +# check that xfs_io, kernel, and filesystem all support fallocate with zero
> +# range
> +_require_xfs_io_falloc_zero()
> +{
> +	_require_xfs_io_command "fzero"
> +}

I'd rather remove all the wrappers around _require_xfs_io_command, they
don't actually add any value.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
