Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UKikR6071449 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 15:44:46 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oJ5UcwJMsM6BYugp (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 13:46:36 -0700 (PDT)
Date: Tue, 30 Oct 2012 16:46:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121030204633.GA15361@infradead.org>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
	<20121029222613.GU29378@dastard>
	<CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Oct 30, 2012 at 09:37:06PM +0100, Torsten Kaiser wrote:
> On Mon, Oct 29, 2012 at 11:26 PM, Dave Chinner <david@fromorbit.com> wrote:

For some reason I only managed to get the two mails from Torsten into my
xfs list folder, but the one from Dave is missing.  I did see Dave's
mail in my linux-mm folder, though.

> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

And I agree that vmap needs to be fixed to pass through the gfp flags
ASAP.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
