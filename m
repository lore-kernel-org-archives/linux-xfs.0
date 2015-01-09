Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B12E97F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 10:51:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 806B98F8040
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 08:51:36 -0800 (PST)
Received: from mail-qa0-f51.google.com (mail-qa0-f51.google.com
	[209.85.216.51]) by cuda.sgi.com with ESMTP id Ebuj4DIL03gTpypG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2015 08:51:35 -0800 (PST)
Received: by mail-qa0-f51.google.com with SMTP id i13so7750214qae.10
	for <xfs@oss.sgi.com>; Fri, 09 Jan 2015 08:51:34 -0800 (PST)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Fri, 9 Jan 2015 08:51:30 -0800
Subject: Re: [PATCH 09/18] nfsd: implement pNFS operations
Message-ID: <20150109085130.0f862d24@synchrony.poochiereds.net>
In-Reply-To: <20150109100551.GA23173@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-10-git-send-email-hch@lst.de>
	<20150108164851.03b64e16@synchrony.poochiereds.net>
	<20150109100551.GA23173@lst.de>
MIME-Version: 1.0
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
Cc: linux-nfs@vger.kernel.org, trond.myklebust@primarydata.com, Sachin Bhamare <sachin.bhamare@primarydata.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, thomas.haynes@primarydata.com, Jeff Layton <jeff.layton@primarydata.com>

On Fri, 9 Jan 2015 11:05:51 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jan 08, 2015 at 04:48:51PM -0800, Jeff Layton wrote:
> > > +	nfsd4_return_all_file_layouts(stp->st_stateowner->so_client,
> > > +				      stp->st_stid.sc_file);
> > > +
> > 
> > Shouldn't the above be conditional on whether the lg_roc was true?
> 
> There is no support for non-lg_roc layouts at the moment.
> 
> In general I've avoided adding code that isn't used, as they can't
> be tested and thus most likely won't work.

Ok, it'd be good to document that in some comments then for the sake of
posterity (maybe it is later in the set -- I haven't gotten to the end
yet).

Now, that said...I think that your ROC semantics are wrong here. You
also have to take delegations into account. [1]

Basically the semantics that you want are that nfsd should do all of
the ROC stuff on last close iff there are no outstanding delegations or
on delegreturn iff there are no opens.

What we ended up doing in the unreleased code we have was to create a
new per-client and per-file object (that we creatively called an
"odstate"). An open stateid and a delegation stateid would hold a
reference to this object which is put when those stateids are freed.
When its refcount goes to zero, then we'd free any outstanding layouts
on the file for that client and free the object.

You probably want to do something similar here.

[1]: Tom and Trond mentioned that there's a RFC5661 errata pending for
     this, but I don't see it right offhand.

-- 
Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
