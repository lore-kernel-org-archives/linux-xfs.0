Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D6A8A7F3F
	for <xfs@oss.sgi.com>; Sat, 11 Jan 2014 05:10:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C89908F8054
	for <xfs@oss.sgi.com>; Sat, 11 Jan 2014 03:10:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id s1kBt5AIhMhmGIKl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 11 Jan 2014 03:10:50 -0800 (PST)
Date: Sat, 11 Jan 2014 03:10:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs] c91c46c12: xfstests generic/313 regression
Message-ID: <20140111111045.GA29380@infradead.org>
References: <20140110122700.GA12624@localhost> <52CFF402.5080409@oracle.com>
	<20140110133306.GA22918@infradead.org>
	<52CFFD1C.7050005@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52CFFD1C.7050005@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jan 10, 2014 at 10:01:00PM +0800, Jeff Liu wrote:
> I also thought to fix this problem in this way, however I'm not sure
> if those flags can be set back to iattr->ia_valid internally...
> 
> Otherwise, this fix looks good to me.

Nothing in the truncate or open code path (or non-size setattr for that
matter) looks at ia_valid after calling the filesystem, and they really
have no business to.

In the meantime this has passed xfstests, so I'll send it along.  Thanks
for the first fix, btw!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
