Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 839687F66
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:18:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CC9AAC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:18:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FNyfcnpJXvb9c9tf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 07:18:29 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:18:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] renameat2 syscall: check plain rename
Message-ID: <20140416141825.GA32449@infradead.org>
References: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
	<1397231517-4641-2-git-send-email-miklos@szeredi.hu>
	<20140414023020.GJ27694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414023020.GJ27694@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Miklos Szeredi <mszeredi@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Apr 14, 2014 at 12:30:20PM +1000, Dave Chinner wrote:
> IOWs, XFS is returning EEXIST rather than ENOTEMPTY for several of
> these rename tests. The rename man page says this about the errors:
> 
>        ENOTEMPTY or EEXIST
>               newpath is a nonempty directory, that is, contains
> 	      entries other than "." and "..".
> 
> Which implies that both errors are valid and so the test should pass
> in either case. Can you send a patch to handle these
> different-but-valid error returns?

I would much prefer if all Linux filesystems behaved uniformly here.

While EEXIST sounds much more logical to me in this case I suspect most
other filesystems have copy & pasted from ext2, and we should switch to
ENOTEMPTY as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
