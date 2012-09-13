Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DIVs2Y199335 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 13:31:54 -0500
Message-ID: <505226CF.2030608@sgi.com>
Date: Thu, 13 Sep 2012 13:32:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC, PATCH 0/102]: xfs: 3.0.x stable kernel update
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/23/12 00:01, Dave Chinner wrote:

> For all the XFS developers that have copious amounts of free time
> available, I'd appreciate an eye run over the patch list to see if
> there's any potential bug fixes that I missed or have made glaring
> errors in backporting. Some of the fixes are dependent on cleanups I
> haven't included, so some of the patches are a bit different to what
> is in mainline (e.g. anything that touches setattr). Most important
> to look at is probably the inode i_size changes and the logging of
> all metadata changes.


I think Brian Foster's log hang patch would be a good candidate:
xfs: check for stale inode before acquiring iflock on push
http://oss.sgi.com/archives/xfs/2012-06/msg00134.html

This hang can happen in Linux 2.6.x version of XFS.

Thanks for the work.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
