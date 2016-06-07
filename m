Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DDF67CA0
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 08:44:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3D42D8F8040
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 06:44:48 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QPuedyCuUWIUfPum (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 06:44:45 -0700 (PDT)
Date: Tue, 7 Jun 2016 06:44:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: crash in xfs in current
Message-ID: <20160607134442.GA1803@infradead.org>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
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
To: Daniel Wagner <wagi@monom.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Reinoud Koornstra <reinoudkoornstra@gmail.com>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Jun 07, 2016 at 12:52:39PM +0200, Daniel Wagner wrote:
> >> I try to reproduce it on 4.6. My steps do not always trigger the crash.
> >> So I can't be really sure if 4.6 doesn't show it, it does not happen.
> > 
> > I have never been able to trigger this in 4.6 and it's my failsafe
> > reboot (4.6.0).
> > In 4.7-rc1 it's just a matter of time before I hit it.
> > I do a lot of transactions, using git, extraction of tar.xz etc normally.
> 
> This rings a bell. I though the lockperf tests triggered it. Before I
> compiled a new kernel I did a 'git checkout' step.

Thanks for testing this to both of you.  Can you try to build a kernel
from git commit 555b67e4e729ca544bb4028ab12e532c68b70ddb - this is the
XFS pull request that Dave sent to Linux for Linux 4.7-rc, so it has
all the XFS changes relative to 4.6, but none of the others like the VFS
changes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
