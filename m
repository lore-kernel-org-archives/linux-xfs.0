Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D8HTEs010679 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 03:17:29 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 47CcBkfoh6SIoA1l for
	<xfs@oss.sgi.com>; Fri, 13 Apr 2012 01:17:28 -0700 (PDT)
Date: Fri, 13 Apr 2012 09:17:25 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120413081725.GA3640@nsrc.org>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
	<CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
	<20120413071905.GA823@nsrc.org> <20120413075634.GD6734@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120413075634.GD6734@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: David Fuller <dfuller@epoch.com>, xfs@oss.sgi.com

On Fri, Apr 13, 2012 at 05:56:34PM +1000, Dave Chinner wrote:
> In some cases.
> 
> You can't just blindly assert that something is needed purely on
> the size of the filesystem.

Thanks, but then perhaps the XFS FAQ needs updating. It warns that you might
have compatibility problems with old clients (NFS) and inode64, but it
doesn't say "for some workloads inode32 may perform better than inode64 on
large filesystems".

Also, aren't these orthogonal features?

(1) "I want all my inode metadata stored at the front of the disk"

(2) "I want files in the same directory to be distributed between AGs, not
    stored in the same AG"

If there are not explicit knobs for these behaviours, then it seems almost
accidental that limiting yourself to 32-bit inode numbers causes them to
happen (an implementation artefact).

Finally, what happens if you have a filesystem smaller than 1TB? I imagine
that XFS will scale the agsize down so that you have multiple AGs, but will
still have 32-bit inode numbers - so you will get the same behaviour as
inode64 on a large filesystem.  What happens then if your workload requires
behaviour (1) and/or (2) above for optimal performance?

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
