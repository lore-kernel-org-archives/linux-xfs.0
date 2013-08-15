Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 196E17F50
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 18:15:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9007304064
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:15:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	miz2stWT7xirfF5C for <linux-xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 16:15:25 -0700 (PDT)
Date: Fri, 16 Aug 2013 09:15:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: be more forgiving of a v4 secondary sb w/ junk
	in v5 fields
Message-ID: <20130815231522.GY6023@dastard>
References: <520D1BA3.1050500@redhat.com> <20130815210018.GR6023@dastard>
	<520D44E7.1000905@sandeen.net> <520D592D.4040600@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520D592D.4040600@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>

On Thu, Aug 15, 2013 at 05:41:49PM -0500, Eric Sandeen wrote:
> Today, if xfs_sb_read_verify encounters a v4 superblock
> with junk past v4 fields which includes data in sb_crc,
> it will be treated as a failing checksum and significant
> corruption.
> 
> There are known prior bugs which leave junk at the end
> of the superblock; we don't need to actually fail the
> verification in this case if other checks pan out ok.
> 
> So if this is a secondary superblock, and the primary
> superblock is not V5, don't treat this as a serious
> checksum failure.
> 
> We should probably check the garbage condition as
> we do in xfs_repair, and possibly warn about it
> or self-heal, but that's a different scope of work.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Fine by me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
