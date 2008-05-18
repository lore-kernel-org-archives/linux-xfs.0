Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 06:20:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4IDKcRc032372
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:20:40 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14D947902A1
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:21:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id O8364EZOnIWew2YQ for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:21:27 -0700 (PDT)
Date: Sun, 18 May 2008 09:21:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080518132127.GA19006@infradead.org>
References: <20080516222755.3e557c00@galadriel.home> <20080518131855.GA1383@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080518131855.GA1383@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Sun, May 18, 2008 at 09:18:55AM -0400, Christoph Hellwig wrote:
> > The only significant thing I see is that the FS is really close to 16
> > TB of allocated data (15.7TB). I tried mounting it with "inode64"
> > option with no more loving.
> 
> Did you remount it with that option as in mount -o remount or did you
> completely unmount it and mount it again?  Unfortunately none of the
> xfs-specific mount options can be reset with remount yet, and it doesn't
> return an error either (both are added to my todo list now)

Oh, and please post the output of /proc/self/mounts to see if all
expected mount options are actualy seen by the filesystem.
