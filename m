Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67AJaBR138519 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 05:19:37 -0500
Date: Tue, 7 Jul 2009 06:19:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
Message-ID: <20090707101946.GB1934@infradead.org>
References: <4A4D26C5.9070606@redhat.com>
	<bzyd48cc14d.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bzyd48cc14d.fsf@fransum.emea.sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, linux-mm@kvack.org, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>, xfs mailing list <xfs@oss.sgi.com>

On Tue, Jul 07, 2009 at 11:07:30AM +0200, Olaf Weber wrote:
> If the nr_to_write calculation really yields a value that is too
> small, shouldn't it be fixed elsewhere?

In theory it should.  But given the amazing feedback of the VM people
on this I'd rather make sure we do get the full HW bandwith on large
arrays instead of sucking badly and not just wait forever.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
