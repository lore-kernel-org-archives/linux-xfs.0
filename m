Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39MRNPn218327 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 17:27:24 -0500
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id XWgA442N0huAHUdV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Apr 2012 15:27:22 -0700 (PDT)
Date: Mon, 9 Apr 2012 18:27:20 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: detecting case-insensitivity
Message-ID: <20120409222720.GB10508@fieldses.org>
References: <LBVkglc6jtb7.r3bLKBnl@host202.hostmonster.com>
	<20120409212833.GA10508@fieldses.org>
	<20120409221946.GL18323@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120409221946.GL18323@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, xfs@oss.sgi.com

On Tue, Apr 10, 2012 at 08:19:46AM +1000, Dave Chinner wrote:
> On Mon, Apr 09, 2012 at 05:28:33PM -0400, J. Bruce Fields wrote:
> > > > From: Dave Chinner <david@fromorbit.com>
> > > > Date: 09.04.2012 03.30
> > > > 
> > > > On Sat, Apr 07, 2012 at 10:00:29AM -0400, J. Bruce Fields wrote:
> > > > > Is there a generic way to detect whether a given filesystem is
> > > > > case-insensitive?  If not, how should it be done?  (A bit in s_flags?)
> > > > 
> > > > I don't think there is a generic flag for it. We could trivially add
> > > > one, I think, as it is generally a fixed property for the entire
> > > > filesystem....
> > 
> > So, I assume the following is totally wrong, but the basic idea (create
> > a new flag, set it based on xfs_sb_version_hasasciici, check it in nfsd)
> > would work?
> 
> Looks mostly OK to me.
> 
> > On Mon, Apr 09, 2012 at 09:01:11AM +0400, Vyacheslav Dubeyko wrote:
> > > But why does it need to detect that filesystem case-insensitive or not? In what use-case does it need to make such detection?
> > 
> > To be honest, I have no idea--it's not a mandatory attribute, so I think
> > I'll instead just ceasing to support the attribute and seeing if anyone
> > complains....
> 
> I suspect that there are some applications out there that might care
> that Bruce and bruce are the same file for matching purposes (e.g. a
> file manager)

I suppose they could try the create and find out what happens.

If they actually want to be able to predict collisions instead of
recognizing them after the fact then they may need to know in more
detail how we handle case, and then I worry that I'll have to start
understanding what language like this means:

	http://tools.ietf.org/html/draft-ietf-nfsv4-rfc3530bis-17#section-12.7.1.3

	...if the NFSv4 file server supports the case_insensitive file
	system attribute, and if the case_insensitive attribute is true
	for a given file system, the NFS version 4 server MUST use the
	Unicode case mapping tables for the version of Unicode
	corresponding to the character repertoire.

which isn't high on my todo list.

I'll ask around and repost this patch if it looks like somebody actually
would find that attribute useful.

> 
> ....
> 
> > diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> > index 7423d71..890f439 100644
> > --- a/fs/nfsd/vfs.c
> > +++ b/fs/nfsd/vfs.c
> > @@ -1458,7 +1458,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
> >  		switch (createmode) {
> >  		case NFS3_CREATE_UNCHECKED:
> >  			if (! S_ISREG(dchild->d_inode->i_mode))
> > -				err = nfserr_exist;
> > +				goto out;
> 
> Not sure what this change is for, though....

Erp, leaked from another patch.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
