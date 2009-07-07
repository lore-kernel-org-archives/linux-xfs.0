Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6796xXZ134507 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 04:07:00 -0500
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
References: <4A4D26C5.9070606@redhat.com>
From: Olaf Weber <olaf@sgi.com>
Date: Tue, 07 Jul 2009 11:07:30 +0200
In-Reply-To: <4A4D26C5.9070606@redhat.com> (Eric Sandeen's message of "Thu,
	02 Jul 2009 16:29:41 -0500")
Message-ID: <bzyd48cc14d.fsf@fransum.emea.sgi.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen writes:

> Talking w/ someone who had a raid6 of 15 drives on an areca
> controller, he wondered why he could only get 300MB/s or so
> out of a streaming buffered write to xfs like so:

> dd if=/dev/zero of=/mnt/storage/10gbfile bs=128k count=81920
> 10737418240 bytes (11 GB) copied, 34.294 s, 313 MB/s

> when the same write directly to the device was going closer
> to 700MB/s...

> With the following change things get moving again for xfs:

> dd if=/dev/zero of=/mnt/storage/10gbfile bs=128k count=81920
> 10737418240 bytes (11 GB) copied, 16.2938 s, 659 MB/s

> Chris had sent out something similar at Christoph's suggestion,
> and Christoph reminded me of it, and I tested it a variant of
> it, and it seems to help shockingly well.

> Feels like a bandaid though; thoughts?  Other tests to do?

If the nr_to_write calculation really yields a value that is too
small, shouldn't it be fixed elsewhere?

Otherwise it might make sense to make the fudge factor tunable.

> +
> +	/*
> +	 *  VM calculation for nr_to_write seems off.  Bump it way
> +	 *  up, this gets simple streaming writes zippy again.
> +	 */
> +	wbc->nr_to_write *= 4;
> +

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
