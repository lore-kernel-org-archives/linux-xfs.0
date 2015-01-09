Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE2A57F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 11:16:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDC7F304053
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 09:16:47 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id lD1CjNR0WZJyqon2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 09:16:46 -0800 (PST)
Date: Fri, 9 Jan 2015 18:16:41 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/18] nfsd: implement pNFS operations
Message-ID: <20150109171641.GA17464@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-10-git-send-email-hch@lst.de>
	<20150108164851.03b64e16@synchrony.poochiereds.net>
	<20150109100551.GA23173@lst.de>
	<20150109085130.0f862d24@synchrony.poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150109085130.0f862d24@synchrony.poochiereds.net>
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
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, Sachin Bhamare <sachin.bhamare@primarydata.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, thomas.haynes@primarydata.com

On Fri, Jan 09, 2015 at 08:51:30AM -0800, Jeff Layton wrote:
> Ok, it'd be good to document that in some comments then for the sake of
> posterity (maybe it is later in the set -- I haven't gotten to the end
> yet).

What kinds of comments do you expect?  Not implementing unused features
of a protocol should be the default for anything in Linux.

> Now, that said...I think that your ROC semantics are wrong here. You
> also have to take delegations into account. [1]
> 
> Basically the semantics that you want are that nfsd should do all of
> the ROC stuff on last close iff there are no outstanding delegations or
> on delegreturn iff there are no opens.
> 
> What we ended up doing in the unreleased code we have was to create a
> new per-client and per-file object (that we creatively called an
> "odstate"). An open stateid and a delegation stateid would hold a
> reference to this object which is put when those stateids are freed.
> When its refcount goes to zero, then we'd free any outstanding layouts
> on the file for that client and free the object.
> 
> You probably want to do something similar here.
> 
> [1]: Tom and Trond mentioned that there's a RFC5661 errata pending for
>      this, but I don't see it right offhand.

It would be good to look at the errata.  While the idea of keeping
layouts around longer makes sense, I would only expect to do this
if they layout state was created based on a delegation stateid, not
a lock or open stateid.  In that case having the layouts hang off
the "parent" stateid might be another option.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
