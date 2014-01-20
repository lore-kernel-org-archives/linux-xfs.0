Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA9F57F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 16:18:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DE90AC001
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 14:18:49 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aGKusylJNz7WzhX9 for <xfs@oss.sgi.com>;
	Mon, 20 Jan 2014 14:18:48 -0800 (PST)
Date: Tue, 21 Jan 2014 09:18:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
	environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Message-ID: <20140120221843.GJ18112@dastard>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
	<20140106201032.GA13491@quack.suse.cz>
	<20140107155830.GA28395@infradead.org>
	<CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
	<20140108140307.GA588@infradead.org>
	<CA+QCeVRuvNtZ8+9D-NtMOD=B9UEA5HMvKaGdXOQCjO-KTnZdbw@mail.gmail.com>
	<20140115220721.GY3469@dastard>
	<20140120135855.GA26280@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140120135855.GA26280@infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Gluk <git.user@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Sergey Meirovich <rathamahata@gmail.com>

On Mon, Jan 20, 2014 at 05:58:55AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 16, 2014 at 09:07:21AM +1100, Dave Chinner wrote:
> > Yes, I think it can be done relatively simply. We'd have to change
> > the code in xfs_file_aio_write_checks() to check whether EOF zeroing
> > was required rather than always taking an exclusive lock (for block
> > aligned IO at EOF sub-block zeroing isn't required),
> 
> That's not even required for supporting aio appends, just a further
> optimization for it.

Oh, right, I got an off-by-one when reading the code - the EOF
zeroing only occurs when the offset is beyond EOF, not at or beyond
EOF...

> > and then we'd
> > have to modify the direct IO code to set the is_async flag
> > appropriately. We'd probably need a new flag to say tell the DIO
> > code that AIO beyond EOF is OK, but that isn't hard to do....
> 
> Yep, need a flag to allow appending writes and then defer them.
> 
> > Christoph, are you going to get any time to look at doing this in
> > the next few days?
> 
> I'll probably need at least another week before I can get to it.  If you
> wanna pick it up before than feel free.

I'm probably not going to get to it before then, either, so check
back in a week?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
