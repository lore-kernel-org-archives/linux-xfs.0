Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C3AC7F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 22:42:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99ED5AC002
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 20:42:15 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lp0tkwGlHlhlw766 for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 20:41:44 -0800 (PST)
Date: Wed, 4 Mar 2015 15:41:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150304044141.GQ18360@dastard>
References: <20150303221033.GB19439@fieldses.org>
	<20150303224456.GV4251@dastard>
	<20150304020826.GD19439@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304020826.GD19439@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Mar 03, 2015 at 09:08:26PM -0500, J. Bruce Fields wrote:
> By the way, Christoph, an unrelated question: how are the devices found,
> and what are the chances of a client writing to the wrong block device?
> 
> (E.g., if they're addressed based on a uuid that doesn't change on
> cloning the block device, and if the client had access to another device
> with an identical copy of the filesystem, could it end up writing to
> that instead?)

As I understand it, nothing will prevent this - if you don't change
the UUID on the filesystem when you clone it, then the UUID will
still match and writes can be directed to any block deice with a
matching offset/UUID pair.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
