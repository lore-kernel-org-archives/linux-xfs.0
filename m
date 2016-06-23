Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 641A27CA1
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 18:25:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0892AC003
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2016 16:24:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WacvkWjcMwBec3TK for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2016 16:24:55 -0700 (PDT)
Date: Fri, 24 Jun 2016 09:24:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Message-ID: <20160623232446.GA12670@dastard>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466609236-23801-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com

On Wed, Jun 22, 2016 at 05:27:08PM +0200, Christoph Hellwig wrote:
> The last patch is what started the series:  XFS currently uses the
> direct I/O locking strategy for DAX because DAX was overloaded onto
> the direct I/O path.  For XFS this means that we only take a shared
> inode lock instead of the normal exclusive one for writes IFF they
> are properly aligned.  While this is fine for O_DIRECT which requires
> explicit opt-in from the application it's not fine for DAX where we'll
> suddenly lose expected and required synchronization of the file system
> happens to use DAX undeneath.

Except we did that *intentionally* - by definition there is no
cache to bypass with DAX and so all IO is "direct". That, combined
with the fact that all Linux filesystems except XFS break the POSIX
exclusive writer rule you are quoting to begin with, it seemed
pointless to enforce it for DAX....

So, before taking any patches to change that behaviour in XFS, a
wider discussion about the policy needs to be had. I don't think
we should care about POSIX here - if you have an application that
needs this serialisation, turn off DAX. That's why I made it a
per-inode inheritable flag and why the mount option will go away
over time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
