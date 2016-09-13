Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E39AD7CA2
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 20:16:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ACA9F8F8033
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 18:16:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id wm5FuvZjZhom6GV7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Sep 2016 18:16:50 -0700 (PDT)
Date: Mon, 12 Sep 2016 18:16:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] vfs: cap dedupe request structure size at PAGE_SIZE
Message-ID: <20160913011620.GC23422@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
	<147216785429.525.1965983896010934181.stgit@birch.djwong.org>
	<20160905145549.GA7662@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160905145549.GA7662@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, torvalds@linux-foundation.org

On Mon, Sep 05, 2016 at 07:55:49AM -0700, Christoph Hellwig wrote:
> This really should go into 4.8 (and the previous patch probably as
> well), and I've said that a couple of times, and you tried a few times
> to send it to Al at least.
> 
> Al, do you want to pick it up or should Darrick send it straight to
> Linus?

Ping?  Anyone?

--D

> On Thu, Aug 25, 2016 at 04:30:54PM -0700, Darrick J. Wong wrote:
> > Kirill A. Shutemov reports that the kernel doesn't try to cap dest_count
> > in any way, and uses the number to allocate kernel memory.  This causes
> > high order allocation warnings in the kernel log if someone passes in a
> > big enough value.  We should clamp the allocation at PAGE_SIZE to avoid
> > stressing the VM.
> > 
> > The two existing users of the dedupe ioctl never send more than 120
> > requests, so we can safely clamp dest_range at PAGE_SIZE, because with
> > 4k pages we can handle up to 127 dedupe candidates.  Given the max
> > extent length of 16MB, we can end up doing 2GB of IO which is plenty.
> > 
> > Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/ioctl.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > 
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 26aba09..c415668 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -582,6 +582,10 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
> >  	}
> >  
> >  	size = offsetof(struct file_dedupe_range __user, info[count]);
> > +	if (size > PAGE_SIZE) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> >  
> >  	same = memdup_user(argp, size);
> >  	if (IS_ERR(same)) {
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
