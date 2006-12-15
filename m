Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Dec 2006 13:42:51 -0800 (PST)
Received: from coraid.com (ns1.coraid.com [65.14.39.133])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBFLgfqw010026
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 13:42:42 -0800
Date: Fri, 15 Dec 2006 16:37:03 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: Fw: [Bugme-new] [Bug 7662] New: AOE filesystem corruption on Alpha
Message-ID: <20061215213703.GN15592@coraid.com>
Reply-To: support@coraid.com
References: <20061209234305.c65b4e14.akpm@osdl.org> <20061214224826.GI10048@coraid.com> <20061215073905.GA31821@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061215073905.GA31821@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, support@coraid.com, Greg KH <greg@kroah.com>, boddingt@optusnet.com.au, xfs@oss.sgi.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Fri, Dec 15, 2006 at 07:39:05AM +0000, Christoph Hellwig wrote:
...
> It's a kmalloced page.  The same can happen with ext3 aswell, but only
> when doing log recovery.  The last time this came up (vs iscsi) the
> conclusion was that the driver needs to handle this case.  

I found this conversation:

  Subject: tcp_sendpage and page allocation lifetime vs. iscsi
  Date: 2005-04-25 17:02:59 GMT (1 year, 33 weeks, 2 days, 21 hours and 57 minutes ago)
  http://article.gmane.org/gmane.linux.kernel/298377  

Do you have another conversation in mind?

-- 
  Ed L Cashin <ecashin@coraid.com>
