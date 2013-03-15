Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59CE48025
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 09:57:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 389908F804B
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 07:57:11 -0700 (PDT)
Received: from mout.web.de (mout.web.de [212.227.17.12]) by cuda.sgi.com with
	ESMTP id yCRgMhQWgjS2Py0a for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 07:57:10 -0700 (PDT)
Date: Fri, 15 Mar 2013 15:57:01 +0100
From: Julian Wollrath <jwollrath@web.de>
Subject: Re: Null pointer dereference and following traces on 3.9-rc1
Message-ID: <20130315155701.1423fb02@ilfaris>
In-Reply-To: <20130310225600.GL23616@dastard>
References: <20130310154900.673deee0@ilfaris> <20130310225600.GL23616@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> If you can reproduce this, please run an event trace  gathering
> the xfs_swap_extent* trace points while xfs_fsr is running so I can
> determine if/why the swap extents code is corrupting inodes.
> 
> # trace-cmd record -e xfs_swap_extents\* xfs_fsr .....
> <crash>
> <kill xfs_fsr>
> # trace-cmd report > trace_report.txt
So fare I was not able to reproduce it but when I am able to reproduce
it, I will send you an event trace.


Best regards,
Julian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
