Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9HkuGE047533 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 11:46:56 -0600
MIME-Version: 1.0
Message-ID: <19713.5738.653711.301814@quad.stoffel.home>
Date: Thu, 9 Dec 2010 12:48:26 -0500
From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] fs/vfs/security: pass last path component to LSM on
	inode creation
In-Reply-To: <1291909941.3072.70.camel@localhost.localdomain>
References: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
	<19712.61515.201226.938553@quad.stoffel.home>
	<1291909941.3072.70.camel@localhost.localdomain>
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
Cc: jfs-discussion@lists.sourceforge.net, jack@suse.cz, jeffm@suse.com, jmorris@namei.org, dhowells@redhat.com, linux-mm@kvack.org, linux-mtd@lists.infradead.org, shaggy@linux.vnet.ibm.com, shemminger@vyatta.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, hughd@google.com, joel.becker@oracle.com, cluster-devel@redhat.com, tao.ma@oracle.com, aelder@sgi.com, kees.cook@canonical.com, linux-ext4@vger.kernel.org, sds@tycho.nsa.gov, paul.moore@hp.com, mfasheh@suse.com, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, dchinner@redhat.com, eparis@parisplace.org, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-btrfs@vger.kernel.org, casey@schaufler-ca.com, adilger.kernel@dilger.ca, akpm@linux-foundation.org, dwmw2@infradead.org, ocfs2-devel@oss.oracle.com

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> On Thu, 2010-12-09 at 10:05 -0500, John Stoffel wrote:
>> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

>> So what happens when I create a file /home/john/shadow, does selinux
>> (or LSM in general) then run extra checks because the filename is
>> 'shadow' in your model?  

Eric> It's entirely a question of labeling and one that was discussed on the
Eric> LSM list in some detail:

Eric> http://marc.info/?t=129141308200002&r=1&w=2

Thank you for pointing me at this discussion.  I'm working my way
through it, but so far I'm not seeing any consensus that this is
really the proper thing to do.  I personally feel this should be in
userspace if at all possible.

Eric> The basic synopsis is that when a new inode is created SELinux
Eric> must apply some label.  It makes the decision for what label to
Eric> apply based on 3 pieces of information.

Eric> The label of the parent inode.
Eric> The label of the process creating the new inode.
Eric> The 'class' of the inode, S_ISREG, S_ISDIR, S_ISLNK, etc

These seem to be ok, if you're using label based security.  But since
I freely admit I'm not an expert or even a user, I'm just trying to
understand and push back to make sure we do what's good.  And which
doesn't impact non-SElinux users.  

Eric> This patch adds a 4th piece of information, the name of the
Eric> object being created.  An obvious situation where this will be
Eric> useful is devtmpfs (although you'll find other examples in the
Eric> above thread).  devtmpfs when it creates char/block devices is
Eric> unable to distinguish between kmem and console and so they are
Eric> created with a generic label.  hotplug/udev is then called which
Eric> does some pathname like matching and relabels them to something
Eric> more specific.  We've found that many people are able to race
Eric> against this particular updating and get spurious denials in
Eric> /dev.  With this patch devtmpfs will be able to get the labels
Eric> correct to begin with.

So your Label based access controls are *also* based on pathnames?
Right?  

Eric> I'm certainly willing to discuss the security implications of this
Eric> patch, but that would probably be best done with a significantly
Eric> shortened cc-list.  You'll see in the above mentioned thread that a
Eric> number of 'security' people (even those who are staunchly anti-SELinux)
Eric> recognize there is value in this and that it is certainly much better
Eric> than we have today.

>> I *think* the overhead shouldn't be there if SELINUX is disabled, but
>> have you confirmed this?  How you run performance tests before/after
>> this change when doing lots of creations of inodes to see what sort of
>> performance changes might be there?

Eric> I've actually recently done some perf testing on creating large
Eric> numbers of inodes using bonnie++, since SELinux was a noticeable
Eric> overhead in that operation.  Doing that same test with SELinux
Eric> disabled (or enabled) I do not see a noticeable difference when
Eric> this patch is applied or not.  It's just an extra argument to a
Eric> function that goes unused.

That answers alot of my concerns then.  Not having it impact users in
a non-SELinux context is vitally important to me.

Thanks,
John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
