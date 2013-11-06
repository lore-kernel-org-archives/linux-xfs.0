Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6EF329E1A
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 10:18:29 -0600 (CST)
Date: Wed, 6 Nov 2013 10:18:25 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfstest failures
Message-ID: <20131106161825.GU1935@sgi.com>
References: <20131106105451.GA31283@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106105451.GA31283@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 02:54:51AM -0800, Christoph Hellwig wrote:
> xfs/296
> 
> 	Checking for capability on restored file
> 	-RESTORE_DIR/DUMP_SUBDIR/testfile cap_setgid,cap_setuid+ep
> 	-# file: RESTORE_DIR/DUMP_SUBDIR/testfile
> 	-security.capability
> 
> 	Seems like theres some issues with file capabilities.

IIRC Eric noticed that this was broken and submitted a test for it.  It would
be great if someone can work on it.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
