Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB9Jrfd0232205 for <xfs@oss.sgi.com>; Fri, 9 Dec 2011 13:53:41 -0600
Received: from mga11.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 295E12B03E7
	for <xfs@oss.sgi.com>; Fri,  9 Dec 2011 11:53:38 -0800 (PST)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id SwxSnUP5Q09VxHGj for
	<xfs@oss.sgi.com>; Fri, 09 Dec 2011 11:53:38 -0800 (PST)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS causing stack overflow
References: <CAAnfqPAm559m-Bv8LkHARm7iBW5Kfs7NmjTFidmg-idhcOq4sQ@mail.gmail.com>
	<20111209115513.GA19994__23079.9863501035$1323435203$gmane$org@infradead.org>
Date: Fri, 09 Dec 2011 11:53:36 -0800
In-Reply-To: <20111209115513.GA19994__23079.9863501035$1323435203$gmane$org@infradead.org>
	(Christoph Hellwig's message of "Fri, 9 Dec 2011 06:55:13 -0500")
Message-ID: <m2aa71plmn.fsf@firstfloor.org>
MIME-Version: 1.0
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
Cc: linux-mm@kvack.org, xfs@oss.sgi.com, "Ryan C. England" <ryan.england@corvidtec.com>

Christoph Hellwig <hch@infradead.org> writes:
>
> You probably have only a third of the stack actually used by XFS, the
> rest is from NFSD/writeback code and page reclaim.  I don't think any
> of this is easily fixable in a 2.6.32 codebase.  Current mainline 3.2-rc
> now has the I/O-less balance dirty pages which will basically split the
> stack footprint in half, but it's an invasive change to the writeback
> code that isn't easily backportable.

An easy fix would be 16k stacks. Don't think they're that difficult
to do, but would need a special binary.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
