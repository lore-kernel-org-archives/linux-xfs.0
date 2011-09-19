Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JL2B2I014761 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 16:02:12 -0500
Subject: Re: [PATCH] xfsdump: remove redundant error code mapping
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1314973338-20520-1-git-send-email-wkendall@sgi.com>
References: <1314973338-20520-1-git-send-email-wkendall@sgi.com>
Date: Mon, 19 Sep 2011 16:02:07 -0500
Message-ID: <1316466127.2941.80.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-09-02 at 09:22 -0500, Bill Kendall wrote:
> Currently there is both an exit_strings array and an exit_codestring()
> function for mapping an exit code to a string. They are very similar
> except the latter prefaces every string with "EXIT_" and the former
> uses "SUCCESS" instead of "NORMAL", and cannot handle an invalid exit
> code. exit_codestring() is not currently used in active code (it's for
> multi-stream), so its values can be changed to allow the exit_strings
> array to be removed.

Looks good.  You need to add your signoff on these things, i.e.:
    Signed-off-by: Bill Kendall <wkendall@sgi.com>
We follow the signoff process used in the Linux kernel.  See
sections 12-14 in this document:
https://github.com/torvalds/linux/blob/master/Documentation/SubmittingPatches


Reviewed-by: Alex Elder <aeldre@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
