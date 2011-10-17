Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HE0Wmu002298 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 09:00:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8021147B5B5
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 07:08:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	mPL5dg0VXEOgEyQh for <xfs@oss.sgi.com>;
	Mon, 17 Oct 2011 07:08:20 -0700 (PDT)
Date: Mon, 17 Oct 2011 10:00:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
Message-ID: <20111017140030.GA19136@infradead.org>
References: <1318865412-4655-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318865412-4655-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

This generally good, but you'll need to fix formatting a bit
for both the mail body and the patch itself.

On Mon, Oct 17, 2011 at 01:30:12PM -0200, Carlos Maiolino wrote:
> Fixes a possible memory corruption when the link
> is larger than MAXPATHLEN and XFS_DEBUG is not
> enabled.
> This also uses S_IFLNK to check link not only
> in DEBUG mode.

Please try to fill up ~ 75 characters for each line in the mail body,
e.g.

Fix a possible memory corruption when a symlink target is larger than
MAXPATHLEN and XFS_DEBUG is not enabled.  Also use S_IFLNK to check
against disk corruption in di_mode for non-debug mode.

(I've also update the content a little bit).

> -	ASSERT(S_ISLNK(ip->i_d.di_mode));
> -	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
> +	if (!(S_ISLNK(ip->i_d.di_mode)) || !(ip->i_d.di_size <= MAXPATHLEN )){
> +
> +		xfs_emerg(mp, "inode (%lld), link too long or not a link",
> +			 (unsigned long long)ip->i_ino);
> +		ASSERT(0);
> +		return XFS_ERROR(EFSCORRUPTED);
> +	}

No need for the inner braces in both branches, but per kernel coding
style there should be one before the opening brace.  Also no spaces
before the closing round braces, please.  I also think it would be
cleanrer to split this into two checks, as it's two possible
corruptions, e.g.

	if (!S_ISLNK(ip->i_d.di_mode)) {
		xfs_emerg(mp, "inode (%lld) not a link in %s\n",
			  (unsigned long long)ip->i_ino), __func__);
		ASSERT(0);
		return XFS_ERROR(EFSCORRUPTED);
	}
	if (ip->i_d.di_size > MAXPATHLEN) {
		xfs_emerg(mp, "inode (%lld) larger than MAXPATHLEN in %s\n",
			  (unsigned long long)ip->i_ino), __func__);
		ASSERT(0);
		return XFS_ERROR(EFSCORRUPTED);
	}

It might also be useful to print the length in the second case as that
would help debugging potential corruptions. (e.g. single bit flips)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
