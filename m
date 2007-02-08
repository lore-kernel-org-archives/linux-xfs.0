Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Feb 2007 06:45:57 -0800 (PST)
Received: from agminet02.oracle.com (agminet02.oracle.com [141.146.126.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l18Ejim7006792
	for <xfs@oss.sgi.com>; Thu, 8 Feb 2007 06:45:49 -0800
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by agminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l18DBYtc028880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 8 Feb 2007 07:11:34 -0600
Date: Thu, 8 Feb 2007 08:11:00 -0500
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1 of 2] Implement generic block_page_mkwrite() functionality
Message-ID: <20070208131100.GH11967@think.oraclecorp.com>
References: <20070207124922.GK44411608@melbourne.sgi.com> <Pine.LNX.4.64.0702071256530.25060@blonde.wat.veritas.com> <20070207144415.GN44411608@melbourne.sgi.com> <Pine.LNX.4.64.0702071454250.32223@blonde.wat.veritas.com> <20070207225013.GQ44411608@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207225013.GQ44411608@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Thu, Feb 08, 2007 at 09:50:13AM +1100, David Chinner wrote:
> > You don't need to lock out all truncation, but you do need to lock
> > out truncation of the page in question.  Instead of your i_size
> > checks, check page->mapping isn't NULL after the lock_page?
> 
> Yes, that can be done, but we still need to know if part of
> the page is beyond EOF for when we call block_commit_write()
> and mark buffers dirty. Hence we need to check the inode size.
> 
> I guess if we block the truncate with the page lock, then the
> inode size is not going to change until we unlock the page.
> If the inode size has already been changed but the page not yet
> removed from the mapping we'll be beyond EOF.
> 
> So it seems to me that we can get away with not using the i_mutex
> in the generic code here.

vmtruncate changes the inode size before waiting on any pages.  So,
i_size could change any time during page_mkwrite.

Since the patch does:
       if (((page->index + 1) << PAGE_CACHE_SHIFT) > i_size_read(inode))
               end = i_size_read(inode) & ~PAGE_CACHE_MASK;
       else
               end = PAGE_CACHE_SIZE;

It would be a good idea to read i_size once and put it in a local var
instead.

The FS truncate op should be locking the last page in the file to make
sure it is properly zero filled.  The worst case should be that we zero
too many bytes in page_mkwrite (expanding truncate past our current
i_size), but at least it won't expose stale data.

-chris
