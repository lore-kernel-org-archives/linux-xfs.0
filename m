Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 15:35:02 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5EMYwWt008939
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 15:34:59 -0700
Date: Thu, 14 Jun 2007 23:34:48 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: iov_iter_fault_in_readable fix
Message-ID: <20070614223448.GA28420@infradead.org>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru> <20070614173153.GA14771@infradead.org> <20070614222109.GF86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614222109.GF86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jun 15, 2007 at 08:21:09AM +1000, David Chinner wrote:
> Yeah, it can run a subset of the tests on NFS and UDF filesystems as well and
> there are some specific UDF-only tests in it too.  I think the NFS test group
> is mostly generic tests that don't use or test specific XFS features.

Actually most testcases can run on any reasonable posixish filesystem, we
just need some glue to tell the testsuite it's actually okay.
