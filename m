Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B34517F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 06:43:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A16C08F8035
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 04:43:32 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id X586XCphym9wrR0c (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 04:43:30 -0800 (PST)
Date: Thu, 8 Jan 2015 13:43:27 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/18] xfs: implement pnfs export operations
Message-ID: <20150108124327.GA15222@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-18-git-send-email-hch@lst.de>
	<20150107002434.GG31508@dastard> <20150107104010.GD28783@lst.de>
	<20150107211140.GC25000@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150107211140.GC25000@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Thu, Jan 08, 2015 at 08:11:40AM +1100, Dave Chinner wrote:
> So what happens if a grow occurs, then the server crashes, and the
> client on reboot sees the same generation as before the grow
> occured?

The client doesn't really see the generation.  It's party of the deviceid,
which is opaqueue to the client.

If the client sends the opaqueue device ID that contains the generation
after the grow to a server that had crashed / restarted the server
will reject it as the server starts at zero.  The causes the client
to get a new, valid device ID from the server.

Unlike the NFS file hadles which are persistent the device IDs are volatile
handles that can go away (and have really horrible life time rules..).

> > Every block allocation from a pNFS client goes through this path, so
> > yes it is performance critical.
> 
> Sure, but how many allocations per second are we expecting to have
> to support? We can do tens of thousands of synchronous transactions
> per second on luns with non-volatile write caches, so I'm really
> wondering how much of a limitation this is going to be in the real
> world. Do you have any numbers?

I don't have numbers right now without running specific benchmarks,
but the rate will be about the same as for local XFS use on the same
workload.

> 
> > > So whenever the server first starts up the generation number in a
> > > map is going to be zero - what purpose does this actually serve?
> > 
> > So that we can communicate if a device was grown to the client, which
> > in this case needs to re-read the device information.
> 
> Why does it need to reread the device information? the layouts that
> are handled to it are still going to be valid from the server POV...

The existing layouts are still valid.  But any new layout can reference the
added size, so any new layout needs to point to the new device ID.

Once the client sees the new device ID it needs to get the information for
it, which causes it to re-read the device information.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
