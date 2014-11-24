Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 523397F6B
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 06:27:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2EDFAC003
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 04:27:25 -0800 (PST)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
	[209.85.217.176]) by cuda.sgi.com with ESMTP id
	kbGheNEFMmyao68Y (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 04:27:23 -0800 (PST)
Received: by mail-lb0-f176.google.com with SMTP id p9so6133449lbv.21
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 04:27:22 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH-v2 3/5] vfs: don't let the dirty time inodes get more than
	a day stale
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
	<1416675267-2191-4-git-send-email-tytso@mit.edu>
Date: Mon, 24 Nov 2014 13:27:21 +0100
In-Reply-To: <1416675267-2191-4-git-send-email-tytso@mit.edu> (Theodore Ts'o's
	message of "Sat, 22 Nov 2014 11:54:25 -0500")
Message-ID: <87egss3hsm.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Sat, Nov 22 2014, Theodore Ts'o <tytso@mit.edu> wrote:

> Guarantee that the on-disk timestamps will be no more than 24 hours
> stale.
>
>  static int update_time(struct inode *inode, struct timespec *time, int flags)
>  {
> +	unsigned short days_since_boot = jiffies / (HZ * 86400);
>  	int ret;
>

This seems to wrap every 49 days (assuming 32 bit jiffies and HZ==1000),
so on-disk updates can be delayed indefinitely, assuming just the right
delays between writes.

>  	if (inode->i_op->update_time) {
> @@ -1527,14 +1528,27 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
>  		if (flags & S_MTIME)
>  			inode->i_mtime = *time;
>  	}
> -	if (inode->i_sb->s_flags & MS_LAZYTIME) {
> +	/*
> +	 * If i_ts_dirty_day is zero, then either we have not deferred
> +	 * timestamp updates, or the system has been up for less than
> +	 * a day (so days_since_boot is zero), so we defer timestamp
> +	 * updates in that case and set the I_DIRTY_TIME flag.  If a
> +	 * day or more has passed, then i_ts_dirty_day will be
> +	 * different from days_since_boot, and then we should update
> +	 * the on-disk inode and then we can clear i_ts_dirty_day.
> +	 */

AFAICT days_since_boot is not actually 0 immediately after boot
due to 

#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

On 32 bit platforms, days_since_boot will be 0 shortly after, while on
64 bit it will always be >= 49. Not exactly sure how this affects the
above logic.

Would it make sense to introduce days_since_boot as a global variable
and avoid these issues? This would presumably also make update_time a
few cycles faster (avoiding a division-by-constant), but not sure if
that's important. And something of course needs to update
days_since_boot, but that should be doable.

Rasmus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
