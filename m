Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RAx1Vn163474 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 04:59:01 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	00zl39dcsWf7MU7e (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 02:59:00 -0800 (PST)
Date: Fri, 27 Jan 2012 05:58:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS problem
Message-ID: <20120127105859.GC23335@infradead.org>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
	<20120124213936.GA1505@infradead.org>
	<CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
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
To: Kelbel Junior <jymmyjr@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jan 26, 2012 at 01:57:34PM -0200, Kelbel Junior wrote:
> Well, in 24/01 i upgrade to the kernel 3.2.1 in one server and forgot
> read my emails...until now it's running without problems.
> Then, yesterday i put kernel 3.2.1 on another server and this morning
> a several same messages "server013 kernel: XFS: possible memory
> allocation deadlock in kmem_alloc (mode:0x250)" and delays.
> 
> (without call trace because i forgot to apply that patch with dump_stack)

Not a problem, we know where it comes from now.

> I work in a cache solution company, so I/O performance is very
> important in our context.

What I'm really curious about is what kind of workloads you have.  We
should only run into problems here if we have a huge extent indirection
array, which points to a massively fragmented file.  Right now the
handling of that isn't optimal, and we need to improve on that.  But
you'd probably get better results by avoiding that massive fragmentaion
in the first place, e.g. try to preallocate or set extent size hints
if you do random writes to a sparse file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
