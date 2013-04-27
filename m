Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CED5129DF8
	for <xfs@oss.sgi.com>; Sat, 27 Apr 2013 15:43:01 -0500 (CDT)
Date: Sat, 27 Apr 2013 15:42:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/22] xfs: metadata CRCs, fourth version
Message-ID: <20130427204258.GI29359@sgi.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Wed, Apr 03, 2013 at 04:11:10PM +1100, Dave Chinner wrote:
> New CRC patchset. Previous versions:
> 
> http://oss.sgi.com/archives/xfs/2013-01/msg00328.html
> http://oss.sgi.com/archives/xfs/2013-02/msg00451.html
> http://oss.sgi.com/archives/xfs/2013-03/msg00291.html
> 
> This version is based on 3.9-rc4 + TOT xfsdev. 3.9-rc5 has loopback
> bugs that make it useless for testing, so I've just kept my tree on
> -rc4.
> 
> New in this patch set:
> 
>         - numerous bug fixes
> 	- cleanups to addresse Bens review comments
> 	- logs entire inode allocation buffers
> 	- reworks the buffer type tracking for log recovery
> 	- fixes the endian issues reported by sparse
> 	- splits out the symlink code rearrangement
> 	- adds support for v5 superblock feature masks
>         - add mount warnings about CRC support being experimental
> 
> Still to do:
> 
>         - Documentation (half written, not in series)
>         - DT_* type fields in the directory entries. This can be
> 	  done with a feature bit if not done in time.
>         - storage of attributes larger than 256 bytes in shortform
>           attribute forks. Same comment about a feature bit.
> 
> The addition of the feature mask support to the superblock added a
> new field to the superblock - a log compatibility feature mask. This
> is to allow new transactions and recovery features to be added and
> prevent kernels that don't understand those features from performing
> log recovery. The idea is that clean logs can be mounted by kernels
> that don't support the new feature if everything else is compatible,
> but if they require log recovery the mount will be aborted. This
> means pure log changes don't require a compat/incompat/rocompat
> feature bit to be set.
> 
> The result of adding this is that all the old CRC enabled
> filesystems will not work with this kernel - the CRC field location
> changed, and that makes the mount fail hard. So a new userspace will
> be needed to test the CRC side of this patchset. (Coming soon!)
> 
> Comments, testing welcome...

I've pulled in this series.  There are still a few outstanding questions
from review.  I'm confident that we can get them sorted in the coming week.

Reviewed-by: Ben Myers <bpm@sgi.com>

Cheers,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
