Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 810A37F52
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 00:14:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 607FE8F8049
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 22:14:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	I58hVrfE4r8RDGj9 for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 22:14:52 -0700 (PDT)
Date: Tue, 9 Sep 2014 15:14:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: only writeback and truncate pages for the freed
	range
Message-ID: <20140909051450.GF20518@dastard>
References: <1410092760-3451-1-git-send-email-bfoster@redhat.com>
	<1410092760-3451-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410092760-3451-5-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 08:26:00AM -0400, Brian Foster wrote:
> xfs_free_file_space() only affects the range of the file for which space
> is being freed. It currently writes and truncates the page cache from
> the start offset of the free to EOF.
> 
> Modify xfs_free_file_space() to write back and truncate page cache of
> just the range being freed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
