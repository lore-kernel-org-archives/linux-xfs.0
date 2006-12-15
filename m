Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Dec 2006 00:05:54 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBF85iqw030947
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 00:05:46 -0800
Date: Fri, 15 Dec 2006 07:39:05 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 7662] New: AOE filesystem corruption on Alpha
Message-ID: <20061215073905.GA31821@infradead.org>
References: <20061209234305.c65b4e14.akpm@osdl.org> <20061214224826.GI10048@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061214224826.GI10048@coraid.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Andrew Morton <akpm@osdl.org>, support@coraid.com, Greg KH <greg@kroah.com>, boddingt@optusnet.com.au, xfs@oss.sgi.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Thu, Dec 14, 2006 at 05:48:26PM -0500, Ed L. Cashin wrote:
> ... and when using ext3 on the device.  However, we see problems when
> using XFS.  It appears that the XFS problem is unrelated, because the
> kernel's new lock debugging sees some problems that appear in the
> attached netconsole log.
> 
> XFS passes us a bio with a pointer to a page that has a reference
> count of zero which causes problems when __pskb_pull_tail does a put
> on the page.  With ext3, we only got pages with a reference count
> greater than zero.

It's a kmalloced page.  The same can happen with ext3 aswell, but only
when doing log recovery.  The last time this came up (vs iscsi) the
conclusion was that the driver needs to handle this case.  
