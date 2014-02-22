Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3B0C7F82
	for <xfs@oss.sgi.com>; Sat, 22 Feb 2014 08:06:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85581304081
	for <xfs@oss.sgi.com>; Sat, 22 Feb 2014 06:06:34 -0800 (PST)
Date: Sat, 22 Feb 2014 09:06:25 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v5 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
Message-ID: <20140222140625.GD26637@thunk.org>
References: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, mtk.manpages@gmail.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk

On Wed, Feb 19, 2014 at 01:37:43AM +0900, Namjae Jeon wrote:
> +	/*
> +	 * There is no need to overlap collapse range with EOF, in which case
> +	 * it is effectively a truncate operation
> +	 */
> +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> +	    (offset + len >= i_size_read(inode)))
> +		return -EINVAL;
> +

I wonder if we should just translate a collapse range that is
equivalent to a truncate operation to, in fact, be a truncate
operation?

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
