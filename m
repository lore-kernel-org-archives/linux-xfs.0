Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D33D27F6C
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 17:24:35 -0600 (CST)
Date: Mon, 27 Jan 2014 17:24:35 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: use tr_qm_dqalloc log reservation for dquot alloc
Message-ID: <20140127232435.GN1935@sgi.com>
References: <1390228140-49211-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1390228140-49211-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 20, 2014 at 09:29:00AM -0500, Brian Foster wrote:
> The dquot allocation path in xfs_qm_dqread() currently uses the
> attribute set log reservation, which appears to be incorrect. We
> have reports of transaction reservation overruns with the current
> code. E.g., a repeated run of xfstests test generic/270 on a 512b
> block size fs occassionally produces the following in dmesg:
> 
> 	XFS (sdN): xlog_write: reservation summary:
> 	  trans type  = QM_DQALLOC (30)
> 	  unit res    = 7080 bytes
> 	  current res = -632 bytes
> 	  total reg   = 0 bytes (o/flow = 0 bytes)
> 	  ophdrs      = 0 (ophdr space = 0 bytes)
> 	  ophdr + reg = 0 bytes
> 	  num regions = 0
> 
> 	XFS (sdN): xlog_write: reservation ran out. Need to up reservation
> 
> The dquot allocation case should consist of a write reservation
> (i.e., we are allocating a range of the internal quota file) plus
> the size of the actual dquots. We already have a log reservation
> definition for this operation (tr_qm_dqalloc). Use it in
> xfs_qm_dqread() and update the log reservation calculation function
> to use the write res. calculation function rather than reading the
> assumed to be pre-calculated value directly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me as well.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
