Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 552E17F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 20:47:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 255428F8040
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 18:47:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NUlgtBhOQi1QJLqW for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 18:47:22 -0700 (PDT)
Date: Tue, 9 Sep 2014 11:47:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: add a few more verifier tests
Message-ID: <20140909014720.GU30012@dastard>
References: <53F2C103.8030607@redhat.com>
 <53F3A726.8080305@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F3A726.8080305@sandeen.net>
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

On Tue, Aug 19, 2014 at 02:36:06PM -0500, Eric Sandeen wrote:
> These were exposed by fsfuzzer runs; without them we fail
> in various exciting and sometimes convoluted ways when we
> encounter disk corruption.
> 
> Without the MAXLEVELS tests we tend to walk off the end of
> an array in a loop like this:
> 
>         for (i = 0; i < cur->bc_nlevels; i++) {
>                 if (cur->bc_bufs[i])
> 
> Without the dirblklog test we try to allocate more memory
> than we could possibly hope for and loop forever:
> 
> xfs_dabuf_map()
> 	nfsb = mp->m_dir_geo->fsbcount;
> 	irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_SLEEP...
> 
> As for the logbsize check, that's the convoluted one.
> 
> If logbsize is specified at mount time, it's sanitized
> in xfs_parseargs; in particular it makes sure that it's
> not > XLOG_MAX_RECORD_BSIZE.
>     
> If not specified at mount time, it comes from the superblock
> via sb_logsunit; this is limited to 256k at mkfs time as well;
> it's copied into m_logbsize in xfs_finish_flags().
>     
> However, if for some reason the on-disk value is corrupt and
> too large, nothing catches it.  It's a circuitous path, but
> that size eventually finds its way to places that make the kernel
> very unhappy, leading to oopses in xlog_pack_data() because we
> use the size as an index into iclog->ic_data, but the array
> is not necessarily that big.
> 
> Anyway - bounds checking when we read from disk is a good thing!
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> --

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
