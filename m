Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C85C47F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 15:38:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6FC31AC008
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 13:38:32 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uLwZejZhkRqxG4zP for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 13:38:29 -0800 (PST)
Date: Thu, 22 Jan 2015 08:38:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/17 v3] quota: Unify VFS and XFS quota interfaces
Message-ID: <20150121213826.GL16510@dastard>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Fri, Jan 16, 2015 at 01:47:34PM +0100, Jan Kara wrote:
>   Hello,
> 
>   this is another iteration of patches to unify VFS and XFS quota interfaces so
> that XFS quotactls work for filesystems with VFS quotas and vice versa.  This
> is useful so that userspace doesn't have to care that much about which
> filesystem it is using at least when using basic quota functionality. In
> particular we should be able to reuse project quota tests in xfstests for ext4.
> 
> The patches are based on quota cleanup series [1] and XFS cleanup series [2]
> I've sent previously and based on 3.19-rc4 + for-next branch of XFS tree.  I
> could further split this series into per-quotactl series but frankly I don't
> think it will help reviewers in any way (the patches in the current series are
> already ordered by quotactl).

Hi Jan,

Do you have a this series in a git tree somewhere so it's easy to
merge and test?

> All the comments to the first version of the series are hopefully addressed,
> except for Dave's request to reduce number of copying of dquot information -
> I have benchmarked that reducing number of copies from 3 to 2 brings just 2%
> improvement in speed in my test setup and getting quota information isn't IMHO
> so performance critical that it would be worth the complications of the code.

I think the numbers address my concern adequately ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
