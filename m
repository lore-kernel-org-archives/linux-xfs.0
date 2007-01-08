Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 05:08:57 -0800 (PST)
Received: from pne-smtpout4-sn2.hy.skanova.net (pne-smtpout4-sn2.hy.skanova.net [81.228.8.154])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08D8jqw003133
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 05:08:49 -0800
Received: from safari.iki.fi (80.223.106.128) by pne-smtpout4-sn2.hy.skanova.net (7.2.075)
        id 44A2EAB8008C1173 for xfs@oss.sgi.com; Mon, 8 Jan 2007 12:58:18 +0100
Date: Mon, 8 Jan 2007 13:58:17 +0200
From: Sami Farin <safari-xfs@safari.iki.fi>
Subject: Re: BUG: warning at mm/truncate.c:60/cancel_dirty_page()
Message-ID: <20070108115816.GB3803@m.safari.iki.fi>
References: <20070106023907.GA7766@m.safari.iki.fi> <Pine.LNX.4.64.0701062051570.24997@blonde.wat.veritas.com> <20070107222341.GT33919298@melbourne.sgi.com> <20070107144812.96357ff9.akpm@osdl.org> <20070107230436.GU33919298@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070107230436.GU33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>, Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>

On Mon, Jan 08, 2007 at 10:04:36 +1100, David Chinner wrote:
> On Sun, Jan 07, 2007 at 02:48:12PM -0800, Andrew Morton wrote:
> > On Mon, 8 Jan 2007 09:23:41 +1100
> > David Chinner <dgc@sgi.com> wrote:
> > 
> > > How are you supposed to invalidate a range of pages in a mapping for
> > > this case, then? invalidate_mapping_pages() would appear to be the
> > > candidate (the generic code uses this), but it _skips_ pages that
> > > are already mapped.
> > 
> > unmap_mapping_range()?
> 
> /me looks at how it's used in invalidate_inode_pages2_range() and
> decides it's easier not to call this directly.
> 
> > > So, am I correct in assuming we should be calling invalidate_inode_pages2_range()
> > > instead of truncate_inode_pages()?
> > 
> > That would be conventional.
> 
> .... in that case the following patch should fix the warning:

I tried dt+strace+cinfo with this patch applied and got no warnings.
Thanks for quick fix.

-- 
Do what you love because life is too short for anything else.
