Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 567D07F4E
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 09:38:17 -0500 (CDT)
Message-ID: <51CC4E57.1050305@sgi.com>
Date: Thu, 27 Jun 2013 09:38:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 14/15] xfs: dquot log reservations are too small
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1372313099-8121-15-git-send-email-david@fromorbit.com>
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

On 06/27/13 01:04, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> During review of the separate project quota inode patches, it bcame
> obvious that the dquot log reservation calculation underestimated
> the number dquots that can be modified in a transaction. This has
> it's roots way back in the Irix quota implementation.
>
> That is, when quotas were first implemented in XFS, it only
> supported user and project quotas as Irix did not have group quotas.
> Hence the worst case operation involving dquot modification was
> calculated to involve 2 user dquots and 1 project dquot or 1 user
> dequot and 2 project dquots. i.e. 3 dquots. This was determined back
> in 1996, and has remained unchanged ever since.
>
> However, back in 2001, the Linux XFS port dropped all support for
> project quota and implmented group quotas over the top. This was
> effectively done with a search-and-replace of project with group,
> and as such the log reservation was not changed. However, with the
> advent of group quotas, chmod and rename now could modify more than
> 3 dquots in a single transaction - both could modify 4 dquots. Hence
> this log reservation has been wrong for a long time.
>
> In 2005, project quotas were reintroduced into Linux, but they were
> implemented to be mutually exclusive to group quotas, and so this
> didn't add any new changes to the dquot log reservation. hence when
> project quotas were in use, everything was still fine, just like
> in the Irix days.
>
> Now, with the addition of the separate project quota inode, group
> and project quotas are no longer mutually exclusive, and hence
> operations can now modify three dquots per inode where previously it
> was only two. The worst case here is the rename transaction, which
> can allocate/free space on two different directory inodes, and if
> they have different uid/gid/prid configurations and are world
> writeable, then rename can actually modify 6 different dquots now.
>
> Further, the dquot log reservation doesn't take into account the
> space used by the dquot log format structure that preceeds the dquot
> that is logged, and hence further underestimates the worst case
> log space required by dquots during a transaction.
>
> Hence the worst case log reservation needs to be increased from 3 to
> 6, and it needs to take into account a log format header for each of
> those dquots.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
