Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E18E57F6D
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 23:53:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B80978F8054
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 21:53:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ofuuVWptODoYITyB for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 21:53:34 -0700 (PDT)
Date: Thu, 26 Jun 2014 14:52:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: add log attributes for log lsn and grant head
	data
Message-ID: <20140626045256.GY4453@dastard>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
	<1402060414-22075-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402060414-22075-6-git-send-email-bfoster@redhat.com>
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

On Fri, Jun 06, 2014 at 09:13:33AM -0400, Brian Foster wrote:
> Create log attributes to export the current runtime state of the log to
> sysfs. Note that the filesystem should be frozen for consistency across
> attributes.
> 
> The following per-mount attributes are created: log_head_lsn,
> log_tail_lsn, reserve_grant_head and write_grant_head. These represent
> the physical log head, tail and reserve and write grant heads
> respectively. Attribute values are exported in the following format:
> 
> 	"cycle:[block,byte]"
> 
> ... where cycle represents the log cycle and [block,bytes] represents
> either the basic block or byte offset of the log, depending on the
> attribute.  Log sequence number (LSN) values are encoded in basic blocks
> and grant heads are encoded in bytes. All values are in decimal format.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_sysfs.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index f837527..fbd82d5 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -23,6 +23,9 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_ag.h"
>  #include "xfs_mount.h"
> +#include "xfs_log_format.h"
> +#include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  
>  struct xfs_sysfs_attr {
>  	struct attribute attr;
> @@ -57,7 +60,70 @@ struct kobj_type xfs_mp_ktype = {
>  
>  /* xlog */
>  
> +STATIC ssize_t
> +log_head_lsn_show(
> +	char	*buf,
> +	void	*data)
> +{
> +	struct xlog *log = data;
> +	int ret;
> +
> +	spin_lock(&log->l_icloglock);
> +	ret = snprintf(buf, PAGE_SIZE, "%d:%d\n", log->l_curr_cycle,
> +			log->l_curr_block);
> +	spin_unlock(&log->l_icloglock);

I'd keep the snprintf() outside the iclog lock, just so sampling
perturbs behaviour as little as possible. i.e. use cycle/block
locals as per all the others.

Otherwise, looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
