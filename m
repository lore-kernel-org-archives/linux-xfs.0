Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A5E07CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 10:42:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19107304043
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 08:42:43 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MkyivxGRnqd2eAh7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 08:42:41 -0800 (PST)
Date: Wed, 2 Mar 2016 08:42:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: falloc vs reflink revisited
Message-ID: <20160302164215.GB20109@birch.djwong.org>
References: <20160302155007.GB7125@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302155007.GB7125@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Mar 02, 2016 at 07:50:07AM -0800, Christoph Hellwig wrote:
> Hi Darrick,
> 
> I know that I suggested unsharing blocks on fallocate, but it turns out
> this is causing problems.  Applications expect falloc to be a fast
> metadata operation, and copying a potentially large number of blocks
> is against that expextation.  This is especially bad for the NFS
> server, which should not be blocked for a long time in a synchronous
> operation.
> 
> I think we'll have to remove the unshare and just fail the fallocate
> for a reflinked region for now.  I still think it makes sense to expose
> an unshare operation, and we probably should make that anyother
> fallocate mode.
> 
> Opininions?

Back in the day I had a new FALLOC_FL_FUNSHARE_RANGE flag to force-cow
a bunch of file blocks.  I don't mind reintroducing it.

Just think of all the fun we can share! :P

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
