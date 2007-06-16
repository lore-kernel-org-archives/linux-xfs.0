Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Jun 2007 12:00:48 -0700 (PDT)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.233.200])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5GJ0fWt001130
	for <xfs@oss.sgi.com>; Sat, 16 Jun 2007 12:00:42 -0700
Date: Sat, 16 Jun 2007 22:17:51 +0400
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: iov_iter_fault_in_readable fix
Message-ID: <20070616181751.GE14349@localhost.sw.ru>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru> <20070614173153.GA14771@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614173153.GA14771@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 18:31 Чтв 14 Июн     , Christoph Hellwig wrote:
> On Wed, Jun 13, 2007 at 05:57:59PM +0400, Dmitriy Monakhov wrote:
> >  	Function prerform check for signgle region, with out respect to
> >  	segment nature of iovec, For example writev no longer works :)
> 
> Btw, could someone please start to collect all sniplets like this in
> a nice simple regression test suite?  If no one wants to start a new
> one we should probably just put it into xfsqa (which should be useable
> for other filesystems aswell despite the name)
I've prepared testcase (testcases/kernel/syscalls/writev/writev06.c) 
and sent it to ltp mailing list.
