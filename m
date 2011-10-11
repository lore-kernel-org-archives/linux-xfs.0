Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BEDqZx005762 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 09:13:52 -0500
Received: from WA2EHSNDR001.bigfish.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC78B1BC18C
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 07:13:51 -0700 (PDT)
Received: from WA2EHSNDR001.bigfish.com (smtp-cpk.frontbridge.com
	[204.231.192.41]) by cuda.sgi.com with ESMTP id
	hCCwoenpdejYTby4 for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 07:13:51 -0700 (PDT)
Date: Tue, 11 Oct 2011 16:13:38 +0200
From: Anders Ossowicki <aowi@novozymes.com>
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Message-ID: <20111011141338.GA11808@otto.nzcorp.net>
References: <20111011091757.GA32589@otto.nzcorp.net>
	<20111011133448.GA10692@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111011133448.GA10692@infradead.org>
Reply-To: aowi@novozymes.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: aradford@gmail.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 11, 2011 at 03:34:48PM +0200, Christoph Hellwig wrote:
> This is core VM code, and operates purely on on-stack variables except
> for the page cache radix tree nodes / pages.  So this either could be a
> core VM bug that no one has noticed yet, or memory corruption.  Can you
> run memtest86 on the box?

Unfortunately not, as it is a production server. Pulling it out to memtest 256G
properly would take too long. But it seems unlikely to me that it should be
memory corruption. The machine has been running with the same (ecc) memory for
more than a year and neither the service processor nor the kernel (according to
dmesg) has caught anything before this. It would be a rare (though I admit not
impossible) coincidence if we got catastrophic, undetected memory corruption a
week after attaching a new raid controller with a new disk array.
-- 
Anders Ossowicki

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
