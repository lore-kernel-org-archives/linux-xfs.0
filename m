Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A85867F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 18:27:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F7ED8F8037
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 16:27:42 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pjnlqGiATXkTDDuw for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 16:27:40 -0800 (PST)
Date: Fri, 14 Feb 2014 11:27:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V3] xfs: skip verification on initial "guess" superblock
	read
Message-ID: <20140214002708.GO13997@dastard>
References: <52FD3C59.3050400@redhat.com>
 <52FD55FC.1000103@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FD55FC.1000103@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 13, 2014 at 05:32:12PM -0600, Eric Sandeen wrote:
> When xfs_readsb() does the very first read of the superblock,
> it makes a guess at the length of the buffer, based on the
> sector size of the underlying storage.  This may or may
> not match the filesystem sector size in sb_sectsize, so
> we can't i.e. do a CRC check on it; it might be too short.
> 
> In fact, mounting a filesystem with sb_sectsize larger
> than the device sector size will cause a mount failure
> if CRCs are enabled, because we are checksumming a length
> which exceeds the buffer passed to it.
> 
> So always read twice; the first time we read with NULL
> buffer ops to skip verification; then set the proper
> read length, hook up the proper verifier, and give it
> another go.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine. I'll run it through some testing and we can go from
there. FWIW, does this make your "check the sector size in the sb
verifier" patch redundant?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
