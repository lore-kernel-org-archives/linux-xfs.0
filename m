Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KCkper205084 for <xfs@oss.sgi.com>; Thu, 20 May 2010 07:46:51 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B806D1417E49
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 05:49:10 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id miq9asl2LKf41xKb for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 05:49:10 -0700 (PDT)
Date: Thu, 20 May 2010 14:49:02 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/7] Fix test whether kernel supports quotas
Message-ID: <20100520124902.GB3395@quack.suse.cz>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
	<1274276289-8839-3-git-send-email-jack@suse.cz>
	<20100519184225.GA32747@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100519184225.GA32747@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 19-05-10 14:42:25, Christoph Hellwig wrote:
> On Wed, May 19, 2010 at 03:38:04PM +0200, Jan Kara wrote:
> > For all 2.6 kernels presence of quota support in kernel can be detected by
> > checking /proc/sys/fs/quota. This is actually more reliable than trying to
> > mount a filesystem with quota options (for example because SCRATCH_DEV does
> > not have to contain a filesystem type we are going to test).
> 
> It's not actually correct.  /proc/sys/fs/quota only gets registered by
> fs/quota/dquot.c, which means it's not avaiable in a kernel that only
> has XFS quotas.
  Ah, I was convinced that _require_quota() should check whether VFS
quotas are enabled but apparently it should work also for XFS. So would
test like below be OK?

if [ $FSTYP = "xfs" ]; then
    [ -f /proc/fs/xfs/xqmstat ] || _notrun "Installed kernel does not support XFS quota"
else
    [ -d /proc/sys/fs/quota ] || _notrun "Installed kernel does not support quota"
fi

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
