Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39MJoAP217346 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 17:19:50 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HMXTiTrRC098DWfN for <xfs@oss.sgi.com>;
	Mon, 09 Apr 2012 15:19:48 -0700 (PDT)
Date: Tue, 10 Apr 2012 08:19:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: detecting case-insensitivity
Message-ID: <20120409221946.GL18323@dastard>
References: <LBVkglc6jtb7.r3bLKBnl@host202.hostmonster.com>
	<20120409212833.GA10508@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120409212833.GA10508@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, xfs@oss.sgi.com

On Mon, Apr 09, 2012 at 05:28:33PM -0400, J. Bruce Fields wrote:
> > > From: Dave Chinner <david@fromorbit.com>
> > > Date: 09.04.2012 03.30
> > > 
> > > On Sat, Apr 07, 2012 at 10:00:29AM -0400, J. Bruce Fields wrote:
> > > > Is there a generic way to detect whether a given filesystem is
> > > > case-insensitive?  If not, how should it be done?  (A bit in s_flags?)
> > > 
> > > I don't think there is a generic flag for it. We could trivially add
> > > one, I think, as it is generally a fixed property for the entire
> > > filesystem....
> 
> So, I assume the following is totally wrong, but the basic idea (create
> a new flag, set it based on xfs_sb_version_hasasciici, check it in nfsd)
> would work?

Looks mostly OK to me.

> On Mon, Apr 09, 2012 at 09:01:11AM +0400, Vyacheslav Dubeyko wrote:
> > But why does it need to detect that filesystem case-insensitive or not? In what use-case does it need to make such detection?
> 
> To be honest, I have no idea--it's not a mandatory attribute, so I think
> I'll instead just ceasing to support the attribute and seeing if anyone
> complains....

I suspect that there are some applications out there that might care
that Bruce and bruce are the same file for matching purposes (e.g. a
file manager)

....

> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 7423d71..890f439 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1458,7 +1458,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
>  		switch (createmode) {
>  		case NFS3_CREATE_UNCHECKED:
>  			if (! S_ISREG(dchild->d_inode->i_mode))
> -				err = nfserr_exist;
> +				goto out;

Not sure what this change is for, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
