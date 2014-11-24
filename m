Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 503D67F69
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 11:18:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1BC0AC006
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 09:18:27 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 5j1fwPvhgCGWYncu (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 09:18:24 -0800 (PST)
Date: Mon, 24 Nov 2014 12:10:54 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v2 3/5] vfs: don't let the dirty time inodes get more
	than a day stale
Message-ID: <20141124171054.GB31339@thunk.org>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
	<1416675267-2191-4-git-send-email-tytso@mit.edu>
	<87egss3hsm.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87egss3hsm.fsf@rasmusvillemoes.dk>
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
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 01:27:21PM +0100, Rasmus Villemoes wrote:
> On Sat, Nov 22 2014, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > Guarantee that the on-disk timestamps will be no more than 24 hours
> > stale.
> >
> > +	unsigned short days_since_boot = jiffies / (HZ * 86400);
> 
> This seems to wrap every 49 days (assuming 32 bit jiffies and HZ==1000),
> so on-disk updates can be delayed indefinitely, assuming just the right
> delays between writes.

Good point, I'll fix this.

> Would it make sense to introduce days_since_boot as a global variable
> and avoid these issues? This would presumably also make update_time a
> few cycles faster (avoiding a division-by-constant), but not sure if
> that's important. And something of course needs to update
> days_since_boot, but that should be doable.

I can do this fairly simply like this:

	get_monotonic_boottime(&uptime);
	daycode = uptime.tv_sec / (HZ * 86400);

and we only need to do this if lazytime is set, and the inode isn't
marked as I_DIRTY_TIME:

	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
	    !(flags & S_VERSION)) {
		if (inode->i_state & I_DIRTY_TIME)
			return 0;
		get_monotonic_boottime(&uptime);
		daycode = do_div64(uptime.tv_sec do_div, (HZ * 86400));
		if (!inode->i_ts_dirty_day ||
		    inode->i_ts_dirty_day == daycode) {
			spin_lock(&inode->i_lock);
			inode->i_state |= I_DIRTY_TIME;
			spin_unlock(&inode->i_lock);
			inode->i_ts_dirty_day = daycode;
			return 0;
		}
	}

So I'm not entirely sure it's worth it to create a global variable for
days since boot; I've been runnin with this patch in my laptop, we
wouldn't be triggering the get_monotonic_bootime() function all that
often.  (Since once the dirty_time flg is set, we don't need to check
about whether we need to set it again.)  And if we *did* care, it
would be simple enough to use a static counter which only recalculates
daycode every 30 or 60 minutes.


Cheers,

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
