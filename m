Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QEMhvk041163 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 09:22:43 -0500
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.10]) by
	cuda.sgi.com with ESMTP id rNcpBh4wFGEXxgUU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 07:22:41 -0700 (PDT)
Date: Thu, 26 Jul 2012 14:21:13 -0300 (BRT)
Message-Id: <20120726.142113.1715646982657866527.pcacjr@zytor.com>
Subject: Re: [PATCH 07/10] xfstests: always us test option when checking
	large scratch device
From: Paulo Alcantara <pcacjr@zytor.com>
In-Reply-To: <1343291989-14987-8-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
	<1343291989-14987-8-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Hi Dave,

From: Dave Chinner <david@fromorbit.com>
Date: Thu, 26 Jul 2012 18:39:46 +1000

> From: Dave Chinner <dchinner@redhat.com>
> 
> Some tests call _check_scratch_device directly and when using a
> large filesystem this needs to run with a -t option to avoid
> consuming large amounts of memory. Make this happen in all cases
> that the scratch device is checked.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  017       |    7 ++-----
>  common.rc |    2 ++
>  2 files changed, 4 insertions(+), 5 deletions(-)

I guess you meant "xfstests: always use test option..." instead in commit
message.


		Paulo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
