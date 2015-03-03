Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27FFD7F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 16:45:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 078528F8035
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 14:45:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vOCyJj5X5vyMYADg for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 14:44:59 -0800 (PST)
Date: Wed, 4 Mar 2015 09:44:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150303224456.GV4251@dastard>
References: <20150303221033.GB19439@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150303221033.GB19439@fieldses.org>
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

On Tue, Mar 03, 2015 at 05:10:33PM -0500, J. Bruce Fields wrote:
> I'm getting mysterious crashes on a server exporting an xfs filesystem.
> 
> Strangely, I've reproduced this on
> 
> 	93aaa830fc17 "Merge tag 'xfs-pnfs-for-linus-3.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
> 
> but haven't yet managed to reproduce on either of its parents
> (24a52e412ef2 or 781355c6e5ae).  That might just be chance, I'll try
> again.

I think you'll find that the bug is only triggered after that XFS
merge because it's what enabled block layout support in the server,
i.e.  nfsd4_setup_layout_type() is now setting the export type to
LAYOUT_BLOCK_VOLUME because XFS has added the necessary functions to
it's export ops.

> I can also try a serial console or something, but for now I'm not
> getting a lot of information about the crashes.

Really need a stack trace - even a photo of the screen with the
stack trace on it will do for starters. ;)

> The filesystem in question isn't on a block device available to the
> client, but I'm still seeing occasional GETLAYOUT and GETDEVICEINFO
> calls; I suppose the client's getting that far, finding no devices it
> can use, and giving up?

I can't see anything in the XFS code that would obviously cause a
problem - its completely unaware to the state of the visibility
of the underlying block device to the pnfs clients or the error
handling paths that PNFS server/clients might take when the block
device is not visible at the client side....

> Sorry for the incomplete report, I'll pass along more when I have it.

No worries, good to have an early heads up. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
