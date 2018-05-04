Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54882 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751621AbeEDWlI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 18:41:08 -0400
Subject: Re: [PATCH 11/11] xfs_repair: don't assert on bad '.' entry in
 no-modify mode
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401966025.13319.16584599904269469257.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fff8ec8c-0c23-7a38-b323-233db98cffdd@sandeen.net>
Date: Fri, 4 May 2018 17:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <152401966025.13319.16584599904269469257.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During phase 3, we check the '.' entry of a directory inode and (in
> modify mode) zap it if the name isn't valid.  During phase 6, we assert
> that the '.' entry now reflects the correct name.  In no-modify mode
> this is incorrect because we didn't actually fix anything, so repair
> asserts and crashes.
> 
> Found by fuzzing bu[0].namelen = 4 in xfs/387 and running xfs_repair -n.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/phase6.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 2005e40..e65fc4a 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1884,7 +1884,8 @@ longform_dir2_entry_check_data(
>  		 * of when directory is moved to orphanage.
>  		 */
>  		if (ip->i_ino == inum)  {
> -			ASSERT(dep->name[0] == '.' && dep->namelen == 1);
> +			ASSERT(no_modify ||
> +			       (dep->name[0] == '.' && dep->namelen == 1));
>  			add_inode_ref(current_irec, current_ino_offset);
>  			if (da_bno != 0 ||
>  			    dep != M_DIROPS(mp)->data_entry_p(d)) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
