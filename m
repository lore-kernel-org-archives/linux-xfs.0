Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 06:41:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9UDfgdw007818
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 06:41:44 -0700
Received: from hackers.mr.itd.umich.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EA091B6C89B
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 06:41:42 -0700 (PDT)
Received: from hackers.mr.itd.umich.edu (smtp.mail.umich.edu [141.211.14.81]) by cuda.sgi.com with ESMTP id 7vOZtDhcTmwNsbb6 for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 06:41:42 -0700 (PDT)
Date: Thu, 30 Oct 2008 09:41:18 -0400
From: Jim Rees <rees@umich.edu>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081030134118.GA31598@citi.umich.edu>
References: <20081029031645.GE4985@disturbed> <20081029091203.GA32545@infradead.org> <20081029092143.GA5953@wotan.suse.de> <20081029094417.GA21824@infradead.org> <20081029103029.GC5953@wotan.suse.de> <20081029122234.GE846@shareable.org> <490865E3.8070102@gmail.com> <1225292196.6448.263.camel@think.oraclecorp.com> <20081030021601.GF18041@wotan.suse.de> <4909ADE0.1060205@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4909ADE0.1060205@hp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: jim owens <jowens@hp.com>
Cc: Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>, Ric Wheeler <ricwheeler@gmail.com>, Jamie Lokier <jamie@shareable.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

jim owens wrote:

  AFAIK the fsync semantic comes from the days of dinosaurs,
  mainframes, and minicomputers... when a lot of operating
  systems had user-space libraries that buffered the I/O.
  On fsync(fd), the "fd2" data would still be in user-space.

User space buffering happens in stdio, which is above the system call
level.  It's been that way since fsync() was first introduced, and is still
that way today.
