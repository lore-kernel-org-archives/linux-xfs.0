Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68GI2UN253635 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 11:18:02 -0500
Date: Fri, 8 Jul 2011 17:17:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs/vfs/security: pass last path component to LSM on
	inode creation
Message-ID: <20110708161722.GG11013@ZenIV.linux.org.uk>
References: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
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
To: Eric Paris <eparis@redhat.com>
Cc: jfs-discussion@lists.sourceforge.net, jack@suse.cz, jeffm@suse.com, joel.becker@oracle.com, dhowells@redhat.com, linux-mm@kvack.org, linux-mtd@lists.infradead.org, serue@us.ibm.com, shaggy@linux.vnet.ibm.com, shemminger@vyatta.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, hughd@google.com, jmorris@namei.org, cluster-devel@redhat.com, tao.ma@oracle.com, aelder@sgi.com, kees.cook@canonical.com, linux-ext4@vger.kernel.org, sds@tycho.nsa.gov, paul.moore@hp.com, mfasheh@suse.com, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, dchinner@redhat.com, eparis@parisplace.org, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-btrfs@vger.kernel.org, casey@schaufler-ca.com, adilger.kernel@dilger.ca, akpm@linux-foundation.org, dwmw2@infradead.org, ocfs2-devel@oss.oracle.com

On Wed, Dec 08, 2010 at 02:45:27PM -0500, Eric Paris wrote:
> SELinux would like to implement a new labeling behavior of newly created
> inodes.  We currently label new inodes based on the parent and the creating
> process.  This new behavior would also take into account the name of the
> new object when deciding the new label.  This is not the (supposed) full path,
> just the last component of the path.
> 
> This is very useful because creating /etc/shadow is different than creating
> /etc/passwd but the kernel hooks are unable to differentiate these
> operations.  We currently require that userspace realize it is doing some
> difficult operation like that and than userspace jumps through SELinux hoops
> to get things set up correctly.  This patch does not implement new
> behavior, that is obviously contained in a seperate SELinux patch, but it
> does pass the needed name down to the correct LSM hook.  If no such name
> exists it is fine to pass NULL.

-ETOOFUCKINGUGLY...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
