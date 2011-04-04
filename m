Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p34IXbhS180052 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 13:33:37 -0500
Subject: Re: [PATCH V2] xfstests 249: use -F option for xfs_io
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D8A19D4.3080807@redhat.com>
References: <4D8A1795.3080401@redhat.com>  <4D8A19D4.3080807@redhat.com>
Date: Mon, 04 Apr 2011 13:36:00 -0500
Message-ID: <1301942160.2630.62.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-03-23 at 11:03 -0500, Eric Sandeen wrote:
> Test 249 was appearing to pass on ext4, but it wasn't really
> exercising the test due to lack of "-F" in the xfs_io arguments.
> 
> Without -F the files were created (oddly enough); neither pwrite
> nor sendfile were executed, and the diff of the two (empty)
> files passed, resulting in a passed test without testing anything.
> 
> So add the -F, capture the output, and test the result of each
> xfs_io invocation.
> 
> Also, when it fails, the diff output is huge.  Make diff silent,
> but describe the diff failure and exit.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
