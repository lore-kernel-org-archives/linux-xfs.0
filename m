Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F0B77F50
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 05:42:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E1D5AC001
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 03:42:49 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 9F1fjIHIWG2zxHpd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2015 03:42:44 -0800 (PST)
Date: Sun, 11 Jan 2015 12:42:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/18] nfsd: factor out a helper to decode nfstime4 values
Message-ID: <20150111114242.GA11939@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-4-git-send-email-hch@lst.de>
	<20150109230202.GB107259@kitty>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150109230202.GB107259@kitty>
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
To: Tom Haynes <thomas.haynes@primarydata.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, Jan 09, 2015 at 03:02:02PM -0800, Tom Haynes wrote:
> >  	DECODE_HEAD;
> > @@ -358,15 +373,10 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
> >  		dummy32 = be32_to_cpup(p++);
> >  		switch (dummy32) {
> >  		case NFS4_SET_TO_CLIENT_TIME:
> > -			/* We require the high 32 bits of 'seconds' to be 0, and we ignore
> > -			   all 32 bits of 'nseconds'. */
> 
> Have you done away with these requirements?

No, the comment just go lost, I'll add it bacl.

> 
> > -			READ_BUF(12);
> >  			len += 12;
> 
> I think this code makes it clear that the magic number 12 is the
> same on both lines. With the change, that gets lost.
> 
> Do I think that the 12 will ever change? No.
> 
> Do I think this becomes more "magic"? Yes.

Sure. but the whole counting the number to be decoded in setattr
is magic to start with.  I guess we could replace it with some magic
pointer arithmetic on argp->p, but is that really worth it?  Should
be a separate patch for sure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
