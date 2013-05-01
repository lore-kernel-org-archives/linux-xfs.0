Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CFF07F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 14:43:21 -0500 (CDT)
Date: Wed, 1 May 2013 14:43:20 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Weird message from xfs_repair
Message-ID: <20130501194320.GP29359@sgi.com>
References: <20130501200633.5d24caf5@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130501200633.5d24caf5@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Emmanuel,

On Wed, May 01, 2013 at 08:06:33PM +0200, Emmanuel Florac wrote:
> I've just had to resort to the latest devel version of xfs_repair to
> get back some heavily damaged filesystem (thanks to a failing RAID
> controller), and it ended with the following message:
> 
> cache_purge: shake on cache 0x672030 left 1 nodes!?
> 
> What's this about? I didn't look at the source, but a new run of
> xfs_repair detected nothing. 

xfs_repair/libxfs has caches for xfs_bufs and inodes to speed things up.
cache_purge is trying to flush out all entries from one of those caches.  After
the purge one entry was left unexpectedly, maybe because someone leaked a
reference on it or something.  The message doesn't indicate an on-disk problem,
it's a problem in xfs_repair.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
