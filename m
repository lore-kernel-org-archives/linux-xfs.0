Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4EE77F37
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 08:00:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FCC7AC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:00:06 -0700 (PDT)
Received: from shards.monkeyblade.net (shards.monkeyblade.net [149.20.54.216])
	by cuda.sgi.com with ESMTP id J2prpCbmZ6pGzqfF for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:00:04 -0700 (PDT)
Date: Wed, 16 Apr 2014 09:00:02 -0400 (EDT)
Message-Id: <20140416.090002.2186526865564557549.davem@davemloft.net>
Subject: Re: [PATCH 10/19] NET: set PF_FSTRANS while holding sk_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397625226.4222.113.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.96000.stgit@notabene.brown>
	<1397625226.4222.113.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
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
To: eric.dumazet@gmail.com
Cc: linux-nfs@vger.kernel.org, neilb@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 15 Apr 2014 22:13:46 -0700

> For applications handling millions of sockets, this makes a difference.

Indeed, this really is not acceptable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
