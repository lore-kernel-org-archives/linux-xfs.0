Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C4C77F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 16:10:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 757EE304051
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 14:10:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jAlUj9WBo6SfcFWJ for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 14:10:41 -0700 (PDT)
Date: Fri, 21 Jun 2013 07:10:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130620211039.GS29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com> <8761x9x2i5.fsf@xmission.com>
	<20130620014133.GN29338@dastard>
	<20130620095419.0976a3a3@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130620095419.0976a3a3@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Thu, Jun 20, 2013 at 09:54:19AM -0400, Dwight Engen wrote:
> On Thu, 20 Jun 2013 11:41:33 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Wed, Jun 19, 2013 at 01:35:30PM -0700, Eric W. Biederman wrote:
> > > 
> > > I am copying my gmail address so I have a chance of seeing replies
> > > from Dave Chiner.  So far the only way I have been able to read his
> > > replies has been to read mailling lists.  Which has not be
> > > conductive to having this code discussed properly.  Hopefully
> > > copying my gmail address will allow us to have a reasonable and
> > > timely conversation.
> > > 
> > > 
> > > Dwight Engen <dwight.engen@oracle.com> writes:
> > > 
> > > > Use uint32 from init_user_ns for xfs internal uid/gid
> > > > representation in acl, xfs_icdinode. 
> > > 
> > > From my review of the code earlier that just isn't safe.  It allows
> > > all kinds of things to slip through.
> > 
> > Such as?
> 
> Maybe saying "at the vfs boundary" is misleading, I guess I don't see
> how this is all that different from what you did in the other
> filesystems. Using ext4 as the example the conversions are done between:
>  struct inode <-> struct ext4_inode
>  struct posix_acl <-> ext4_acle_entry
> 
> which in xfs is analogous to
>  struct inode <-> struct xfs_icdinode
>  struct posix acl <-> struct xfs_acl_entry
> 
> which is where I did the conversions.

Yup, that's where they should occur for XFS.

> > The kuid_t/kgid_t is actually pushed down this far - it's in the
> > struct inode - the code currently uses the on-disk XFS uid/gid,
> > not the struct inode's kuid_t/kgid_t. That's easily fixable.
> 
> Yep, I'll go through the code and switch to the inode where possible.

Cool. We'll need to be careful, though - there are some code paths
that XFS inodes can pass through where the VFS(ip) hasn't been
initialised. Let me worry about this during review, though ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
