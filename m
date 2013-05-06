Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C175829DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 04:27:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE17330405F
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 02:27:35 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id VC5oAZYw9NXXQ8dN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 02:27:34 -0700 (PDT)
Message-ID: <5187777D.7010802@oracle.com>
Date: Mon, 06 May 2013 17:27:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: xfs: add buffer types to directory and attribute buffers
References: <20130506091116.GA2129@elgon.mountain>
In-Reply-To: <20130506091116.GA2129@elgon.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: xfs@oss.sgi.com, dchinner@redhat.com

On 05/06/2013 05:11 PM, Dan Carpenter wrote:
> Hello Dave Chinner,
> 
> The patch d75afeb3d302: "xfs: add buffer types to directory and 
> attribute buffers" from Apr 3, 2013, leads to the following Smatch warning:
> "fs/xfs/xfs_log_recover.c:2042 xlog_recovery_validate_buf_type()
> 	 warn: always true condition '(magicda != 1480675917) =>  (0-u16max != 1480675917)'"
> 
> fs/xfs/xfs_log_recover.c
>   2039          case XFS_BLFT_ATTR_RMT_BUF:
>   2040                  if (!xfs_sb_version_hascrc(&mp->m_sb))
>   2041                          break;
>   2042                  if (magicda != XFS_ATTR3_RMT_MAGIC) {
>                             ^^^^^^^
> This is an unsigned short so it can never be equal to 0x5841524d.  Was
> "magic32" intended here?
You are right, but this issue has been fixed by:

commit cab09a81fbefcb21db5213a84461d421946f6eb8
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Apr 30 21:39:36 2013 +1000

    xfs: fix da node magic number mismatches

It has been discussed on following thread before:
http://oss.sgi.com/archives/xfs/2013-04/msg00645.html

Thanks,
-Jeff
> 
>   2043                          xfs_warn(mp, "Bad attr remote magic!");
>   2044                          ASSERT(0);
>   2045                          break;
>   2046                  }
>   2047                  bp->b_ops = &xfs_attr3_rmt_buf_ops;
>   2048                  break;
> 
> regards,
> dan carpenter
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
