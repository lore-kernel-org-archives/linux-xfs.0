Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8093D7FBE
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 23:13:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C823AC007
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 21:13:27 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	eCsE80CKyjjybP3i for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 21:13:26 -0700 (PDT)
Date: Fri, 15 Mar 2013 15:13:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests: test writing to device node on an RO
	filesystem
Message-ID: <20130315041324.GI21651@dastard>
References: <514243C0.1000309@redhat.com>
 <5142896E.9060609@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5142896E.9060609@sandeen.net>
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

On Thu, Mar 14, 2013 at 09:37:34PM -0500, Eric Sandeen wrote:
> We should be able to open device nodes for writing even
> if they live on a readonly filesytem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

looks ok except for one thing - it should be part of the quick
group....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
