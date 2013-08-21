Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4307A7F72
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 11:50:22 -0500 (CDT)
Message-ID: <5214EFFF.4060105@sgi.com>
Date: Wed, 21 Aug 2013 11:51:11 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix Out-of-bounds access in repair/dinode.c
References: <1376287861.2822.13.camel@ThinkPad-T5421>
In-Reply-To: <1376287861.2822.13.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

Looks good, thanks for the patch Li Zhong. it has been committed.

--Rich

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

commit e7c05095f5baa9cd2e35a6de03d7dd9f51dd3910
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Mon Aug 12 06:11:01 2013 +0000

     xfsprogs: fix Out-of-bounds access in repair/dinode.c

On 08/12/2013 01:11 AM, Li Zhong wrote:
> Following is reported by coverity in bug 1061528:
>
> 187                        __dirty_no_modify_ret(dirty);
>
> CID 1061528 (#1 of 1): Out-of-bounds access (OVERRUN)53. overrun-buffer-arg: Overrunning array "dinoc->di_pad" of 6 bytes by passing it to a function which accesses it at byte offset 15 using argument "16UL".
> 188                        memset(dinoc->di_pad, 0, 16);
>
> It seems that di_pad here should be di_pad2, as sekharan pointed out.
>
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
>   repair/dinode.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/repair/dinode.c b/repair/dinode.c
> index e607f0b..94bf2f8 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -183,9 +183,9 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>   	}
>
>   	for (i = 0; i < 16; i++) {
> -		if (dinoc->di_pad[i] != 0) {
> +		if (dinoc->di_pad2[i] != 0) {
>   			__dirty_no_modify_ret(dirty);
> -			memset(dinoc->di_pad, 0, 16);
> +			memset(dinoc->di_pad2, 0, 16);
>   			break;
>   		}
>   	}
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
