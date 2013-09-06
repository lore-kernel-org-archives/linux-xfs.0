Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F2E47F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 20:30:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D6558F8033
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 18:30:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AhdF8dAJMOwAR9Re for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 18:30:40 -0700 (PDT)
Date: Fri, 6 Sep 2013 11:30:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] xfs: Allow user to change project id in un-init userns
Message-ID: <20130906013033.GB23571@dastard>
References: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
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
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: bfoster@redhat.com, dwight.engen@oracle.com, ebiederm@xmission.com, xfs@oss.sgi.com

On Wed, Sep 04, 2013 at 02:38:33PM +0800, Gao feng wrote:
> This patchset add two helper functions to convert user space project id
> to kernel space project id without any struct changed.
> 
> Since the projid_map of user namespace has limit the range of valid project
> ids for user namespace, we can safely allow user to change file's project
> id in un-init user namespace.

This doesn't address any of the concerns about whether access to
project IDs are valid in a user namaspacee environment.

Project IDs are not the same as UIDs and GIDs. They got included in
all the mapping stuff because of the fact that they are used for
quotas, but the fact is that they are not a property owned by a user
or a group or control access.

IOWs, project IDs are an *accounting* construct rather than an
*access control mechanism* If project IDs are being used by the
system administrators for accounting the space used by a *mount
namespace* container, then they must not be modifiable by a user
in a user namespace.

This is a fundamentally different use case from UID/GID mapping,
because there is no possible competing access for on-disk uid/gid
fields possible from the initns like there is for project quotas.
IOWs, project quota IDs are not owned by a namespace, and so mapping
them like we do for UID/GID is not clearly the right solution for
everyone.

So, there's a bigger policy issue here that needs to be decided
first. i.e. whether project quotas and therefore project IDs should
be accessible to users inside a user namespace.

If we decide to make it optional so that a system administrator can
chose whether project IDs are to be mapped via the userns mapping
infrastructure, then we need some kind of infrastructure to support
and enforce that first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
