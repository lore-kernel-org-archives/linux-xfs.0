Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PKjFU0222230 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 14:45:15 -0600
Subject: Re: [PATCH 2/2 V2] xfstests 225: add additional fiemap-tester run
	without sync
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D66D8F2.10501@sandeen.net>
References: <4D66D5DB.5090203@redhat.com>  <4D66D8F2.10501@sandeen.net>
Date: Fri, 25 Feb 2011 14:47:55 -0600
Message-ID: <1298666875.1990.7114.camel@doink>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com, Josef Bacik <jbacik@redhat.com>mailing list <xfs@oss.sgi.com>

On Thu, 2011-02-24 at 16:17 -0600, Eric Sandeen wrote:
> Chris Mason pointed out that some filesystems were not doing
> the right thing on fiemap, in the face of delalloc extents.
> 
> Because test 225 ran with FIEMAP_FLAG_SYNC only, this didn't
> get caught.  Add a runtime option, and run it both ways.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.  Please add a line to document the option
in the usage() function as suggested by Josef before
committing.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
