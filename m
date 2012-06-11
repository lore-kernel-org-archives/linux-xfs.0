Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BGL9GW113974 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 11:21:09 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gcDCAhmbsNEMI6mb for
	<xfs@oss.sgi.com>; Mon, 11 Jun 2012 09:21:08 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5BGL7da029882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 12:21:07 -0400
Received: from andromeda.usersys.redhat.com (vpn-9-5.rdu.redhat.com
	[10.11.9.5])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q5BGL39I019321
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 12:21:06 -0400
Date: Mon, 11 Jun 2012 13:21:03 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: block sizes > 4K ??  possible w/large page support?
Message-ID: <20120611162102.GB18432@andromeda.usersys.redhat.com>
References: <4FD5643F.5070801@tlinx.org>
	<20120611132932.GA18432@andromeda.usersys.redhat.com>
	<4FD606C1.1070103@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD606C1.1070103@hardwarefreak.com>
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

> > The maximum block size of a XFS filesystem is 64kiB. But in linux it's limited
> > to the PAGE_SIZE value. 
> 
> Correct.
> 
> > so, on x86 architectures, the maximum block size is
> > 4kiB.
> 
> Not entirely correct.  Since ~1996, 16 years ago, PPro and higher 32bit
> CPUs with PSE/PSE36 support pages of 4MB, or 2MB with PAE enabled.
> 
I know we can use hugepages with these sizes, but didn't know we can use this as
common usage. I tried to look at MM code and didn't find anything which would
make PAGE_SIZE greater than 4096 (at least in x86), but well, I'm not a MM
developer too.

> x86-64 CPUs in long mode also support a 2MB page size.  But the problem
> of internal fragmentation may outweigh the TLB and other benefits of
> these very large pages.  I'm not an MM dev so I can't elaborate further.
>  There may be other issues.
> 
> > although it could benefit from a 16kiB page size, you'll need to be running an
> > operating system which supports this page size value.
> 
> And AFAIK the kernel MM team doesn't have x86 2MB pages on their radar.
>  Or do they?
No clue, I'm not a MM developer too =/ maybe I can be someday :D

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
