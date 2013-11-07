Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7113A7FE2
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 12:14:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 50FB18F8039
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 10:14:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NJZy4rarfhmoBT1E for
	<xfs@oss.sgi.com>; Thu, 07 Nov 2013 10:13:59 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rA7IDwjD012312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 7 Nov 2013 13:13:58 -0500
Received: from orion.maiolino.org (ovpn-113-27.phx2.redhat.com [10.3.113.27])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id rA7IDslR016612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 7 Nov 2013 13:13:57 -0500
Date: Thu, 7 Nov 2013 16:13:54 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests: posix_memalign and io_submit do not set errno
Message-ID: <20131107181353.GA24167@orion.maiolino.org>
References: <20131107170045.GA6599@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107170045.GA6599@infradead.org>
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
To: xfs@oss.sgi.com

Looks good to me, consider it
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


On Thu, Nov 07, 2013 at 09:00:45AM -0800, Christoph Hellwig wrote:
> posix_memalign and io_submit do not set errno, but rather return the
> error respectively the negated error directly.
> 
> Found this out while figuring out why 240 reported an impossible error
> from io_submit when run on NFS.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
