Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB9937F77
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 15:42:29 -0500 (CDT)
Message-ID: <520A9A2F.5090009@sgi.com>
Date: Tue, 13 Aug 2013 15:42:23 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Abhijith Das <adas@redhat.com>, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

Hey Chandra,

Nice addition to quotas.  Just a couple of comments.

On 08/06/2013 05:27 PM, Chandra Seetharaman wrote:

. . .
>
> +/*
> + * fs_quota_statv is the used by Q_XGETQSTATV for a given file system. It
Remove extra word       ^^^^

> + * provides a centralized way to get meta information about the quota
> + * subsystem. eg. space taken up for user, group, and project quotas, number
> + * of dquots currently incore.
> + *
> + * This version has proper versioning support with appropriate padding for
> + * future expansions, and ability to expand for future without creating any
> + * backwward compatibility issues.
backward is misspelled (extra w)

> + *
> + * For Q_XGETQSTATV, user space caller need to specify fs_quota_statv.qs_version
> + * to the version of data they are interested in. Kernel will fill the data
> + * fields relevant to that version.
> + *
> + * If kernel does not support user space caller specified version, EINVAL will
> + * be returned. User space caller can then reduce the version number and retry
> + * the same command.
> + */
This was a little difficult to follow, suggest rewording a little, 
something like:

Q_XGETQSTATV uses the passed in value of the requested version via
fs_quota_statv.qs_version to determine the return data layout of 
fs_quota_statv.


It would be nice to get this information documented in the quotactl(2)
manpage similar to Q_XGETQSTAT.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
