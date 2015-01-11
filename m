Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE7417F50
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 17:53:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD53D8F8035
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 15:53:49 -0800 (PST)
Received: from mail-yh0-f45.google.com (mail-yh0-f45.google.com
	[209.85.213.45]) by cuda.sgi.com with ESMTP id EqDpHDS6lCanbAe1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Jan 2015 15:53:48 -0800 (PST)
Received: by mail-yh0-f45.google.com with SMTP id f10so8376915yha.4
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 15:53:48 -0800 (PST)
Date: Sun, 11 Jan 2015 18:53:44 -0500
From: Tom Haynes <thomas.haynes@primarydata.com>
Subject: Re: [PATCH 03/18] nfsd: factor out a helper to decode nfstime4 values
Message-ID: <20150111235344.GA11746@slacker.internal.excfb.com>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-4-git-send-email-hch@lst.de>
	<20150109230202.GB107259@kitty> <20150111114242.GA11939@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150111114242.GA11939@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Sun, Jan 11, 2015 at 12:42:42PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 09, 2015 at 03:02:02PM -0800, Tom Haynes wrote:
> > 
> > > -			READ_BUF(12);
> > >  			len += 12;
> > 
> > I think this code makes it clear that the magic number 12 is the
> > same on both lines. With the change, that gets lost.
> > 
> > Do I think that the 12 will ever change? No.
> > 
> > Do I think this becomes more "magic"? Yes.
> 
> Sure. but the whole counting the number to be decoded in setattr
> is magic to start with.  

Agreed.

> I guess we could replace it with some magic
> pointer arithmetic on argp->p, but is that really worth it?  

Which is why I asked the leading questions. I see both sides,
but ultimately it is a nit considering the rest of the abuse.

I'm fine with you deciding it is still magic overall.

> Should
> be a separate patch for sure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
