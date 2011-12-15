Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBF3D5UN244893 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 21:13:05 -0600
Date: Wed, 14 Dec 2011 21:13:33 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 12/19] xfs: flatten the dquot lock ordering
Message-ID: <20111215031333.GG29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215854.769664827@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215854.769664827@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Dec 06, 2011 at 04:58:18PM -0500, Christoph Hellwig wrote:
> Index: xfs/fs/xfs/xfs_dquot.c
> ===================================================================
> @@ -781,11 +787,7 @@ xfs_qm_dqget(
>  			return (EIO);
>  		}
>  	}
> -#endif
>  
> - again:
> -
> -#ifdef DEBUG

Meant to say... moving the goto tag below doesn't look like it was
strictly necessary, but it didn't look like it was possible to get here
without the ilock held anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
