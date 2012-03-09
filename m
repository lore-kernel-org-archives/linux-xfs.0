Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29LqoCb044214 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 15:52:50 -0600
Date: Fri, 9 Mar 2012 15:52:56 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfsprogs: pick up 4k physical sector size
Message-ID: <20120309215256.GC7762@sgi.com>
References: <4F500690.2080804@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F500690.2080804@redhat.com>
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

On Thu, Mar 01, 2012 at 05:30:24PM -0600, Eric Sandeen wrote:
> This splits the fs topology sectorsize into logical & physical,
> and gets both via blkid_get_topology.
> 
> After that there are various gyrations & warnings to handle
> various combinations of specified sector, blocksize, and
> what's actually found on disk.
> 
> mkfs.xfs's "sector size" gets reduced to logical if
> a block size < physical sector size is specified, for
> example.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I'm a bit late to the party, but I took a look at this anyway.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
