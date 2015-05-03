Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 05A517F5E
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 04:18:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF9A28F804C
	for <xfs@oss.sgi.com>; Sun,  3 May 2015 02:18:33 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id QgjGZBGeD12zGdzH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 May 2015 02:18:32 -0700 (PDT)
Date: Sun, 3 May 2015 10:18:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: optimize inline symlink handling
Message-ID: <20150503091829.GR889@ZenIV.linux.org.uk>
References: <1430644433-26658-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430644433-26658-1-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, May 03, 2015 at 11:13:48AM +0200, Christoph Hellwig wrote:
> This series allows XFS to return a pointer to the inline symlink
> inside to the VFS instead of needing a kmalloc'ed copy.

Take a look at vfs.git#link_path_walk...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
