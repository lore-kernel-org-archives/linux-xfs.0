Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 578027F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 11:13:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3471D304039
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 09:13:53 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 5i4tHHQuf83fBbkU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 09:13:51 -0800 (PST)
Date: Tue, 20 Jan 2015 18:13:48 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/17] ocfs2: Use generic helpers for quotaon and quotaoff
Message-ID: <20150120171348.GF3648@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-6-git-send-email-jack@suse.cz>
	<20150119090347.GE27474@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150119090347.GE27474@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Mon 19-01-15 01:03:47, Christoph Hellwig wrote:
> On Fri, Jan 16, 2015 at 01:47:39PM +0100, Jan Kara wrote:
> > Ocfs2 can just use the generic helpers provided by quota code for
> > turning quotas on and off when quota files are stored as system inodes.
> > The only difference is the feature test in ocfs2_quota_on() and that is
> > covered by dquot_quota_enable() checking whether usage tracking is
> > enabled (which can happen only if the filesystem has the quota feature
> > set).
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/super.c | 32 +-------------------------------
> >  1 file changed, 1 insertion(+), 31 deletions(-)
> > 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 83723179e1ec..706c71c2955d 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -1000,36 +1000,6 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
> >  	}
> >  }
> >  
> > -/* Handle quota on quotactl */
> > -static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
> > -{
> > -	unsigned int feature[OCFS2_MAXQUOTAS] = {
> > -					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
> > -					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
> > -
> > -	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
> > -		return -EINVAL;
> 
> Where are we doing this feature check now?
  So OCFS2 (similarly as ext4 or xfs) has to enable quota accounting on
mount and at that point we test for the feature. Q_QUOTAON quotactl is
used just to turn on enforcement and at that point it makes no sense to
check for the feature (BTW, the changelog already explains this ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
