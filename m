Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63E10p9096072 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 09:01:00 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZR49LD0fS2XKPb4T for
	<xfs@oss.sgi.com>; Tue, 03 Jul 2012 07:00:59 -0700 (PDT)
Date: Tue, 3 Jul 2012 10:00:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] block: add sysfs entry for
	discard_alignment
Message-ID: <20120703140048.GC11272@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
	<1341235225-27551-2-git-send-email-pbonzini@redhat.com>
	<20120703023442.GB3586@redhat.com> <4FF2DCB1.2090704@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FF2DCB1.2090704@redhat.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de

On Tue, Jul 03, 2012 at 01:51:13PM +0200, Paolo Bonzini wrote:
> Il 03/07/2012 04:34, Vivek Goyal ha scritto:
> >> > The next patches will actually use the alignment, expose it in sysfs
> >> > for ease of debugging.
> >> > 
> > Don't we already have discard_alignment exported as device attribute.
> > 
> > /sys/block/<dev>/discard_alignment
> 
> Ah, interesting, I missed it completely.  I guess it's because queue/
> directories only exist for full disks, and the correct alignment varies
> for each partition.  So this patch is unnecessary.

Partition discard_alignments are available in
/sys/block/<disk>/<partition>/discard_alignment.

That raises an interesting question for patch3. If the discard is happening to
a partition, shouldn't you be looking at partition discard_alignment
instead of always looking at queue discard_alignment?

Thanks
Vivek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
