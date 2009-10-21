Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9L2H1Uc195585 for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 21:17:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD49811B94D5
	for <xfs@oss.sgi.com>; Tue, 20 Oct 2009 19:18:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id RlBhFiApHusTQLEe for
	<xfs@oss.sgi.com>; Tue, 20 Oct 2009 19:18:34 -0700 (PDT)
Message-ID: <4ADE6F78.5020609@sandeen.net>
Date: Tue, 20 Oct 2009 21:18:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr: XFS_IOC_SWAPEXT failed; & miscellania
References: <4ADD4D9B.9090808@tlinx.org> <4ADE33D5.6080907@sandeen.net>
	<4ADE6ED8.20003@tlinx.org>
In-Reply-To: <4ADE6ED8.20003@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:

> 4) is it possible to configure the xfs_utils with 'readline' and history
> support?  -- allowing re-edit of previous lines and even a restoration
> of one's previous command history on entry?
> 
> At least the readline support would be helpful  given my typing accuracy
> (i.e. re-edit of previous line...though even a history that only lasts
> for the given session, could be useful for repeating commands on multiple
> files...

current upstream has fixed readline support:

d2e43158ae65863df2d5310381ed316f8e6871ce xfsprogs: fix readline/editline 
for xfs_io and xfs_quota


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
