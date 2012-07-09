Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q69Gf1c9249658 for <xfs@oss.sgi.com>; Mon, 9 Jul 2012 11:41:01 -0500
Message-ID: <4FFB099C.6020809@sgi.com>
Date: Mon, 09 Jul 2012 11:41:00 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs: probe data buffer from page cache for unwritten
	extents
References: <4FF29C2C.2000407@oracle.com>
In-Reply-To: <4FF29C2C.2000407@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 07/03/12 02:15, Jeff Liu wrote:
> Hello,
>
> This is v3 of the patch.
>
> We can trigger BUG() in xfs_seek_data() if met two unwritten without data or hole extents at last version.
> So making the extents map reading in loop could solve it.
>
> Sorry, Am not yet try the repeated holes scenario according to Dave's comments as lack of X64 test env, still
> waiting for it ready.  But this patch is already too long delayed, I have worked it out one weeks ago.
> So I'd like to post it because of it could handle repeated hole/unwritten extents well in a loop, and I also improved
> xfstests:286 with those cases for the verification, will post it soon.
>
> v2->v3:
> Tested by Mark, hit BUG() for continuous unwritten extents without data wrote.
> * xfs_seek_data(), remove BUG() and having extents map search in loop.
>
> v1->v2:
> suggested by Mark.
> * xfs_has_unwritten_buffer(), use the input offset instead of bmap->br_startoff to
>   calculate page index for data buffer probing.
>
> Thanks,
> -Jeff
>
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---

Nice. Up to refining xfs_seek_hole()?


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
