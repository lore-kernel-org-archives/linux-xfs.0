Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9F6207F3F
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 14:29:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E3ACAC005
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 12:29:39 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Cy1cck9FBD0tK7dm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Oct 2014 12:29:37 -0700 (PDT)
Date: Tue, 7 Oct 2014 21:29:35 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/12] xfs: Set allowed quota types
Message-ID: <20141007192935.GF30038@quack.suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-4-git-send-email-jack@suse.cz>
	<20141006203028.GB2301@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141006203028.GB2301@dastard>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Tue 07-10-14 07:30:28, Dave Chinner wrote:
> On Wed, Oct 01, 2014 at 09:31:25PM +0200, Jan Kara wrote:
> > We support user, group, and project quotas. Tell VFS about it.
> > 
> > CC: xfs@oss.sgi.com
> > CC: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_super.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index b194652033cd..b32e998e8cbc 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
> >  	sb->s_export_op = &xfs_export_operations;
> >  #ifdef CONFIG_XFS_QUOTA
> >  	sb->s_qcop = &xfs_quotactl_operations;
> > +	sb->s_dquot.allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA) |
> > +				    (1 << PRJQUOTA);
> 
> Would it be better to define masks for these rather than open
> coding these shifts everywhere?
  I can do that. Any suggestion for a name? I was thinking about it for a
while and couldn't come up with anything satisfactory...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
