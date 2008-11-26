Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ1BggJ024482 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:11:42 -0600
Message-ID: <492CA245.3000709@sgi.com>
Date: Wed, 26 Nov 2008 12:11:33 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125140553.GA16553@infradead.org>
In-Reply-To: <20081125140553.GA16553@infradead.org>
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Looking over the -dev tree, can you please revert
> 
> 	http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=c79ae33eebac1c15aa435fb77362fdc5eff2be4d
> 
> All this wasn't needed in the old ptrace tree either, no need to carry it forward.

Is this code needed for the BSD port?

There may be other code that can be removed too.  We moved a lot of the code
that existed only in ptools into the xfs-dev branch so that branch and ptools
are in sync.  This allows us to automatically merge changes back to the old
ptools tree (yes it still lives).  Any merge failures will now be handled
between git branches and not between different scms.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
