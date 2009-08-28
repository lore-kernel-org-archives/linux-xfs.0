Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SMupJd182141 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 17:57:06 -0500
Date: Fri, 28 Aug 2009 18:57:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: update CHANGES
Message-ID: <20090828225745.GA24127@infradead.org>
References: <20090828221304.GA17666@infradead.org>
	<6854DCEB-F9C8-4969-8012-65B0CD671E38@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6854DCEB-F9C8-4969-8012-65B0CD671E38@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Aug 28, 2009 at 05:49:22PM -0500, Felix Blyakher wrote:
>
> On Aug 28, 2009, at 5:13 PM, Christoph Hellwig wrote:
>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Reviewed-by: Felix Blyakher <felixb@sgi.com>

Thanks, I've pushed it out to kernel.org including the missing update
to VERSION to bump it to 3.0.3.

> I'll generate the 3.0.3 package later tonight.

Thanks.  release.sh works fine to me so everything should be good.

> Are we planning on update of other xfs userland pieces at this
> time as well?

The only change since the last release in xfsdump and dmapi is
adding the executable flag to include/install-sh which doesn't really
warrant doing a new release in my opinion.  If you want to do one
anyway I won't complain either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
