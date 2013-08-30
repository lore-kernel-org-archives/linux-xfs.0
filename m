Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72EA07F56
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 10:53:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FE388F8033
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 08:53:06 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id cAhtYFS3t9gEzdKI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Aug 2013 08:53:05 -0700 (PDT)
Date: Fri, 30 Aug 2013 16:53:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/2 v2] Fix O_SYNC AIO DIO
Message-ID: <20130830155301.GB13318@ZenIV.linux.org.uk>
References: <1376471456-11966-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1376471456-11966-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 14, 2013 at 11:10:54AM +0200, Jan Kara wrote:
>   Hello,
> 
>   this is second iteration of patches to fix handling of O_SYNC AIO DIO.
> Since previous version I've addressed Dave's comments:
>  - slightly expanded changelog of the first patch
>  - workqueue is now created with parameters allowing paralelism
>  - workqueue name contains sb->s_id
>  - workqueue is created on demand (I decided to do this to reduce the overhead
>    in unnecessary cases)
> 
> The patchset survives xfstests run for ext4 & xfs so it should be sane. Since
> this touches several filesystems (although only ext4 & xfs are non-trivial),
> the question is who should carry these patches. Maybe Al? But since xfs and
> ext4 changes are non-trivial, I'd like to have a review from their
> developers...

Looks sane, except that I'd probably put destroying the queue after
evict_inodes(), next to ->put_super() call.

Said that, there's another interesting problem in the code affected by that
sucker: generic_file_aio_write() might very well sync the wrong range.
Consider O_APPEND case; __generic_file_aio_write() will call
generic_write_checks(), which will update its copy of pos, and proceed to
write starting from there.  All right and proper, but then we return into
generic_file_aio_write() and sync the range of the right length, starting
at the *original* value of pos...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
