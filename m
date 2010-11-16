Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGBgFbJ035942 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 05:42:16 -0600
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3BD8184354
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 03:43:48 -0800 (PST)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id Hd4VuAiidNKF9Bhv for <xfs@oss.sgi.com>;
	Tue, 16 Nov 2010 03:43:48 -0800 (PST)
Date: Tue, 16 Nov 2010 12:43:46 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101116114346.GB4757@quack.suse.cz>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
	<1289840723-3056-2-git-send-email-josef@redhat.com>
	<20101116111611.GA4757@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101116111611.GA4757@quack.suse.cz>
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
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Tue 16-11-10 12:16:11, Jan Kara wrote:
> On Mon 15-11-10 12:05:18, Josef Bacik wrote:
> > diff --git a/fs/open.c b/fs/open.c
> > index 4197b9e..ab8dedf 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  		return -EINVAL;
> >  
> >  	/* Return error if mode is not supported */
> > -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> > +	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
>   Why not just:
> if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) ?
  And BTW, since FALLOC_FL_PUNCH_HOLE does not change the file size, should
not we enforce that FALLOC_FL_KEEP_SIZE is / is not set? I don't mind too
much which way but keeping it ambiguous (ignored) in the interface usually
proves as a bad idea in future when we want to further extend the interface...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
