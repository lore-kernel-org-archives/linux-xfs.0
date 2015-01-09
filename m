Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C15557F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 11:33:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ADD478F8040
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 09:33:59 -0800 (PST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
	[209.85.192.46]) by cuda.sgi.com with ESMTP id hBWrUuJIdEMgqnUC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2015 09:33:58 -0800 (PST)
Received: by mail-qg0-f46.google.com with SMTP id q107so9867697qgd.5
	for <xfs@oss.sgi.com>; Fri, 09 Jan 2015 09:33:57 -0800 (PST)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Fri, 9 Jan 2015 09:33:53 -0800
Subject: Re: [PATCH 09/18] nfsd: implement pNFS operations
Message-ID: <20150109093353.31a2e425@synchrony.poochiereds.net>
In-Reply-To: <20150109092835.5fdbac5d@synchrony.poochiereds.net>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-10-git-send-email-hch@lst.de>
	<20150108164851.03b64e16@synchrony.poochiereds.net>
	<20150109100551.GA23173@lst.de>
	<20150109085130.0f862d24@synchrony.poochiereds.net>
	<20150109171641.GA17464@lst.de>
	<20150109092835.5fdbac5d@synchrony.poochiereds.net>
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

On Fri, 9 Jan 2015 09:28:35 -0800
Jeff Layton <jlayton@primarydata.com> wrote:

>  On Fri, 9 Jan 2015 18:16:41 +0100
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Fri, Jan 09, 2015 at 08:51:30AM -0800, Jeff Layton wrote:
> > > Ok, it'd be good to document that in some comments then for the sake of
> > > posterity (maybe it is later in the set -- I haven't gotten to the end
> > > yet).
> > 
> > What kinds of comments do you expect?  Not implementing unused features
> > of a protocol should be the default for anything in Linux.
> > 
> 
> I was thinking just a comment saying that ROC is always true in this
> implementation, or maybe consider eliminating the lg_roc field in
> struct nfsd4_layoutget altogether since it's currently always "1".
> 
> It's a little confusing now since the encoder can handle the case where
> lg_roc is 0, but the rest of the code can't.
> 
> > > Now, that said...I think that your ROC semantics are wrong here. You
> > > also have to take delegations into account. [1]
> > > 
> > > Basically the semantics that you want are that nfsd should do all of
> > > the ROC stuff on last close iff there are no outstanding delegations or
> > > on delegreturn iff there are no opens.
> > > 
> > > What we ended up doing in the unreleased code we have was to create a
> > > new per-client and per-file object (that we creatively called an
> > > "odstate"). An open stateid and a delegation stateid would hold a
> > > reference to this object which is put when those stateids are freed.
> > > When its refcount goes to zero, then we'd free any outstanding layouts
> > > on the file for that client and free the object.
> > > 
> > > You probably want to do something similar here.
> > > 
> > > [1]: Tom and Trond mentioned that there's a RFC5661 errata pending for
> > >      this, but I don't see it right offhand.
> > 
> > It would be good to look at the errata.  While the idea of keeping
> > layouts around longer makes sense, I would only expect to do this
> > if they layout state was created based on a delegation stateid, not
> > a lock or open stateid.  In that case having the layouts hang off
> > the "parent" stateid might be another option.
> 
> I found it:
> 
>     http://www.rfc-editor.org/errata_search.php?rfc=5661&eid=3226
> 

Oh, hmm...except that doesn't seem to have been updated according to
the discussion from around a year ago. See the thread entitled:

    [nfsv4] NFSv4.1 errata id 3226 (the return of return-on-close layouts)

...on thee nfsv4@ietf.org mailing list. Trond mentions it there.
Perhaps we need to revise that errata?

-- 
Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
