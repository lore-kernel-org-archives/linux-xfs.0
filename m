Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5AA027F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 15:22:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CAE1304071
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 13:22:25 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dJvGNYtrHf1AWqub (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 13:22:23 -0700 (PDT)
Date: Tue, 15 Apr 2014 13:22:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/4] xfs: initialize inode security on tmpfile creation
Message-ID: <20140415202222.GA10928@infradead.org>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
	<1397578706-5385-3-git-send-email-bfoster@redhat.com>
	<20140415175033.GB26404@infradead.org>
	<534D90D0.9090805@tycho.nsa.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534D90D0.9090805@tycho.nsa.gov>
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
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, linux-security-module@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 04:04:32PM -0400, Stephen Smalley wrote:
> Is there a reason that xfs_init_security() isn't called from the inode
> allocation function (e.g. xfs_ialloc), as in ext4 (__ext4_new_inode
> calls ext4_init_security and also calls ext4_init_acl)?  That would have
> ensured that tmpfile inodes would have been labeled without requiring a
> separate change and more generally ensures complete coverage for all inodes.

Really just code structuring - we don't like callouts to high level VFS
functions from deep down in the guts of the filesystem.

> For SELinux, we need the tmpfile inodes to be labeled at creation time,
> not just if linked into the namespace, since they may be shared via
> local socket IPC or inherited across a label-changing exec and since we
> revalidate access on transfer or use.
> 
> Labeling based on the provided directory could be a bit random, although
> it will work out with current policy if the provided directory
> corresponds to existing tmpfile locations (e.g. /tmp, /var/tmp) and
> therefore already has a label associated with temporary files.
> Otherwise we might want some indication that it is a tmpfile passed into
> security_inode_init_security() so that we can always select a stable
> label irrespective of the directory.

Just check for I_LINKABLE in i_flags.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
