Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 072B77F5F
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 10:57:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CFFF5304043
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 08:57:05 -0700 (PDT)
Date: Tue, 13 Aug 2013 08:57:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ***** SUSPECTED SPAM ***** Re: [PATCH 48/49] xfs: Add read-only
	support for dirent filetype field
Message-ID: <20130813155703.GA15435@infradead.org>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
	<51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com> <20130813005024.GS12779@dastard>
	<520A53E8.6030604@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520A53E8.6030604@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 13, 2013 at 10:42:32AM -0500, Mark Tinguely wrote:
> v4 is hardly dead end. Feature bits can keep the filesystem stable.
> 
> v5 superblock is experimental and is not the automatically the
> default and only version.
> 
> Geoffrey has been expressing concerns about v5 and I agree with
> them. We came to the party too late, and despite our concerns, SGI
> has worked hard to get the crc pieces reviewed, tested and
> committed. The concerns are still there.
> 
> Yes, I am serious. v4 is not dead and should get new features where
> appropriate.

It really doesn't make any sense to shoe-horn incompatible on-disk
features into the old format, with all the required work, and especially
the exploding feature matrix.

That beeing said I'd have no problem with SGI adding this support if
they absolutely required it as long as long as not putting the burden
on anyone else.

Trying to reject a new feature because it doen't support the legacy
disk format is just sad and will not pass the test of time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
