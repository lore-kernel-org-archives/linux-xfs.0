Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C97B7F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 16:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E78C8F8033
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 14:03:34 -0700 (PDT)
Date: Mon, 26 Aug 2013 22:03:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] xfs: don't leak root inode reference
Message-ID: <20130826210332.GF27005@ZenIV.linux.org.uk>
References: <20130826204730.GZ7153@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130826204730.GZ7153@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 26, 2013 at 03:47:30PM -0500, Ben Myers wrote:
> Looks like in 48fde701 we removed the iput of the root inode in
> xfs_fs_fill_super for the error case.  Add it back.
>  	if (is_bad_inode(root)) {
>  		error = EINVAL;
> -		goto out_unmount;
> +		goto out_iput;

This one makes sense

>  	}
>  	sb->s_root = d_make_root(root);
>  	if (!sb->s_root) {
>  		error = ENOMEM;
> -		goto out_unmount;
> +		goto out_iput;


... this one, OTOH, is simply wrong - take a look at what d_make_root()
does on failure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
