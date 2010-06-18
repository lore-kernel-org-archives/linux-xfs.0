Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5I0j126199076 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 19:45:02 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32E29159C2A6
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 17:51:24 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	hnhA1WPkVSSo7Svk for <xfs@oss.sgi.com>;
	Thu, 17 Jun 2010 17:51:24 -0700 (PDT)
Date: Fri, 18 Jun 2010 10:47:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Make fiemap works with sparse file.
Message-ID: <20100618004708.GZ6590@dastard>
References: <20100614122912.GD6590@dastard>
	<1276764799-4837-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1276764799-4837-1-git-send-email-tao.ma@oracle.com>
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
To: Tao Ma <tao.ma@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jun 17, 2010 at 04:53:19PM +0800, Tao Ma wrote:
> Hi Dave,
> On 06/14/2010 08:29 PM, Dave Chinner wrote:
> > I just had a thought - if you want to avoid holes being reported to
> > fiemap, then add a BMV_IF_NO_HOLES flag to xfs_getbmap() and skip
> > holes in the mappin gloop when this flag is set. That will make
> > fiemap fill in the full number of extents without hacking the
> > extent count...
> Here is the updated one. I have used BVM_IF_NO_HOLES in xfs_getbmap
> to skip increasing index 'cur_ext'. It is a bit ugly, see my commit
> log. I guess maybe we can add another flag in xfs_bmapi so that it
> don't even give us the holes?

No need...

> 
> Regards,
> Tao
> 
> From cee1765ffd3e2b003b837666b4620b5107ed9ddd Mon Sep 17 00:00:00 2001
> From: Tao Ma <tao.ma@oracle.com>
> Date: Thu, 17 Jun 2010 16:14:22 +0800
> Subject: [PATCH v3] xfs: Make fiemap works with sparse file.
> 
> In xfs_vn_fiemap, we set bvm_count to fi_extent_max + 1 and want
> to return fi_extent_max extents, but actually it won't work for
> a sparse file. The reason is that in xfs_getbmap we will
> calculate holes and set it in 'out', while out is malloced by
> bmv_count(fi_extent_max+1) which didn't consider holes. So in the
> worst case, if 'out' vector looks like
> [hole, extent, hole, extent, hole, ... hole, extent, hole],
> we will only return half of fi_extent_max extents.
> 
> This patch add a new parameter BMV_IF_NO_HOLES for bvm_iflags.
> So with this flags, we don't use our 'out' in xfs_getbmap for
> a hole. The solution is a bit ugly by just don't increasing
> index of 'out' vector. I felt that it is not easy to skip it
> at the very beginning since we have the complicated check and
> some function like xfs_getbmapx_fix_eof_hole to adjust 'out'.

... because I think we can safely skip xfs_getbmapx_fix_eof_hole()
it only modifies the hole. Hence  just adding a check after the
attribute fork end check (which needs to detect a hole to terminate)
should be fine: e.g something like:

			if (map[i].br_startblock == HOLESTARTBLOCK &&
			    whichfork == XFS_ATTR_FORK) {
				/* came to the end of attribute fork */
				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
				goto out_free_map;
			}
+			if (map[i].br_startblock == HOLESTARTBLOCK &&
+				 (iflags & BMV_IF_NO_HOLES)) {
+				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
+				continue;
+			}

Should work and avoid the worst of the ugliness.

The rest of the patch looks fine.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
