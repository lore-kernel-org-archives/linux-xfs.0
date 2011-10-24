Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9OCSkUS074967 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 07:28:46 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DAD116C416F
	for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 05:28:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wWc8leRMvCdrKhXN for
	<xfs@oss.sgi.com>; Mon, 24 Oct 2011 05:28:45 -0700 (PDT)
Date: Mon, 24 Oct 2011 10:27:29 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfs_symlink problem? 3.1 after rc10
Message-ID: <20111024122729.GA4441@andromeda.usersys.redhat.com>
References: <201110241148.39772.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201110241148.39772.arekm@maven.pl>
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
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Cc: xfs@oss.sgi.com

> My 3.1 (after) rc10 crashed (there was no xfs changes after it afaik).
> 
> Could anyone verify that this isn't some nasty xfs problem since it's close to 
> final 3.1? Happened only once.
> 
> http://ixion.pld-linux.org/~arekm/IMG_6019.JPG
> 
> No quota was used, xfs on top of luks on top of ssd drive.

It looks to be caused by a general protection fault, and giving the place where this crashed
I would say this sounds like the bug I've fixed some days ago related with the size of the
symlinks.
I can be wrong though, and this is related with another problem. 

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
