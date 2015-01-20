Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 228E77F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 11:16:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6256AC010
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 09:16:34 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id BxEi73IJFwicBP7I (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 09:16:33 -0800 (PST)
Date: Tue, 20 Jan 2015 18:16:31 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/17] quota: Make Q_XQUOTASYNC support VFS quota syncing
Message-ID: <20150120171631.GG3648@quack.suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
	<1421412471-4747-10-git-send-email-jack@suse.cz>
	<20150119090914.GI27474@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150119090914.GI27474@infradead.org>
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

On Mon 19-01-15 01:09:14, Christoph Hellwig wrote:
> On Fri, Jan 16, 2015 at 01:47:43PM +0100, Jan Kara wrote:
> > Call ->quota_sync method from Q_XQUOTASYNC for better userspace
> > compatibility.
> 
> Q_XQUOTASYNC never did the equivalent to ->quota_sync, but rather was
> the equivalent to sys_syncfs which also happens to write out quotas.
> 
> Unless you have a really strong reason for wiring it up, I'd rather keep
> it as-is.
  OK, patch dropped.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
