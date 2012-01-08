Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q080wTcJ147357 for <xfs@oss.sgi.com>; Sat, 7 Jan 2012 18:58:29 -0600
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
	[66.111.4.29]) by cuda.sgi.com with ESMTP id 2nCxBPHYeZWEV26J
	for <xfs@oss.sgi.com>; Sat, 07 Jan 2012 16:58:27 -0800 (PST)
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id BF9E022655
	for <xfs@oss.sgi.com>; Sat,  7 Jan 2012 19:58:25 -0500 (EST)
Date: Sat, 7 Jan 2012 16:58:23 -0800
From: David Brown <davidb@davidb.org>
Subject: Re: [PATCH] xfsdump: use the full 32-bit generation number
Message-ID: <20120108005822.GA32313@davidb.org>
References: <1325880565-20934-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1325880565-20934-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 06, 2012 at 02:09:25PM -0600, Bill Kendall wrote:

>This patch changes xfsdump to use the full 32-bit inode generation number.
>A change to part of the dump format (direnthdr_t) was required, so the
>dump format version has been bumped to 3. xfsdump also required changes to
>its inode-to-generation cache. This map is not persistent though, so no
>compatibility or version changes were required there.

I suspect that this does fix the problem.  Since the fix is in the
dump, not just restore, I guess I'll just have to start with a fresh
level 0 and see if the failure ever happens again upon restore.

Thanks,
David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
