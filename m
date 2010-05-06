Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46KX610130167 for <xfs@oss.sgi.com>; Thu, 6 May 2010 15:33:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B20E31778B
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 13:35:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IC44Fm77kNGZvLmz for
	<xfs@oss.sgi.com>; Thu, 06 May 2010 13:35:16 -0700 (PDT)
Date: Thu, 6 May 2010 16:35:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Question : Using libhandle from xfsprogs and xfs actions made
	"by handle"
Message-ID: <20100506203514.GA6854@infradead.org>
References: <4BE178B3.8030501@cea.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BE178B3.8030501@cea.fr>
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
To: DENIEL Philippe <philippe.deniel@CEA.FR>
Cc: xfs@oss.sgi.com

On Wed, May 05, 2010 at 03:54:59PM +0200, DENIEL Philippe wrote:
> When looking at XFS, I saw there was "open_by_handle" and  
> "path_to_handle" calls. This sounds very very good to me : this sounds  
> like kind of bridge to build a handle-based API to address XFS. But so  
> far, I am a bit stuck : for exporting XFS through my NFS server, I would  
> need to do "by handle" everything that can be done through POSIX calls,  
> open/read/write/close files, create files/directories/symlinks, erasing  
> or moving files... and so on. I do not know if this is possible with the  
> calls in libhandle.so. But if I had such handle based tools, I think I  
> could make a nice NFS server on top of XFS (I did this kind of port for  
> LUSTRE (which has a full handle based API) in my NFS server and I had  
> really good performances). Can someone provide me with information about  
> this ?

For some reason the handle code currently rejects special files
(block/char/fifo) in open_by_handle.  I can't see any good reason for
that and plan to submit a patch to lift that restriction.  Except
for that libhandle is exactly what you want - there's various tools
that use it for that kind of work, the most prominent is
xfsdump/xfsrestore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
