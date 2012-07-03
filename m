Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q633xfO8049598 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 22:59:42 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kFOcFEsvsfLVKHMO for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 20:59:40 -0700 (PDT)
Date: Mon, 2 Jul 2012 23:59:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/3] block: add sysfs entry for discard_alignment
Message-ID: <20120703035924.GA6182@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
	<1341235225-27551-2-git-send-email-pbonzini@redhat.com>
	<20120703023442.GB3586@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703023442.GB3586@redhat.com>
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, hch@lst.de

On Mon, Jul 02 2012 at 10:34pm -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Jul 02, 2012 at 03:20:23PM +0200, Paolo Bonzini wrote:
> > The next patches will actually use the alignment, expose it in sysfs
> > for ease of debugging.
> > 
> 
> Don't we already have discard_alignment exported as device attribute.
> 
> /sys/block/<dev>/discard_alignment

Yes we do.  It is documented in Documentation/ABI/testing/sysfs-block

So this patch isn't needed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
