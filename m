Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8PFRAW7069649 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 10:27:10 -0500
Date: Tue, 25 Sep 2012 10:28:27 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: add _require_freeze and minor cleanups
Message-ID: <20120925152827.GI1140@sgi.com>
References: <505A4D04.2080105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <505A4D04.2080105@redhat.com>
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

On Wed, Sep 19, 2012 at 05:53:56PM -0500, Eric Sandeen wrote:
> More filesystems have grown freeze capability, so rather than
> hardcoding several in _supported_fs, make tests 068 and 280
> generic and then add a new _require_freeze() which checks whether
> the fs under test can be frozen before beginning the test.
> 
> Minor other cleanups to 280:
> - remove extra _supported_fs line
> - clear $seq.full before beginning
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

committed to git://oss.sgi.com/xfs/cmds/xfstests.git, master branch.

Christoph, sorry I missed your reviewed-by.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
