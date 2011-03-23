Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NMlgVH120318 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 17:47:47 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 11EEA140FBEA
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 15:50:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	q7PAgmuRRDpYVCNK for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2011 15:50:31 -0700 (PDT)
Date: Thu, 24 Mar 2011 09:50:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests 249: use -F option for xfs_io
Message-ID: <20110323225029.GF26611@dastard>
References: <4D8A1795.3080401@redhat.com>
 <4D8A19D4.3080807@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D8A19D4.3080807@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 23, 2011 at 11:03:32AM -0500, Eric Sandeen wrote:
> Test 249 was appearing to pass on ext4, but it wasn't really
> exercising the test due to lack of "-F" in the xfs_io arguments.
> 
> Without -F the files were created (oddly enough); neither pwrite
> nor sendfile were executed, and the diff of the two (empty)
> files passed, resulting in a passed test without testing anything.
> 
> So add the -F, capture the output, and test the result of each
> xfs_io invocation.

Ok.

> Also, when it fails, the diff output is huge.  Make diff silent,
> but describe the diff failure and exit.

Excellent - I was going to suggest this myself given you were
touching this test.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
