Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67EjSBv149558 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 09:45:28 -0500
Date: Tue, 7 Jul 2009 10:46:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
Message-ID: <20090707144601.GA705@infradead.org>
References: <4A4D26C5.9070606@redhat.com>
	<bzyd48cc14d.fsf@fransum.emea.sgi.com>
	<20090707101946.GB1934@infradead.org>
	<bzy8wj0bu72.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bzy8wj0bu72.fsf@fransum.emea.sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs mailing list <xfs@oss.sgi.com>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, linux-mm@kvack.org

On Tue, Jul 07, 2009 at 01:37:05PM +0200, Olaf Weber wrote:
> > In theory it should.  But given the amazing feedback of the VM people
> > on this I'd rather make sure we do get the full HW bandwith on large
> > arrays instead of sucking badly and not just wait forever.
> 
> So how do you feel about making the fudge factor tunable?  I don't
> have a good sense myself of what the value should be, whether the
> hard-coded 4 is good enough in general.

A tunable means exposing an ABI, which I'd rather not do for a hack like
this.  If you don't like the number feel free to experiment around with
it, SGI should have enough large systems that can be used to test this
out.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
