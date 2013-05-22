Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B221B29E03
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 23:03:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4961EAC002
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 21:03:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OsAaCg2lRNKlKMKC for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 21:03:20 -0700 (PDT)
Date: Wed, 22 May 2013 14:03:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522040318.GG29466@dastard>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522025605.GA29767@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, May 21, 2013 at 10:56:05PM -0400, Dave Jones wrote:
> On Wed, May 22, 2013 at 10:16:03AM +1000, Dave Chinner wrote:
> 
> Seems like I can trigger this from paths other than truncate too.. (eg, sys_open)

O_TRUNC?

> The mask is always 0xa068 though if that helps.

A bit - it confirms what I thought - a truncate killing SUID bits.
i.e. mask = ATTR_FORCE|ATTR_KILL_SUID|ATTR_CTIME|ATTR_SIZE.

But then here's the next question - where the hell is the ATTR_MODE
bit?  In do_truncate(), the should_remove_suid() return is or'd into
the mask along with ATTR_FORCE. The ATTR_KILL_SUID is returned after
this check:

        umode_t mode = dentry->d_inode->i_mode;
        int kill = 0;

        /* suid always must be killed */
        if (unlikely(mode & S_ISUID))
                kill = ATTR_KILL_SUID;

However, notify_change() takes this mask and the inode and does this
when the ATTR_KILL_SUID flag is set:

	umode_t mode = inode->i_mode;
...
        if (ia_valid & ATTR_KILL_SUID) {
                if (mode & S_ISUID) {
                        ia_valid = attr->ia_valid |= ATTR_MODE;
                        attr->ia_mode = (inode->i_mode & ~S_ISUID);
                }
        }


So, we know that (mode & S_ISUID) is true, because that's how
ATTR_KILL_SUID gets set, but that same check here doesn't result
in ATTR_MODE being set....

That doesn't make a whole lot of sense to me. What am I missing?
Are you seeing this fire at all from notify_change()?

	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));

<Light Bulb>

What's wrong with this code in do_truncate()?

        /* Remove suid/sgid on truncate too */
        ret = should_remove_suid(dentry);
        if (ret)
                newattrs.ia_valid |= ret | ATTR_FORCE;

        mutex_lock(&dentry->d_inode->i_mutex);
        ret = notify_change(dentry, &newattrs);
        mutex_unlock(&dentry->d_inode->i_mutex);

Patch below to fix this.

However, it probably doesn't fix the fact that truncate can change
the size and kill suid/sgid bits at the same time and XFS doesn't
appear to handle that sanely right now. Can you run the patch below
just so when it fails we can see that the mask is actually sane?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

vfs: do_truncate() needs to serialise should_remove_suid

From: Dave Chinner <dchinner@redhat.com>

Otherwise someone else can come in an remove the suid bit before the
truncate locks the inode and calls notify_change(). This results in
XFS throwing asserts because it's getting a strange attr mask being
passed down to it that it doesn't know how to handle correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
 fs/open.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 8c74100..b8d4899 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -52,11 +52,11 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	}
 
 	/* Remove suid/sgid on truncate too */
+	mutex_lock(&dentry->d_inode->i_mutex);
 	ret = should_remove_suid(dentry);
 	if (ret)
 		newattrs.ia_valid |= ret | ATTR_FORCE;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
 	ret = notify_change(dentry, &newattrs);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return ret;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
