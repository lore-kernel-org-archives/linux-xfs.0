Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC6EB29DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:16:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E43B8F8037
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 18:16:01 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WHU5TUaIBnCdbfep for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 18:15:55 -0800 (PST)
Date: Thu, 27 Feb 2014 13:15:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: Use defines for CRC offsets in all cases
Message-ID: <20140227021540.GF29907@dastard>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-5-git-send-email-sandeen@redhat.com>
	<530463C6.6050509@oracle.com> <20140220002713.GI4916@dastard>
	<5305CDAE.50004@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5305CDAE.50004@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 05:41:02PM +0800, Jeff Liu wrote:
> 
> On 02/20 2014 08:27 AM, Dave Chinner wrote:
> > On Wed, Feb 19, 2014 at 03:56:54PM +0800, Jeff Liu wrote:
> >> Hi Eric,
> >>
> >> I read the previous comments from Dave about using defines for CRC offsets,
> >> and with a grep search after applying this patch, looks there have another
> >> two places maybe we should switch them to the macros as well:
> >>
> >> fs/xfs/xfs_log.c:
> >> Do we need a log record crc offset macros for offsetof(struct xlog_rec_header, h_crc))?
> >>
> >> xfs_dinode.h:
> >> we added the XFS_DINODE_CRC_OFF, just use it at below routine?
> >>
> >> static inline uint xfs_dinode_size(int version)
> >> {
> >>         if (version == 3)
> >>                 return sizeof(struct xfs_dinode);
> >>         return offsetof(struct xfs_dinode, di_crc);
> >> }
> > 
> > No, that's a different case - it's not being used for determining
> > the offset of a CRC varaible - it's being used to calculate the size
> > of the version 2 inode core. Hence it should remain open coded like
> > because it has a different purpose in life....
> 
> Thanks for the clarification, so we don't need that for the second inode
> case, but the first case is used to determine the log record crc offset
> to generate the crc for record header, shouldn't we make it consistent
> with others?

Probably should. Eric, can you send a separate patch that converts
the log crc fileds to use the same convention?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
