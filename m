Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D734F7CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 05:18:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 952E2304039
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 03:18:42 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id wEeb7b8hUVQQnHZp for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 03:18:41 -0700 (PDT)
Date: Mon, 13 May 2013 12:18:39 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [Patch] quota: do not leak info to user-space
Message-ID: <20130513101839.GE400@quack.suse.cz>
References: <1368177873-4819-1-git-send-email-amwang@redhat.com>
	<20130513100423.GD400@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130513100423.GD400@quack.suse.cz>
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
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon 13-05-13 12:04:23, Jan Kara wrote:
> On Fri 10-05-13 17:24:33, Cong Wang wrote:
> > From: Cong Wang <amwang@redhat.com>
> > 
> > There is a hole in struct fs_quota_stat, so we have to
> > zero the struct on stack before copying it to user-space.
> > 
> > Cc: Jan Kara <jack@suse.cz>
> > Signed-off-by: Cong Wang <amwang@redhat.com>
>   Good point. I've merged the patch.
  Ah, now I've noticed that XFS (the only user of the callback you are
fixing) is zeroing the structure on its own (xfs_qm_scall_getqstat). So
there's no real problem. I'm somewhat wondering whether clearing the field
in the place where you did it isn't more future-proof but usually we don't
pass in prezeroed buffers so I've decided to leave things as they are.

								Honza

> BTW for XFS folks: The structure definition looks somewhat odd (unaligned
> definition of qs_flags, qs_uquota starts only at 32-bit boundary although
> it has 64-bit fields in it) and I wouldn't be surprised if it needed compat
> wrapper for 32-bit apps on some architectures...
> 
> 								Honza
> > 
> > ---
> > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > index c7314f1..2b0c182 100644
> > --- a/fs/quota/quota.c
> > +++ b/fs/quota/quota.c
> > @@ -211,6 +211,7 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
> >  
> >  	if (!sb->s_qcop->get_xstate)
> >  		return -ENOSYS;
> > +	memset(&fqs, 0, sizeof(fqs));
> >  	ret = sb->s_qcop->get_xstate(sb, &fqs);
> >  	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
> >  		return -EFAULT;
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
