Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 101447F4E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 17:19:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E0E898F8040
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 15:19:32 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6qRdyrB0FN6NTtXm for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 15:19:30 -0700 (PDT)
Date: Tue, 7 Oct 2014 09:19:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: return the first match during
	case-insensitive lookup.
Message-ID: <20141006221928.GJ2301@dastard>
References: <20141003214758.GY1865@sgi.com>
 <20141003215542.GD1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003215542.GD1865@sgi.com>
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
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Oct 03, 2014 at 04:55:42PM -0500, Ben Myers wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> Change the XFS case-insensitive lookup code to return the first match
> found, even if it is not an exact match. Whether a filesystem uses
> case-insensitive lookups is determined by a superblock bit set during
> filesystem creation.  This means that normal use cannot create two files
> that both match the same filename.
> 
> Signed-off-by: Olaf Weber <olaf@sgi.com>

This is really dependent on whether we want to support mixed
CI/non-CI filesystems, yes? i.e. if we want to support mixed case
setups, then we need to keep the code as it stands? What is the
downside of keeping the code unchaged and our options open?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
