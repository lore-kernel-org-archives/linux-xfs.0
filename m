Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E72A7CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:15:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 514ED8F8049
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 16:15:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QVibKIjqcXDpOD4g for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 16:15:25 -0700 (PDT)
Date: Wed, 31 Jul 2013 09:15:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 5/7] xfs: create internal eofblocks structure with
	kuid_t types
Message-ID: <20130730231512.GN13468@dastard>
References: <20130729230700.6d07bf73@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130729230700.6d07bf73@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 29, 2013 at 11:07:00PM -0400, Dwight Engen wrote:
> Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
> Update internal filter matching to compare ids with kuid_t types.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
