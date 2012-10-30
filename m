Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UJfoBY068228 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 14:41:50 -0500
Date: Tue, 30 Oct 2012 14:43:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: report projid32bit feature in geometry call
Message-ID: <20121030194337.GC405@sgi.com>
References: <507476F1.3080503@redhat.com>
 <50760C80.3030105@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50760C80.3030105@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 10, 2012 at 07:02:08PM -0500, Eric Sandeen wrote:
> On 10/9/12 2:11 PM, Eric Sandeen wrote:
> > When xfs gained the projid32bit feature, it was never added to
> > the FSGEOMETRY ioctl feature flags, so it's not queryable without
> > this patch.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> SGI, can you please add a :
> 
> Cc: stable@vger.kernel.org
> 
> when this is committed?  New stuff will be depending on this and it'd be good to get it munged into stable kernels as well.

Yep.  Will do so.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
