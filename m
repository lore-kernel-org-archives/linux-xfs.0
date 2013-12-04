Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 403DC29E12
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 15:52:59 -0600 (CST)
Date: Wed, 4 Dec 2013 15:52:58 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH V2] xfs: simplify xfs_setsize_buftarg callchain; remove
	unused arg
Message-ID: <20131204215258.GY1935@sgi.com>
References: <5283BC4B.9090204@redhat.com>
 <5283E6D9.6070306@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5283E6D9.6070306@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 13, 2013 at 02:53:45PM -0600, Eric Sandeen wrote:
> The "verbose" argument to xfs_setsize_buftarg_flags() has been
> unused since:
> 
> ffe37436 xfs: stop using the page cache to back the buffer cache
> 
> Remove it, and fold the function into xfs_setsize_buftarg()
> now that there's no need for different types of callers.
> 
> Fix inconsistent comment spacing while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
