Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E328429E0E
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 08:24:33 -0500 (CDT)
Message-ID: <518A5213.60307@sgi.com>
Date: Wed, 08 May 2013 08:24:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
References: <20130507190731.GA15528@redhat.com> <518954DE.4070803@sgi.com>
	<20130507193146.GA7539@redhat.com> <51895CD7.7040806@sgi.com>
	<20130507195954.GA8384@redhat.com> <51895E51.2050508@sgi.com>
	<20130507202217.GA9883@redhat.com> <518962FC.2060509@sgi.com>
	<20130507222256.GD24635@dastard> <51898400.8000900@sgi.com>
	<20130507235458.GG24635@dastard>
In-Reply-To: <20130507235458.GG24635@dastard>
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
Cc: Dave Jones <davej@redhat.com>, CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com

On 05/07/13 18:54, Dave Chinner wrote:


Checking the EFI for whether it is being released from recovery
after we've already released the known active reference is a mistake
worthy of a brown paper bag. Fix the (now) obvious use after free
that it can cause.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
  fs/xfs/xfs_extfree_item.c |   14 +++++++++++++-
  1 file changed, 13 insertions(+), 1 deletion(-)

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
