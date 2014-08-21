Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 300A97F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 09:20:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F7188F804B
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 07:20:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6Iw9eDBiUwaPm18o for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 07:20:21 -0700 (PDT)
Message-ID: <53F6002A.2080000@sandeen.net>
Date: Thu, 21 Aug 2014 09:20:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: combine xfs_seek_hole & xfs_seek_data
References: <53F55765.6030205@redhat.com> <53F5E822.9010507@oracle.com>
In-Reply-To: <53F5E822.9010507@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/21/14, 7:37 AM, Jeff Liu wrote:
> With the current refactoring, the code logic still looks easy to understand,
> so I personally vote this change.
> 
> BTW, originally I have also tried to implement SEEK_HOLE/DATA in one routine
> in my 1st round of patch which was shown as following. However, I failed to
> make the code looks readable and works correctly at that time.
> 
> http://oss.sgi.com/archives/xfs/2011-11/msg00364.html
> http://oss.sgi.com/archives/xfs/2011-11/msg00395.html
> 
> 
> Cheers,
> -Jeff

Ah, I had forgotten about that!  Good idea! ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
