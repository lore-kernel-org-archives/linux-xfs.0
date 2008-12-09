Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB9GvTWi002861 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 10:57:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B09F4385
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 08:57:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id D03fjpMx10tfZMlS for
	<xfs@oss.sgi.com>; Tue, 09 Dec 2008 08:57:29 -0800 (PST)
Date: Tue, 9 Dec 2008 11:57:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081209165728.GA18536@infradead.org>
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com> <492CA07F.1030803@sgi.com>
	<492CC201.3080304@xfs.org>
	<ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>
	<20081209091725.GA26180@infradead.org> <493E9AB4.1050505@xfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <493E9AB4.1050505@xfs.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 09, 2008 at 10:20:04AM -0600, Russell Cattelan wrote:
> The problem is that you have a tracking branch for xfs-dev so git wants 
> to leave your branch untouched
> until you actually want to update it from the remote branch origin/xfs-dev
> What you can do is:
> % git-fetch
> % git-pull . xfs-dev
> 
> That will pull the latest xfs-dev stuff into your current branch.

It might.  But remember more than a single command to update a
repository is just a braindead design.  Especially if I have to remember
a branch name.  Even CVS got this right..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
