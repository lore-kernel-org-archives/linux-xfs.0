Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D855E7F3F
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 18:32:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D678AC006
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 16:32:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	sGaziFhMwEK6dHEP for <xfs@oss.sgi.com>;
	Thu, 10 Jul 2014 16:32:11 -0700 (PDT)
Date: Fri, 11 Jul 2014 09:32:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 6/6] xfs: document log sysfs attributes in testing ABI
Message-ID: <20140710233209.GN4453@dastard>
References: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
	<1403870821-20143-7-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1403870821-20143-7-git-send-email-bfoster@redhat.com>
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

On Fri, Jun 27, 2014 at 08:07:01AM -0400, Brian Foster wrote:
> Create a sysfs-fs-xfs ABI documentation file for newly added sysfs
> attributes. This is created under the testing section.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  Documentation/ABI/testing/sysfs-fs-xfs | 39 ++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-fs-xfs
> 
> diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
> new file mode 100644
> index 0000000..b81aa08
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-fs-xfs
> @@ -0,0 +1,39 @@
> +What:		/sys/fs/xfs/<disk>/log/log_head_lsn
> +Date:		June 2014
> +KernelVersion:	3.16

3.17, actually, but I can fix that up.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
