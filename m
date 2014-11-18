Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FD5F7F4E
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 10:07:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2013E304048
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2014 08:07:31 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2mpMl4go0slmwNyn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2014 08:07:28 -0800 (PST)
Date: Tue, 18 Nov 2014 17:07:26 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/11] ext4: Use generic helpers for quotaon and quotaoff
Message-ID: <20141118160726.GB29472@quack.suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-8-git-send-email-jack@suse.cz>
	<20141113173600.GB31481@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141113173600.GB31481@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 13-11-14 09:36:00, Christoph Hellwig wrote:
> >  static const struct quotactl_ops ext4_qctl_sysfile_operations = {
> > -	.quota_on_meta	= ext4_quota_on_sysfile,
> > -	.quota_off	= ext4_quota_off_sysfile,
> > +	.sysquota_on	= dquot_sysquota_on,
> > +	.sysquota_off	= dquot_sysquota_off,
> >  	.quota_sync	= dquot_quota_sync,
> >  	.get_info	= dquot_get_dqinfo,
> >  	.set_info	= dquot_set_dqinfo,
> 
> This vector now only has generic dquot_ methods.  Maybe move the
> vector to fs/quota/dquot.c and allow multiple filesystems to share it?
  Right. ocfs2 actually has the same vector now. I'll unify it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
