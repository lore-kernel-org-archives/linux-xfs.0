Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF37C7F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 03:43:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDB95304048
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 01:42:59 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3hFdT2kmpWH5o1hD (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Oct 2014 01:42:54 -0700 (PDT)
Date: Wed, 8 Oct 2014 10:42:51 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/12] xfs: Set allowed quota types
Message-ID: <20141008084251.GB11781@quack.suse.cz>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-4-git-send-email-jack@suse.cz>
	<20141006203028.GB2301@dastard>
	<20141007192935.GF30038@quack.suse.cz>
	<3391F66C-E2A7-4FC8-8696-3C1600D54DA9@dilger.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3391F66C-E2A7-4FC8-8696-3C1600D54DA9@dilger.ca>
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel <cluster-devel@redhat.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, tytso@mit.edu, Ext4 Developers List <linux-ext4@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

On Tue 07-10-14 13:46:20, Andreas Dilger wrote:
> On Oct 7, 2014, at 1:29 PM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 07-10-14 07:30:28, Dave Chinner wrote:
> >> On Wed, Oct 01, 2014 at 09:31:25PM +0200, Jan Kara wrote:
> >>> We support user, group, and project quotas. Tell VFS about it.
> >>> 
> >>> CC: xfs@oss.sgi.com
> >>> CC: Dave Chinner <david@fromorbit.com>
> >>> Signed-off-by: Jan Kara <jack@suse.cz>
> >>> ---
> >>> fs/xfs/xfs_super.c | 2 ++
> >>> 1 file changed, 2 insertions(+)
> >>> 
> >>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >>> index b194652033cd..b32e998e8cbc 100644
> >>> --- a/fs/xfs/xfs_super.c
> >>> +++ b/fs/xfs/xfs_super.c
> >>> @@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
> >>> 	sb->s_export_op = &xfs_export_operations;
> >>> #ifdef CONFIG_XFS_QUOTA
> >>> 	sb->s_qcop = &xfs_quotactl_operations;
> >>> +	sb->s_dquot.allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA) |
> >>> +				    (1 << PRJQUOTA);
> >> 
> >> Would it be better to define masks for these rather than open
> >> coding these shifts everywhere?
> >  I can do that. Any suggestion for a name? I was thinking about it for a
> > while and couldn't come up with anything satisfactory...
> 
> Better to have QUOTA at the start, and TYPE in the name, so maybe:
> 
> enum quota_types {
> 	QUOTA_TYPE_USR = 1 << USRQUOTA,
> 	QUOTA_TYPE_GRP = 1 << GRPQUOTA,
> 	QUOTA_TYPE_PRJ = 1 << PRJQUOTA,
> };
> 
> or maybe "enum quota_type_mask" or similar.
> 
> I prefer named enums over #defines since this makes it more clear
> when declaring variables like "allowed_types" what valid values are
> instead of just "int" that someone might mistakenly set to USRQUOTA
> directly or something.
  OK, QUOTA_TYPE_USR etc. looks good. I'm not so sure about named enum. I'd
be fine with named enum for USRQUOTA, GRPQUOTA, etc. - i.e., types which
should have one of the named values but for a bitmask with arbitrary
combinations of flags it looks confusing to me (although technically
it would work).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
