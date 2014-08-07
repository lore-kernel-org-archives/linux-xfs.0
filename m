Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E9A97F87
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 07:56:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AEACAC002
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 05:56:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id G9bTQMHI6jFexpI0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Aug 2014 05:56:27 -0700 (PDT)
Date: Thu, 7 Aug 2014 08:56:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_bmbt_rec_64 leading to wrong blocks
Message-ID: <20140807125623.GB53888@bfoster.bfoster>
References: <CACyNnZM8D4ZdOAvbXNoiRUAGh1uZF8=9Gy34qS2XH7QUVjiGsQ@mail.gmail.com>
	<20140806113447.GA14820@bfoster.bfoster>
	<CACyNnZNwCPw8dsyRKSty7GPp4DxAd7ycHuztsC-VAdGEmjdnyw@mail.gmail.com>
	<20140806142329.GA39990@bfoster.bfoster>
	<CACyNnZM7FB464+T22xkEvCKBkY6syixGJzsAGwHWsQOZnUpd_g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACyNnZM7FB464+T22xkEvCKBkY6syixGJzsAGwHWsQOZnUpd_g@mail.gmail.com>
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
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 07, 2014 at 01:51:01PM +0200, Felipe Monteiro de Carvalho wrote:
> Hello,
> 
> Thanks, that worked perfectly =)
> 
> My actual idea is to not only read the partition, but to also recover
> deleted/corrupted files. With the information that you provided I
> advanced a lot in this direction, and I can now recover the file
> information in that memory area completely. I can also obtain the
> inode nr (well 4 bytes of it are preserved, but its better then
> nothing), but my current problem is with the inode itself. In a
> deleted file the following changes are done by the linux driver in the
> inode:
> 
> xfs_dinode_core_t.di_mode was changed to zero
> xfs_dinode_core_t.di_format was changed from 1 (local) to 2 (extent)
> 

These are set in xfs_ifree() when the inode is pulled from the unlinked
list and ultimately freed. Resetting these values certainly makes sense,
but I'm not aware of the reason why di_format is set as such.

> But di_mode in particular is a key element as I am using it to
> differentiate files from directories.
> 

In general you can't rely on on-disk data once the inode has been freed.
Perhaps you should start a new thread with some kind of write up about
what you're trying to accomplish and how you're going about it.

Brian

> Is there anything else what I can use to differentiate files from
> directories in case di_mode was corrupted? I am searching here but so
> far I didn't find anything...
> 
> thanks,
> -- 
> Felipe Monteiro de Carvalho
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
