Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9F4PR0022071 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 09:04:25 -0600
MIME-Version: 1.0
Message-ID: <19712.61515.201226.938553@quad.stoffel.home>
Date: Thu, 9 Dec 2010 10:05:47 -0500
From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] fs/vfs/security: pass last path component to LSM on inode
	creation
In-Reply-To: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
References: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
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
Cc: jfs-discussion@lists.sourceforge.net, jack@suse.cz, jeffm@suse.com, jmorris@namei.org, dhowells@redhat.com, linux-mm@kvack.org, linux-mtd@lists.infradead.org, serue@us.ibm.com, shaggy@linux.vnet.ibm.com, shemminger@vyatta.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, hughd@google.com, joel.becker@oracle.com, cluster-devel@redhat.com, tao.ma@oracle.com, aelder@sgi.com, kees.cook@canonical.com, linux-ext4@vger.kernel.org, sds@tycho.nsa.gov, paul.moore@hp.com, mfasheh@suse.com, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, dchinner@redhat.com, eparis@parisplace.org, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-btrfs@vger.kernel.org, casey@schaufler-ca.com, adilger.kernel@dilger.ca, akpm@linux-foundation.org, dwmw2@infradead.org, ocfs2-devel@oss.oracle.com

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> SELinux would like to implement a new labeling behavior of newly
Eric> created inodes.  We currently label new inodes based on the
Eric> parent and the creating process.  This new behavior would also
Eric> take into account the name of the new object when deciding the
Eric> new label.  This is not the (supposed) full path, just the last
Eric> component of the path.

Eric> This is very useful because creating /etc/shadow is different
Eric> than creating /etc/passwd but the kernel hooks are unable to
Eric> differentiate these operations.  We currently require that
Eric> userspace realize it is doing some difficult operation like that
Eric> and than userspace jumps through SELinux hoops to get things set
Eric> up correctly.  This patch does not implement new behavior, that
Eric> is obviously contained in a seperate SELinux patch, but it does
Eric> pass the needed name down to the correct LSM hook.  If no such
Eric> name exists it is fine to pass NULL.

I've looked this patch over, and maybe I'm missing something, but how
does knowing the name of the file really tell you anything, esp when
you only get the filename, not the path?  What threat are you
addressing with this change?  

So what happens when I create a file /home/john/shadow, does selinux
(or LSM in general) then run extra checks because the filename is
'shadow' in your model?  

I *think* the overhead shouldn't be there if SELINUX is disabled, but
have you confirmed this?  How you run performance tests before/after
this change when doing lots of creations of inodes to see what sort of
performance changes might be there?

Thanks,
John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
