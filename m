Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 630397CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 18:38:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25ECA304032
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 16:38:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cL4UpHpd6fprQsLl for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2016 16:38:12 -0700 (PDT)
Date: Fri, 5 Aug 2016 09:37:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Programmatically query default XFS Quota ?
Message-ID: <20160804233732.GA16044@dastard>
References: <839565DD1303AC4993B245FFDB34AF78510C9C8F@tur-exch-node1.massey.ac.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <839565DD1303AC4993B245FFDB34AF78510C9C8F@tur-exch-node1.massey.ac.nz>
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
To: "Rynhart, Patrick" <P.Rynhart@massey.ac.nz>
Cc: "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

On Thu, Aug 04, 2016 at 10:48:32PM +0000, Rynhart, Patrick wrote:
> Hi,
> 
> I can set a default quota on a file system as follows:
> 
> xfs_quota -x -c 'limit bsoft=100m bhard=100m -d' /home
> 
> But I'm not sure how to query this - can anyone advise ?

Default quotas are recorded in the limits of ID 0. UID 0/GID 0 are
not actually limited (though we do account their usage) so we store
the default limits for everyone there. IIRC, you should be able to
view the default user quota limits via the "quota -uv 0" command.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
