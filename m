Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2ONgcNd186281
	for <linux-xfs@oss.sgi.com>; Thu, 24 Mar 2011 18:42:39 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94B36B16F52
	for <linux-xfs@oss.sgi.com>; Thu, 24 Mar 2011 16:45:44 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [74.125.121.67]) by
	cuda.sgi.com with ESMTP id IN2xk7fYUA2CQDGc for
	<linux-xfs@oss.sgi.com>; Thu, 24 Mar 2011 16:45:44 -0700 (PDT)
Received: from kpbe14.cbf.corp.google.com (kpbe14.cbf.corp.google.com
	[172.25.105.78]) by smtp-out.google.com with ESMTP id p2ONjgXM007800
	for <linux-xfs@oss.sgi.com>; Thu, 24 Mar 2011 16:45:42 -0700
Received: from gxk8 (gxk8.prod.google.com [10.202.11.8])
	by kpbe14.cbf.corp.google.com with ESMTP id p2ONisaI013458
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Thu, 24 Mar 2011 16:45:41 -0700
Received: by gxk8 with SMTP id 8so224458gxk.9
	for <linux-xfs@oss.sgi.com>; Thu, 24 Mar 2011 16:45:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110324174311.GA31576@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
Date: Thu, 24 Mar 2011 16:45:40 -0700
Message-ID: <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
From: Michel Lespinasse <walken@google.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Sean Noonan <Sean.Noonan@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, linux-mm@kvack.org

On Thu, Mar 24, 2011 at 10:43 AM, Christoph Hellwig <hch@infradead.org> wro=
te:
> Michel,
>
> can you take a look at this bug report? =A0It looks like a regression
> in your mlock handling changes.

I had a quick look and at this point I can describe how the patch will
affect behavior of this test, but not why this causes a deadlock with
xfs.

The test creates a writable, shared mapping of a file that does not
have data blocks allocated on disk, and also uses the MAP_POPULATE
flag.

Before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272, make_pages_present
during the mmap would cause data blocks to get allocated on disk with
an xfs_vm_page_mkwrite call, and then the file pages would get mapped
as writable ptes.

After 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272, make_pages_present
does NOT cause data blocks to get allocated on disk. Instead,
xfs_vm_readpages is called, which (I suppose) does not allocate the
data blocks and returns zero filled pages instead, which get mapped as
readonly ptes. Later, the test tries writing into the mmap'ed block,
causing minor page faults, xfs_vm_page_mkwrite calls and data block
allocations to occur.


Regarding the deadlock: I am curious to see if it could be made to
happen before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272. Could you test
what happens if you remove the MAP_POPULATE flag from your mmap call,
and instead read all pages from userspace right after the mmap ? I
expect you would then be able to trigger the deadlock before
5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272.


This leaves the issue of the change of behavior for MAP_POPULATE on
ftruncated file holes. I'm not sure what to say there though, because
MAP_POPULATE is documented to cause file read-ahead (and it still does
after 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272), but that doesn't say
anything about block allocation.


Hope this helps,

-- =

Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
