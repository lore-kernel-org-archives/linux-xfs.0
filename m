Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1GLP8nN182271 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 15:25:08 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32DB31D6948
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 13:26:25 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vGPpgkeiUv74tcoR for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 13:26:25 -0800 (PST)
Date: Tue, 16 Feb 2010 22:26:34 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 00/10] quotactl fixed and cleanups
Message-ID: <20100216212634.GI3153@quack.suse.cz>
References: <20100216084446.377980079@bombadil.infradead.org>
	<20100216183627.GC3153@quack.suse.cz>
	<20100216191207.GA3856@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100216191207.GA3856@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, swhiteho@redhat.com, xfs@oss.sgi.com

On Tue 16-02-10 14:12:07, Christoph Hellwig wrote:
> On Tue, Feb 16, 2010 at 07:36:28PM +0100, Jan Kara wrote:
> >   Thanks for the cleanups. Upto a few fixed typos and whitespace errors
> > I've merged your patchset into my tree.
> >   As a side note, OCFS2 implements XFS-style clustered quotas using current
> > VFS quota subsystem (and quota file format) so my naive feeling is that at
> > least GFS2 should fit in there as well. But maybe I'm wrong.
> 
> The file format is one big difference.  The other is that having the
> quota code in the filesystem allows much nicer integration with the
> transaction code.  Anyway, my next step is to support both the
> current "VFS" and the "XFS" quota interface independent of the
> underlying implementation, at least for the runtime calls.  The
> quota on/off bits are a bit too different, but it might be a good
> idea to handle those everywhere primarily via mount options and
> deprecate most of the old calls, but keep supporting them for a long
> time.  After that I plan to look a bit more in the quota implementation
> and look for sharing opportunities, but it might take a while until I
> get to that.
  The semantics I've chosen for OCFS2 is that if "USRQUOTA" filesystem
feature is enabled, we always do accounting of users' usage (as this is
essntially filesystem metadata). 'usrquota' mount option is just ignored
and used only to make life easier to quota-tools (so that they don't have
to parse superblock to find whether quota is supported or not). Enforcement
is enabled / disabled by quotactl call.
  I'd eventually love to convert ext3/4 to this behavior as well (and move
quota files to be invisible "system" inodes) so if XFS would be consistent
with this, it would be nice.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
