Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A06A129DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 13:06:34 -0500 (CDT)
Date: Fri, 23 Aug 2013 13:06:30 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: Simplify xfs_ail_min() with
	list_first_entry_or_null()
Message-ID: <20130823180630.GU5262@sgi.com>
References: <520C6253.6080809@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520C6253.6080809@oracle.com>
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

On Thu, Aug 15, 2013 at 01:08:35PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> At xfs_ail_min(), we do check if the AIL list is empty or not before
> returning the first item in it with list_empty() and list_first_entry().
> 
> This can be simplified a bit with a new list operation routine that is
> the list_first_entry_or_null() which has been introduced by:
> 
> commit 6d7581e62f8be462440d7b22c6361f7c9fa4902b
>     list: introduce list_first_entry_or_null
> 
> v2: make xfs_ail_min() as a static inline function and move it to
>     xfs_trans_priv.h as per Dave Chinner's comments.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Applied.  Thanks Jeff.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
