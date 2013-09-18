Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1C0EF7F50
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 22:13:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ED636304043
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 20:13:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GNGNUl9e3lFA6cpp for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 20:13:08 -0700 (PDT)
Date: Wed, 18 Sep 2013 13:13:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't leak root inode reference
Message-ID: <20130918031302.GM19103@dastard>
References: <20130826204730.GZ7153@sgi.com> <20130826212423.GX6023@dastard>
	<20130827212558.GY5262@sgi.com> <20130827220833.GY6023@dastard>
	<20130910231122.GY1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130910231122.GY1935@sgi.com>
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
Cc: Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Tue, Sep 10, 2013 at 06:11:22PM -0500, Ben Myers wrote:
> Ok.  Lets try this.  ;)
> 
> xfs: remove usage of is_bad_inode
> 
> XFS never calls mark_inode_bad or iget_failed, so it will never see a
> bad inode.  Remove all checks for is_bad_inode because they are
> unnecessary.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
