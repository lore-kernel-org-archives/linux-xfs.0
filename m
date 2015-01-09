Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C4357F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 05:42:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B1E9AC006
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 03:42:03 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id JP2Pt8RQEKAob8sD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 03:42:02 -0800 (PST)
Date: Fri, 9 Jan 2015 12:41:59 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/18] xfs: implement pnfs export operations
Message-ID: <20150109114159.GA25728@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-18-git-send-email-hch@lst.de>
	<20150107002434.GG31508@dastard> <20150107104010.GD28783@lst.de>
	<20150107211140.GC25000@dastard> <20150108124327.GA15222@lst.de>
	<20150108210405.GG25000@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108210405.GG25000@dastard>
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

On Fri, Jan 09, 2015 at 08:04:05AM +1100, Dave Chinner wrote:
> > If the client sends the opaqueue device ID that contains the generation
> > after the grow to a server that had crashed / restarted the server
> > will reject it as the server starts at zero.  The causes the client
> > to get a new, valid device ID from the server.
> 
> But if the server fs has a generation number of zero when it
> crashes, how does the client tell that it needs a new device ID from
> the server?
>
> > Unlike the NFS file hadles which are persistent the device IDs are volatile
> > handles that can go away (and have really horrible life time rules..).
> 
> Right. How the clients detect that "going away" when the device
> generation is zero both before and after a server crash is the
> question I'm asking....

The server tells the client by rejecting the operation using the
device ID.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
