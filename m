Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5EA27CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 08:28:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E555AC005
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 06:28:04 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8gvTRTkguPpFLzJD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 06:28:03 -0700 (PDT)
Date: Fri, 24 Jun 2016 16:27:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] xfs: don't allow negative error tags
Message-ID: <20160624132749.GP32247@mwanda>
References: <20160624122234.GA23169@mwanda>
 <576D31B9.8010908@easystack.cn>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <576D31B9.8010908@easystack.cn>
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
To: Jeff Liu <jeff.liu@easystack.cn>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 24, 2016 at 09:12:25PM +0800, Jeff Liu wrote:
> Hi Dan,
> 
> xfs_errortag_add() is called by xfs_file_ioctl(), which accept the 1st
> argument as signed, i.e,
> 
> typedef struct xfs_error_injection {
> __s32 fd;
> __s32 errtag;
> } xfs_error_injection_t;
> 
> Should we make it happy as well? Also, the typedef can be converted to
> to struct xfs_error_injection by removing the depreciated
> xfs_error_injection_t
> syntax if so.

That has been the user interface for a while so I didn't want to change
it.

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
