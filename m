Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 730D37F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 08:58:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 509628F8052
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 06:58:06 -0800 (PST)
Received: from mail-lb0-f178.google.com (mail-lb0-f178.google.com
	[209.85.217.178]) by cuda.sgi.com with ESMTP id
	C8MaPAZ8RVyBuq8t (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 06:58:05 -0800 (PST)
Received: by mail-lb0-f178.google.com with SMTP id f15so731537lbj.23
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 06:58:03 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH-v3 3/6] vfs: don't let the dirty time inodes get more than
	a day stale
References: <1416893674-419-1-git-send-email-tytso@mit.edu>
	<1416893674-419-4-git-send-email-tytso@mit.edu>
Date: Tue, 25 Nov 2014 15:58:01 +0100
In-Reply-To: <1416893674-419-4-git-send-email-tytso@mit.edu> (Theodore Ts'o's
	message of "Tue, 25 Nov 2014 00:34:31 -0500")
Message-ID: <87ioi3iayu.fsf@rasmusvillemoes.dk>
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
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Tue, Nov 25 2014, Theodore Ts'o <tytso@mit.edu> wrote:

>  static int update_time(struct inode *inode, struct timespec *time, int flags)
>  {
> +	struct timespec uptime;
> +	unsigned short daycode;
>  	int ret;
>  
>  	if (inode->i_op->update_time) {
> @@ -1525,17 +1527,33 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
>  		if (flags & S_CTIME)
>  			inode->i_ctime = *time;
>  		if (flags & S_MTIME)
> -			inode->i_mtime = *time;
> +		inode->i_mtime = *time;
>  	}
> +	/*
> +	 * If i_ts_dirty_day is zero, then either we have not deferred
> +	 * timestamp updates, or the system has been up for less than
> +	 * a day (so days_since_boot is zero), so we defer timestamp
> +	 * updates in that case and set the I_DIRTY_TIME flag.  If a
> +	 * day or more has passed, then i_ts_dirty_day will be
> +	 * different from days_since_boot, and then we should update
> +	 * the on-disk inode and then we can clear i_ts_dirty_day.
> +	 */

I think days_since_boot was a lot clearer than daycode. In any case,
please make the comment and the code consistent.

>  	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
>  	    !(flags & S_VERSION)) {
>  		if (inode->i_state & I_DIRTY_TIME)
>  			return 0;
> -		spin_lock(&inode->i_lock);
> -		inode->i_state |= I_DIRTY_TIME;
> -		spin_unlock(&inode->i_lock);
> -		return 0;
> +		get_monotonic_boottime(&uptime);
> +		daycode = div_u64(uptime.tv_sec, (HZ * 86400));

You should probably divide by the number of seconds in a day, not the
number of jiffies in a day.

Isn't div_u64 mostly for when the divisor is not known at compile time?
Technically, "(u64)uptime.tv_sec / 86400" is of course a u64/u64 division,
but the compiler should see that the divisor is only 32 bits and hence
should be able to generate code which is at least as efficient as
whatever inline asm the arch provides for u64/u32 divisions.


Rasmus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
