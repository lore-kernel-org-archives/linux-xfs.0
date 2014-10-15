Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A943B7F3F
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 08:05:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4729DAC003
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 06:05:44 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CmsCtdInzVVnRw4j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Oct 2014 06:05:43 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s9FD5fm2029260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 13:05:42 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s9FD5efu017694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 13:05:41 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s9FD5epS002734 for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 13:05:40 GMT
Date: Wed, 15 Oct 2014 16:05:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: xfs: use after free on error in xfs_qm_log_quotaoff()
Message-ID: <20141015130535.GN26918@mwanda>
References: <20140219095305.GA22351@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140219095305.GA22351@elgon.mountain>
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
To: xfs@oss.sgi.com

This bug is still around.

regards,
dan carpenter

On Wed, Feb 19, 2014 at 12:53:05PM +0300, Dan Carpenter wrote:
> Smatch complains here.  I don't think I have reported this one before.
> It feels very familiar but I have grepped my outbox.
> 
> 	fs/xfs/xfs_qm_syscalls.c:814 xfs_qm_log_quotaoff()
> 	warn: 'tp' was already freed.
> 
> fs/xfs/xfs_qm_syscalls.c
>    804          /*
>    805           * We have to make sure that the transaction is secure on disk before we
>    806           * return and actually stop quota accounting. So, make it synchronous.
>    807           * We don't care about quotoff's performance.
>    808           */
>    809          xfs_trans_set_sync(tp);
>    810          error = xfs_trans_commit(tp, 0);
>                         ^^^^^^^^^^^^^^^^
> This function frees tp.
> 
>    811  
>    812  error0:
>    813          if (error) {
>    814                  xfs_trans_cancel(tp, 0);
>                         ^^^^^^^^^^^^^^^^^
> Use after free.
> 
>    815                  /*
>    816                   * No one else is modifying sb_qflags, so this is OK.
>    817                   * We still hold the quotaofflock.
>    818                   */
> 
> regards,
> dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
