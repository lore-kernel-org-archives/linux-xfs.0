Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 86A347CA2
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 17:51:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 579E38F8037
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 15:51:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tPPaDse7teuoWInR for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 15:51:48 -0700 (PDT)
Date: Sat, 25 Jun 2016 08:51:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs metadata overhead
Message-ID: <20160624225145.GF12670@dastard>
References: <CAC=x_0jDYb17Vh97Led7XXDiUMcUTJbpJ2Dw45gn=D0_w0K5VQ@mail.gmail.com>
	<20160622225117.GX12670@dastard>
	<CAC=x_0hdvm7SSP8EOAdUwLa-k3a3p7p7CRj8tyCnEx=As7A6jw@mail.gmail.com>
	<71fbc905-ef05-126a-5c7f-c68c9018763c@sandeen.net>
	<CAC=x_0hnGQHAenv985+FusWxK_63AatB_XK_mqbAmyt=OxqYrg@mail.gmail.com>
	<b920a8ec-6410-1daa-809c-04b48db24c0a@sandeen.net>
	<CAC=x_0g_iktOKOKiRF5Ku7N-PSbCXOR+Amhm577YjNYQaRPjeA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC=x_0g_iktOKOKiRF5Ku7N-PSbCXOR+Amhm577YjNYQaRPjeA@mail.gmail.com>
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
To: Danny Shavit <danny@zadarastorage.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 24, 2016 at 04:21:39PM +0300, Danny Shavit wrote:
> I see.
> So using bulk_stat ioctl in similar way to xfs_fsr and summing allocated
> size will result with  more accurate number?

No. du includes *directory blocks* in it's sum. bulkstat only counts
inodes, which is not counted by du and is part of the metadata you
have already accounted for. Even then, bulkstat doesn't give an
accurate account o space used by inodes because they can be sparsely
allocated from within inode chunks.

Just snapshot the volume, run metadump on the snapshot - it's the
fastest, most reliable way to work out how much metadata is in a
filesystem right now...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
