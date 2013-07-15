Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D7C07F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 19:07:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BB8F304043
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 17:07:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jHr171wpxcaEyxQk for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 17:07:54 -0700 (PDT)
Date: Mon, 15 Jul 2013 10:07:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem triggering assert in _repair 3.1.11
Message-ID: <20130715000748.GD5228@dastard>
References: <51E2C912.8080305@sandeen.net>
	<11307192.1374.1373818461931.JavaMail.root@benjamin.baylink.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <11307192.1374.1373818461931.JavaMail.root@benjamin.baylink.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 14, 2013 at 12:14:21PM -0400, Jay Ashworth wrote:
> > looking at bmap btree block 107963248 might also be interesting; like
> > this I think but I'm rusty:
> > 
> > xfs_db> fsblock 107963248
> > xfs_db> type bmapbt
> 
> Well, the manpage says that's a type, but my xfs_db, v 3.1.11, says it's not.  Huh?

bmapbtd. "d" mens data fork. bmapbta is for the attribute fork....

> I hate power supplies.

I'd be spending a few dollars to get a new one ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
