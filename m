Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67E457CBD
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 08:49:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C8C78F8049
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 06:49:18 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id xATlRAmT0yeLaYKH (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jan 2016 06:49:16 -0800 (PST)
Date: Mon, 25 Jan 2016 15:49:28 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/7] quota: remove unused cmd argument from quota_quotaon()
Message-ID: <20160125144928.GK24938@quack.suse.cz>
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
	<1453487136-12681-2-git-send-email-sandeen@redhat.com>
	<20160125144702.GJ24938@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160125144702.GJ24938@quack.suse.cz>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

On Mon 25-01-16 15:47:02, Jan Kara wrote:
> On Fri 22-01-16 12:25:30, Eric Sandeen wrote:
> > The cmd argument to quota_quotaon() via Q_QUOTAON quotactl
> > is not used, so remove it.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Ah, I'm in a reviewe mode... ;) I'll just take this patch to my tree.

								Honza

> > ---
> >  fs/quota/quota.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > index 3746367..ea66670 100644
> > --- a/fs/quota/quota.c
> > +++ b/fs/quota/quota.c
> > @@ -79,7 +79,7 @@ unsigned int qtype_enforce_flag(int type)
> >  	return 0;
> >  }
> >  
> > -static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
> > +static int quota_quotaon(struct super_block *sb, int type, qid_t id,
> >  		         struct path *path)
> >  {
> >  	if (!sb->s_qcop->quota_on && !sb->s_qcop->quota_enable)
> > @@ -659,7 +659,7 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
> >  
> >  	switch (cmd) {
> >  	case Q_QUOTAON:
> > -		return quota_quotaon(sb, type, cmd, id, path);
> > +		return quota_quotaon(sb, type, id, path);
> >  	case Q_QUOTAOFF:
> >  		return quota_quotaoff(sb, type);
> >  	case Q_GETFMT:
> > -- 
> > 1.7.1
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
