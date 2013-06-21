Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DC547F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 12:48:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 348ABAC002
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 10:48:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LFkYD2oCeW71xBQg for
	<xfs@oss.sgi.com>; Fri, 21 Jun 2013 10:48:13 -0700 (PDT)
Date: Fri, 21 Jun 2013 14:48:05 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: fix sgid inheritance for subdirectories inheriting
	default acls [V2]
Message-ID: <20130621174804.GA2843@andromeda.usersys.redhat.com>
References: <1371569536-5779-1-git-send-email-cmaiolino@redhat.com>
	<20130618224351.GB29338@dastard>
	<20130619132921.GA5200@andromeda.usersys.redhat.com>
	<20130619233951.GL29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619233951.GL29338@dastard>
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
Cc: xfs@oss.sgi.com

Thanks for the Review Dave, Patch V3 sent to ML

cheers
> On Wed, Jun 19, 2013 at 10:29:22AM -0300, Carlos Maiolino wrote:
> > Hi Dave,
> > 
> > > > @@ -594,9 +594,10 @@ xfs_setattr_nonsize(
> > > >  		 * The set-user-ID and set-group-ID bits of a file will be
> > > >  		 * cleared upon successful return from chown()
> > > >  		 */
> > > > -		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> > > > -		    !capable(CAP_FSETID))
> > > > -			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
> > > > +		if (!S_ISDIR(inode->i_mode))
> > > > +			if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> > > > +			    !capable(CAP_FSETID))
> > > > +				ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
> > > 
> > > I'm not sure I understand why this is part of this patch - the ACL
> > > path does not enter this code branch (ATTR_UID/GID) so it doesn't
> > > affect ACL inheritence. So this is some other behavioural change?
> > > 
> > My apologies to have not commented it.
> > 
> > During my code surfing to understand the problem, and what places we revoked
> > sgid, I found this one, and, based on chmod specifications, we should keep sgid
> > on the directory while chmoding it, unless the user explicitly ask for sgid
> > removal, otherwise, if chmoding a file, we remove sgid if this isn't specified
> > in the new mode. So, I've added a check here to ensure the inode isn't a dir
> > before remove the sgid bit.
> 

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
