Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF8B47F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 12:09:29 -0500 (CDT)
Date: Thu, 20 Jun 2013 12:09:29 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: check on-disk (not incore) btree root size in dfrag.c
Message-ID: <20130620170929.GY20932@sgi.com>
References: <4F7225BA.40200@redhat.com>
 <51C227ED.5010108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C227ED.5010108@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 19, 2013 at 04:51:41PM -0500, Eric Sandeen wrote:
> On 3/27/12 3:40 PM, Eric Sandeen wrote:
> > xfs_swap_extents_check_format() contains checks to make sure that
> > original and the temporary files during defrag are compatible;
> > Gabriel VLASIU ran into a case where xfs_fsr returned EINVAL
> > because the tests found the btree root to be of size 120,
> > while the fork offset was only 104; IOW, they overlapped.
> > 
> > However, this is just due to an error in the
> > xfs_swap_extents_check_format() tests, because it is checking
> > the in-memory btree root size against the on-disk fork offset.
> > We should be checking the on-disk sizes in both cases.
> > 
> > This patch adds a new macro to calculate this size, and uses
> > it in the tests.
> > 
> > With this change, the filesystem image provided by Gabriel
> > allows for proper file degragmentation.
> 
> I think this and the followup patch 2/1 got lost.
>
> Ben, any idea?

Yeah.  Sorry Eric.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
