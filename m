Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6JDxAEq018799 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 08:59:10 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eTV7xw6H9pWq5IcW for
	<xfs@oss.sgi.com>; Thu, 19 Jul 2012 06:59:09 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q6JDx9lJ029306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 09:59:09 -0400
Received: from andromeda.usersys.redhat.com (vpn1-5-8.gru2.redhat.com
	[10.97.5.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q6JDx0vX014447
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 09:59:06 -0400
Date: Thu, 19 Jul 2012 10:58:57 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Superblock restore takes too long
Message-ID: <20120719135857.GA30881@andromeda.usersys.redhat.com>
References: <5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6@ilmbx02.IL.NDS.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5C7FE4A5ADF52D46989166B4083DFF8F21ECE1C6@ilmbx02.IL.NDS.com>
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
To: xfs@oss.sgi.com

On Thu, Jul 19, 2012 at 09:30:59AM +0000, Zak, Semion wrote:
> Hi,
> 
> Corrupted Superblock restore takes too long because xfs_restore searches the
> disc for reserved Superblock.
> 
> Is it possible accelerate the search, for example by giving to xfs_restore some
> hint (reserved Superblock LBA)?
> 
Afaik there is no way to tell xfs_repair which superblock to use, but to be
honest how would you know which secondary superblock isn't corrupted? I can be
very wrong in this though


-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
