Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27B337CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 03:08:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88310AC001
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 01:08:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id k0ylxGbpFgS85tyz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 01:08:36 -0700 (PDT)
Date: Wed, 24 Aug 2016 10:08:33 +0200
From: Artem Savkov <asavkov@redhat.com>
Subject: Re: [PATCH] Make __xfs_xattr_put_listen preperly report errors.
Message-ID: <20160824080833.GA11104@shodan.usersys.redhat.com>
References: <1471967653-2561-1-git-send-email-asavkov@redhat.com>
	<20160824015551.GB19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160824015551.GB19025@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 24, 2016 at 11:55:51AM +1000, Dave Chinner wrote:
> On Tue, Aug 23, 2016 at 05:54:13PM +0200, Artem Savkov wrote:
> > Commit "xfs: only return -errno or success from attr ->put_listent" changes the
> 
> Please quote commits in --oneline format in changelogs - it makes it
> much easier to find the change you are refering to if there is both
> a commit ID and the text string in the commit message. (i.e. text
> string confirms the commit id is the one you meant to quote).

Noted, thanks.

> 
> commit 2a6fba6 ("xfs: only return -errno or success from attr
> ->put_listent") is the one you are refering to here, right?

Yes, that is the one.

> > returnvalue of __xfs_xattr_put_listen to 0 in case when there is insufficient
> > space in the buffer assuming that setting context->count to -1 would be enough,
> > but all of the ->put_listent callers only check seen_enough. This results in
> > a failed assertion:
> > XFS: Assertion failed: context->count >= 0, file: fs/xfs/xfs_xattr.c, line: 175
> > in insufficient buffer size case.
> 
> You have a test case? Can you turn it into an xfstest? We really
> need regression tests that cover issues like this....
> 

llistxattr02 test from LTP reliably hits this, I'll see how this can be
ported to xfstest.

> > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > ---
> >  fs/xfs/xfs_xattr.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index ea62245..6290093 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -147,6 +147,7 @@ __xfs_xattr_put_listent(
> >  	arraytop = context->count + prefix_len + namelen + 1;
> >  	if (arraytop > context->firstu) {
> >  		context->count = -1;	/* insufficient space */
> > +		context->seen_enough = 1;
> >  		return 0;
> >  	}
> >  	offset = (char *)context->alist + context->count;
> 
> Looks sane, though I don't know how to test it yet....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Regards,
  Artem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
