Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 759217F50
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 14:13:02 -0600 (CST)
Message-ID: <51252E4B.4070802@sgi.com>
Date: Wed, 20 Feb 2013 14:12:59 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/3] xfsprogs: sync xfs_calc_buf_res() to user space
References: <51230E28.2020000@oracle.com>
In-Reply-To: <51230E28.2020000@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 02/18/13 23:31, Jeff Liu wrote:
> Sync the new helper xfs_calc_buf_res() to user space.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---


This series has been committed to OSS since they do no overlap the UBER 
patch:

commit 21f4e23356f1723ab67d8cf06f399410cb207af0
Author: Jeff Liu <jeff.liu@oracle.com>
Date:   Tue Feb 19 05:31:29 2013 +0000

     xfsprogs: rename max_attrset_trans_res_adjust to 
max_attrsetm_trans_res_adjust


commit 67910e8b71e773e0a7b9ca3523732aaf29e89f70
Author: Jeff Liu <jeff.liu@oracle.com>
Date:   Tue Feb 19 05:31:25 2013 +0000

     xfsprogs: sync the changes in transaction log space reservations to 
user space


commit 9aa758dee22eb386838ea87ef4c52a36803d4fd9
Author: Jeff Liu <jeff.liu@oracle.com>
Date:   Tue Feb 19 05:31:20 2013 +0000

     xfsprogs: sync xfs_calc_buf_res() to user space

Thanks Jeff,

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
