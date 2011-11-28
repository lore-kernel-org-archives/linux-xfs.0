Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASB9h4h233103
	for <linux-xfs@oss.sgi.com>; Mon, 28 Nov 2011 05:09:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03F2916E1E35
	for <linux-xfs@oss.sgi.com>; Mon, 28 Nov 2011 03:09:42 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	j9PFc7eBkOCefKAq for <linux-xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 03:09:42 -0800 (PST)
Date: Mon, 28 Nov 2011 06:09:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111128110941.GE13766@infradead.org>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
	<20111121170459.GA1327@infradead.org>
	<CAJNJY8Ty+bQpzGL9wq7Qv3ozcKUPwmTyYUeb2wQqZ326K4JeWw@mail.gmail.com>
	<20111122221515.GA29540@infradead.org>
	<CAJNJY8Q3u6zZYHVdxnka160f+EC21JxoBe4EyKk=vDQgH4T19w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJNJY8Q3u6zZYHVdxnka160f+EC21JxoBe4EyKk=vDQgH4T19w@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Wed, Nov 23, 2011 at 09:19:26AM +0800, hank peng wrote:
> yes, I have already done that. I mount the expoted NFS directory in
> same machine(kernel version is 2.6.35.6), but it still didn't work.

Ok, sounds like this is a server side issue.

> 
> Then, I used fsid=$(my exported filesystem ID) option in /etc/exports
> and tried again, it still gave me back "stale NFS file handle" when
> entering a specific subdirectory.
> I noticed that from NFS client(in same machine with NFS server) side,
> the inode number of this subdirectory was changed to be within 32
> limit, but  still "stale NFS file handle" came back.

Do you mean the NFS mount displayed a 32-bit inode number, but it was still
64-bit on the XFS filesystem directly?  Can you post the inode numbers
(e.g. from ls -i) for both sides?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
