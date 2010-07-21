Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LCGgbu077014 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 07:16:42 -0500
Date: Wed, 21 Jul 2010 14:19:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] [PATCH] fs/xfs: Remove dead CONFIG_XFS_DMAPI
Message-ID: <20100721121904.GA17637@lst.de>
References: <20100721113646.GA1054@faui49.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100721113646.GA1054@faui49.informatik.uni-erlangen.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, vamos-dev@i4.informatik.uni-erlangen.de, Al Viro <viro@zeniv.linux.org.uk>, Alex Elder <aelder@sgi.com>, Stephen Hemminger <shemminger@vyatta.com>, Alexey Dobriyan <adobriyan@gmail.com>

On Wed, Jul 21, 2010 at 01:36:47PM +0200, Christian Dietrich wrote:
> CONFIG_XFS_DMAPI doesn't exist in Kconfig and is never defined anywhere
> else, therefore removing all references for it from the source
> code. Because XFS_DMAPI is never defined, XFS_DMAPI_STRING is always
> an empty string. So we can remove all references to it.

This code is already gone in the XFS queue for the next merge window.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
