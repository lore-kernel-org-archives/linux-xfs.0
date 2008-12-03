Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3MCVgC023171 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 16:12:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 469921687758
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 14:12:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GNVFBOfm9aWZLiGQ for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 14:12:31 -0800 (PST)
Date: Wed, 3 Dec 2008 17:07:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.27.7 vanilla, project quota enabled and process stuck in D
	state (repeatable every time)
Message-ID: <20081203220724.GA13974@infradead.org>
References: <200812021949.55463.arekm@maven.pl>
	<200812031406.41882.arekm@maven.pl>
	<20081203213028.GW18236@disturbed>
	<200812032242.29326.arekm@maven.pl>
MIME-Version: 1.0
In-Reply-To: <200812032242.29326.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0734117583577283293=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

--===============0734117583577283293==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Dec 03, 2008 at 10:42:29PM +0100, Arkadiusz Miskiewicz wrote:
> [arekm@farm rpm]$ touch /home/users/arekm/tmp/aa
> [arekm@farm rpm]$ ./a.out
> ret=-1 Invalid cross-device link

That is btw, intentionåand expected.  To make the hierachial quotas
work renames between different projects or from/to no project at all
are not allowed.

> [arekm@farm rpm]$ ./a.out
> 
> second run hangs with D-state. 
> 
> For clarification, rpm and tmp directories are on the same 
> filesystem/partition (hda2), rpm/ dir belongs to project quota id=10, tmp 
> doesn't belong to any project quota.
> 
> For the rest of your questions -  Christoph promised to look at the issue 
> today, so I'll wait until tomorrow and if the issue will still be a mystery 
> then I'll dig out all data you asked for.

I tried to run your testcase, adopted to local paths and I can run it a
couple hundred times.  Then I get a hard lockup of my KVM virtual
machine..


--===============0734117583577283293==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0734117583577283293==--
