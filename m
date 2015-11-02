Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5FCA29DF5
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 13:53:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 49A658F8033
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 11:53:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HuVVsQFokrKBeHMA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2015 11:52:59 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2 0/5] xfs: SGI ACL Fixes
Date: Mon,  2 Nov 2015 20:52:52 +0100
Message-Id: <1446493974-24669-1-git-send-email-agruenba@redhat.com>
References: <1446217508-22157-1-git-send-email-agruenba@redhat.com>
	<20151102025352.GY19199@dastard>
In-Reply-To: <20151102025352.GY19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com

On Mon, Nov 2, 2015 at 3:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> Ok, I've taken these two patches for the upcoming merge window as
> they fix bugs, but I've taken Brian's cached ACL invalidation patch
> instead [...]

Then you'll also need these two patches.

Andreas

Andreas Gruenbacher (2):
  xfs: Fixes to "invalidate cached acl if set directly via xattr"
  xfs: invalidate cached acl if set via ioctl

 fs/xfs/xfs_acl.h   |  3 +++
 fs/xfs/xfs_ioctl.c | 10 +++++++++-
 fs/xfs/xfs_xattr.c | 36 ++++++++++++++++++++++++------------
 3 files changed, 36 insertions(+), 13 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
