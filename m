Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F1477F37
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 18:16:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67D25304039
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 16:16:43 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	IqYghfeuCKLMy2b9 for <xfs@oss.sgi.com>;
	Thu, 07 Jan 2016 16:16:41 -0800 (PST)
Date: Fri, 8 Jan 2016 11:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/4] xfs: unmap dax at shutdown (force_failure)
Message-ID: <20160108001639.GR21461@dastard>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160106045632.38788.84927.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160106045632.38788.84927.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com

On Tue, Jan 05, 2016 at 08:56:32PM -0800, Dan Williams wrote:
> When an exceptional event triggers xfs_force_shutdown() tear down dax
> mappings.  Quoting Dave,
> 
>     "The simple fact is that a /filesystem/ shutdown needs to do DAX
>     mapping invalidation regardless of whether the block device has
>     been unplugged or not. This is not a case of "this only happens
>     when we unplug the device", this is a user data protection
>     mechanism that we use to prevent corruption propagation once it
>     has been detected. A device unplug is just one type of
>     "corruption" that can occur."
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/xfs_fsops.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ee3aaa0a5317..0c6a52809dcc 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -828,6 +828,15 @@ xfs_do_force_shutdown(
>  	if (xfs_log_force_umount(mp, logerror))
>  		return;
>  
> +	/*
> +	 * If DAX is in use, we have to unmap all direct access virtual
> +	 * mappings to ensure nothing more gets written directly from
> +	 * userspace. This will force them to refault and that will
> +	 * result in them detecting the shutdown condition and hence
> +	 * will fail appropriately.
> +	 */
> +	unmap_dax_inodes(mp->m_super);
> +
>  	if (flags & SHUTDOWN_CORRUPT_INCORE) {
>  		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
>      "Corruption of in-memory data detected.  Shutting down filesystem");

Looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
