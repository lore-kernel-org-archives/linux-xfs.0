Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nALDGXTD027475 for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 07:16:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A24F1C00A85
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 05:16:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wof0YYVemZlIAA32 for
	<xfs@oss.sgi.com>; Sat, 21 Nov 2009 05:16:58 -0800 (PST)
Date: Sat, 21 Nov 2009 08:16:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS, NFS and inode64 on 2.6.27
Message-ID: <20091121131657.GA2095@infradead.org>
References: <200911201152.43809@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200911201152.43809@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Nov 20, 2009 at 11:52:43AM +0100, Michael Monnerie wrote:
> The shares "daten" and "dvd-images" can be mounted from other servers. I 
> simply went to the original dirs of this mount-bind, and created several 
> new dirs:
> mkdir 1 2 3 4 5 6 7 8 9
> and one of them had an inode < 2G, so I moved the contents there and 
> renamed the dirs, remounted the --bind mounts and now have this:

So your NFS exports are not the roots of their respsective filesystems?
This means NFSD uses non-standard filesystem IDs in the filehandles
which have to encode the inode number of the export root.  Your best
option is to simplify switch to exporting a whole filesystem,
alternatively you can try making sure NFSD uses the 16byte wide UUID
style export.  Note thast either way will only work with a 64bit kernel
as the fs has no say in encoding the filesystem part of the handle
and ino_t is always 32bit on 32bit platforms.  This will also affect
any other filesystem with 64bit inode numbers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
