Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C198D7CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 07:08:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9474F304039
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 05:08:10 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id j17aLgZxpjARa1dS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 05:08:07 -0700 (PDT)
Subject: Re: crash in xfs in current
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <75539b07-d05c-1516-26c1-2c4e2d42de1f@monom.org>
Date: Wed, 8 Jun 2016 14:08:02 +0200
MIME-Version: 1.0
In-Reply-To: <20160607134442.GA1803@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Reinoud Koornstra <reinoudkoornstra@gmail.com>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

> Thanks for testing this to both of you.  Can you try to build a kernel
> from git commit 555b67e4e729ca544bb4028ab12e532c68b70ddb - this is the
> XFS pull request that Dave sent to Linux for Linux 4.7-rc, so it has
> all the XFS changes relative to 4.6, but none of the others like the VFS
> changes.

For some reason, I can't reproduce it with 4.7-rc1 right now. still
trying...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
