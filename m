Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9I5sgW050863 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 12:05:54 -0600
Subject: Re: [PATCH] fs/vfs/security: pass last path component to LSM on
	inode creation
From: Eric Paris <eparis@redhat.com>
In-Reply-To: <19713.5738.653711.301814@quad.stoffel.home>
References: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
	<19712.61515.201226.938553@quad.stoffel.home>
	<1291909941.3072.70.camel@localhost.localdomain>
	<19713.5738.653711.301814@quad.stoffel.home>
Date: Thu, 09 Dec 2010 13:05:21 -0500
Message-ID: <1291917921.12683.4.camel@localhost.localdomain>
Mime-Version: 1.0
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
To: John Stoffel <john@stoffel.org>
Cc: jfs-discussion@lists.sourceforge.net, jack@suse.cz, jeffm@suse.com, jmorris@namei.org, dhowells@redhat.com, linux-mm@kvack.org, linux-mtd@lists.infradead.org, shaggy@linux.vnet.ibm.com, shemminger@vyatta.com, hch@lst.de, penguin-kernel@I-love.SAKURA.ne.jp, hughd@google.com, joel.becker@oracle.com, cluster-devel@redhat.com, aelder@sgi.com, kees.cook@canonical.com, linux-ext4@vger.kernel.org, sds@tycho.nsa.gov, paul.moore@hp.com, mfasheh@suse.com, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, dchinner@redhat.com, eparis@parisplace.org, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-btrfs@vger.kernel.org, casey@schaufler-ca.com, adilger.kernel@dilger.ca, akpm@linux-foundation.org, dwmw2@infradead.org, ocfs2-devel@oss.oracle.com

On Thu, 2010-12-09 at 12:48 -0500, John Stoffel wrote:
> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:
> 
> Eric> On Thu, 2010-12-09 at 10:05 -0500, John Stoffel wrote:
> >> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:
> 
> Eric> This patch adds a 4th piece of information, the name of the
> Eric> object being created.  An obvious situation where this will be
> Eric> useful is devtmpfs (although you'll find other examples in the
> Eric> above thread).  devtmpfs when it creates char/block devices is
> Eric> unable to distinguish between kmem and console and so they are
> Eric> created with a generic label.  hotplug/udev is then called which
> Eric> does some pathname like matching and relabels them to something
> Eric> more specific.  We've found that many people are able to race
> Eric> against this particular updating and get spurious denials in
> Eric> /dev.  With this patch devtmpfs will be able to get the labels
> Eric> correct to begin with.
> 
> So your Label based access controls are *also* based on pathnames?
> Right?

Access decisions are still based solely on the label.  This patch can
influence how new objects get their label, which makes the access
decisions indirectly path based.  You'll find a reasonable summary and
commentary on lwn in this weeks security section.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
