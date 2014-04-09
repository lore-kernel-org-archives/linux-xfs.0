Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DCA807F63
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 15:59:24 -0500 (CDT)
Message-ID: <5345B4AD.1080508@sgi.com>
Date: Wed, 09 Apr 2014 15:59:25 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] libxfs: remove never-read "offset" assignment in
	readbufr_map & writebufr
References: <53459D9A.1040707@sandeen.net>
In-Reply-To: <53459D9A.1040707@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 04/09/14 14:20, Eric Sandeen wrote:
> libxfs_readbufr_map()&  libxfs_writebufr() iterate
> over bp->b_map[] and read each chunk.  The loops start
> out correctly, getting the offset from bm_bn and the
> length from bm_len.  After the IO it correctly
> advances the target buffer pointer by len, but then
> inexplicably advances "offset" by len as well.  The
> whole point of this exercise is to handle discontiguous
> ranges - marching offset along by length of IO done
> is incorrect.
>
> Thankfully offset is immediately reset to the proper
> value again at the top of the loop for the next range,
> so this is harmless, other than being confusing.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
