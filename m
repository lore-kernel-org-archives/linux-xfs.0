Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9807E7F4E
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 08:47:16 -0500 (CDT)
Message-ID: <51924081.70809@sgi.com>
Date: Tue, 14 May 2013 08:47:45 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfstests: fix incorrect redirect in generic/233
References: <1367993066-9313-1-git-send-email-david@fromorbit.com>
	<1367993066-9313-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1367993066-9313-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/08/2013 01:04 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> generic/233 attempts to direct output to tee, but instead of using a
> pipe it uses an append operator. Hence it leaves a file named "tee"
> in the root directory of the xfstests execution path. Just direct
> the output to the $seqres.full file rather than trying to tee it
> into the test output as well.
>

This patch has been committed:

commit ef6b44446143e7bea4ef17b4493e23ca1cdb64b2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 14 08:34:44 2013 -0500

     xfstests: fix incorrect redirect in generic/233

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
