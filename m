Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CBA329DFB
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 17:33:41 -0500 (CDT)
Date: Tue, 1 Oct 2013 17:33:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix the wrong new_size/rnew_size at
	xfs_iext_realloc_direct()
Message-ID: <20131001223340.GU1935@sgi.com>
References: <523EA96B.3040904@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523EA96B.3040904@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Sep 22, 2013 at 04:25:15PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> At xfs_iext_realloc_direct(), the new_size is changed by adding
> if_bytes if originally the extent records are stored at the inline
> extent buffer, and we have to switch from it to a direct extent
> list for those new allocated extents, this is wrong. e.g,
> 
> Create a file with three extents which was showing as following,
> 
> xfs_io -f -c "truncate 100m" /xfs/testme
> 
> for i in $(seq 0 5 10); do
> 	offset=$(($i * $((1 << 20))))
> 	xfs_io -c "pwrite $offset 1m" /xfs/testme
> done
> 
> Inline
> ------
> irec:	if_bytes	bytes_diff	new_size
> 1st	0		16		16
> 2nd	16		16		32
> 
> Switching
> ---------						rnew_size
> 3rd	32		16		48 + 32 = 80	roundup=128
> 
> In this case, the desired value of new_size should be 48, and then
> it will be roundup to 64 and be assigned to rnew_size.
> 
> However, this issue has been covered by resetting the if_bytes to
> the new_size which is calculated at the begnning of xfs_iext_add()
> before leaving out this function, and in turn make the rnew_size
> correctly again. Hence, this can not be detected via xfstestes.
> 
> This patch fix above problem and revise the new_size comments at
> xfs_iext_realloc_direct() to make it more readable.  Also, fix the
> comments while switching from the inline extent buffer to a direct
> extent list to reflect this change.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
