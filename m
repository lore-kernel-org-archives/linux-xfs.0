Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 461727C8C
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 12:33:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 415EA8F804C
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2016 10:33:23 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id OVTax2GzSZygOlml (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 19 Feb 2016 10:33:21 -0800 (PST)
Date: Fri, 19 Feb 2016 19:33:42 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
Message-ID: <20160219183342.GH30068@quack.suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<56C7518E.4020204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C7518E.4020204@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri 19-02-16 11:31:58, Eric Sandeen wrote:
> 
> 
> On 2/4/16 8:28 AM, Jan Kara wrote:
> > Add infrastructure for supporting get_nextdqblk() callback for VFS
> > quotas. Translate the operation into a callback to appropriate
> > filesystem and consequently to quota format callback.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/super.c          |  1 +
> >  fs/quota/dquot.c         | 39 +++++++++++++++++++++++++++++++++++++++
> >  fs/reiserfs/super.c      |  1 +
> >  include/linux/quota.h    |  3 +++
> >  include/linux/quotaops.h |  3 +++
> >  5 files changed, 47 insertions(+)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index f1b56ff01208..51649f442bf6 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
> >  	.write_info	= ext4_write_info,
> >  	.alloc_dquot	= dquot_alloc,
> >  	.destroy_dquot	= dquot_destroy,
> > +	.get_next_id	= dquot_get_next_id,
> >  };
> 
> Hi Jan, doesn't this also need to set:
> 
> 
> +       .get_nextdqblk  = dquot_get_next_dqblk,
> 
> in ext4_qctl_sysfile_operations?

Indeed, thanks for catching this. Patch added (with your authorship and
sign-off) into my tree and this time I've properly tested Q_GETNEXTQUOTA
for ext4 with quota in hidden inodes indeed works (previously I've tested
only visible quota files).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
