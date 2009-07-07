Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67BaXNW142072 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 06:36:34 -0500
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
References: <4A4D26C5.9070606@redhat.com>
	<bzyd48cc14d.fsf@fransum.emea.sgi.com>
	<20090707101946.GB1934@infradead.org>
From: Olaf Weber <olaf@sgi.com>
Date: Tue, 07 Jul 2009 13:37:05 +0200
In-Reply-To: <20090707101946.GB1934@infradead.org> (Christoph Hellwig's
	message of "Tue, 7 Jul 2009 06:19:46 -0400")
Message-ID: <bzy8wj0bu72.fsf@fransum.emea.sgi.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs mailing list <xfs@oss.sgi.com>, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>, linux-mm@kvack.org

Christoph Hellwig writes:
> On Tue, Jul 07, 2009 at 11:07:30AM +0200, Olaf Weber wrote:

>> If the nr_to_write calculation really yields a value that is too
>> small, shouldn't it be fixed elsewhere?

> In theory it should.  But given the amazing feedback of the VM people
> on this I'd rather make sure we do get the full HW bandwith on large
> arrays instead of sucking badly and not just wait forever.

So how do you feel about making the fudge factor tunable?  I don't
have a good sense myself of what the value should be, whether the
hard-coded 4 is good enough in general.

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
