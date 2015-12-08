Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3EA947F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 14:58:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D00E1AC003
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 12:58:03 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5SqrzT0ZxWtcT3B6 for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 12:58:01 -0800 (PST)
Date: Wed, 9 Dec 2015 07:57:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata corruption detected at xfs_attr3_leaf_write_verify /
	Internal error xfs_attr3_leaf_write_verify
Message-ID: <20151208205759.GE19802@dastard>
References: <5666F521.5060602@3qmedien.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5666F521.5060602@3qmedien.net>
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
To: Dietmar Putz <putz@3qmedien.net>
Cc: xfs@oss.sgi.com

On Tue, Dec 08, 2015 at 04:20:01PM +0100, Dietmar Putz wrote:
> similar reports are existing :
> http://oss.sgi.com/archives/xfs/2015-11/msg00459.html
> https://bugs.launchpad.net/ubuntu/+source/linux-lts-trusty/+bug/1468039

Following a  couple of clicky links in that bug leads to:

http://oss.sgi.com/archives/xfs/2015-06/msg00457.html

in which I comment:

| Probably fixed by commit c88547a ("xfs: fix directory hash ordering
| bug"), which also affected attributes in leaf format.

Hence this was probably fixed in 3.15 and pushed back to 3.13.11i
via th eupstream stable kernel process. I have no idea if the ubuntu
maintainers have added that fix to their kernel...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
