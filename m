Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BCA1129DFD
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 22:02:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B368304043
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 20:02:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CwUAJWeIuMONltmL for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 20:02:52 -0700 (PDT)
Message-ID: <55CD5A5B.9080201@sandeen.net>
Date: Thu, 13 Aug 2015 22:02:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Fix xfs_attr_leafblock definition
References: <1439458000-28395-1-git-send-email-jack@suse.com>
In-Reply-To: <1439458000-28395-1-git-send-email-jack@suse.com>
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
To: Jan Kara <jack@suse.com>, xfs@oss.sgi.com

On 8/13/15 4:26 AM, Jan Kara wrote:
> struct xfs_attr_leafblock contains 'entries' array which is declared
> with size 1 altough it can in fact contain much more entries. Since this
> array is followed by further struct members, gcc (at least in version
> 4.8.3) thinks that the array has the fixed size of 1 element and thus
> may optimize away all accesses beyond the end of array resulting in
> non-working code. This problem was only observed with userspace code in
> xfsprogs, however it's better to be safe in kernel as well and have
> matching kernel and xfsprogs definitions.
> 
> Signed-off-by: Jan Kara <jack@suse.com>
> ---
>  fs/xfs/libxfs/xfs_da_format.h | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
>  This is a kernel version of the xfsprogs patch I've sent a while ago.
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 74bcbabfa523..b14bbd6bb05f 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -680,8 +680,15 @@ typedef struct xfs_attr_leaf_name_remote {
>  typedef struct xfs_attr_leafblock {
>  	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
>  	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
> -	xfs_attr_leaf_name_local_t namelist;	/* grows from bottom of buf */
> -	xfs_attr_leaf_name_remote_t valuelist;	/* grows from bottom of buf */
> +	/*
> +	 * The rest of the block contains the following structures after the
> +	 * leaf entries, growing from the bottom up. The variables are never
> +	 * referenced and definining them can actually make gcc optimize away

Nitpick, s/definining/defining/, maybe can be fixed on commit :)

Don't we have other similar constructs elsewhere?  Do they suffer the same
fate?

... looks ...

I guess not; the other ones have the variable length array as the last member.

-Eric

> +	 * accesses to the 'entries' array above index 0 so don't do that.
> +	 *
> +	 * xfs_attr_leaf_name_local_t namelist;
> +	 * xfs_attr_leaf_name_remote_t valuelist;
> +	 */
>  } xfs_attr_leafblock_t;
>  
>  /*
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
