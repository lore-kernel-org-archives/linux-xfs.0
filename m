Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FE4E7F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 18:07:16 -0500 (CDT)
Date: Wed, 24 Jul 2013 18:07:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: make the scratch device for generic/256
	slightly larger
Message-ID: <20130724230712.GV3111@sgi.com>
References: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 02, 2013 at 03:17:18PM -0400, Josef Bacik wrote:
> This is similar to a previous fix I sent.  1 gig makes us do mixed file block
> groups for btrfs, so these enospc tests will usually fail because we don't have
> space for metadata, which is the case for this test.  So jack the size up to
> 1.5gig so that btrfs can do its normal thing and pass the test.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Looks fine to me.  

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
