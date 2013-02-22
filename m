Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BAFF7F50
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 19:41:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A2B08F8033
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 17:41:46 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VQEDKMoDfhVUMPlI for <xfs@oss.sgi.com>;
	Thu, 21 Feb 2013 17:41:44 -0800 (PST)
Date: Fri, 22 Feb 2013 12:41:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/9] xfs: add CRC checks to the AGF
Message-ID: <20130222014143.GO26694@dastard>
References: <1358774760-21841-1-git-send-email-david@fromorbit.com>
	<1358774760-21841-4-git-send-email-david@fromorbit.com>
	<20130221225305.GT22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130221225305.GT22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 21, 2013 at 04:53:05PM -0600, Ben Myers wrote:
> > @@ -83,6 +100,7 @@ typedef struct xfs_agf {
> >  #define	XFS_AGF_FREEBLKS	0x00000200
> >  #define	XFS_AGF_LONGEST		0x00000400
> >  #define	XFS_AGF_BTREEBLKS	0x00000800
> > +#define	XFS_AGF_UUID		0x00001000
> >  #define	XFS_AGF_NUM_BITS	12
> 					13 ?
> You added a 13th bit.

Yup, good catch.

> How do you envision having the uuid in these structures will be helpful?

Same as for all the rest of the metadata. It identifies the
filesystem it belongs to so we can detect and trace misplaced writes
instantly, rather than, say, having to spend months of debugging
with FC analysers to prove the storage array firmware has a bug in
it and that's what is causing the filesystem corruption.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
