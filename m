Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6MJDNH093890 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 16:19:13 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	eUkEJpucDArgaeLk for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 14:21:09 -0800 (PST)
Date: Wed, 7 Nov 2012 09:20:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 08/10] xfs: support multiple inode id filtering in
	eofblocks scan
Message-ID: <20121106222056.GH24575@dastard>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-9-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352213447-59791-9-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 06, 2012 at 09:50:45AM -0500, Brian Foster wrote:
> Enhance the eofblocks scan code to filter based on multiply specified
> inode id values. When multiple inode id values are specified, only
> inodes that match all id values are selected.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

I though maybe you could fold this into the previous patch, but
there's no point in making you paint the bike shed a different
colour here... ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
