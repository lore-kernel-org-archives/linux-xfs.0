Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R2DZSF008253 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 20:13:35 -0600
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBAEE18646E5
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 18:12:52 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by cuda.sgi.com with ESMTP id 54HQTq4SG5HfsG5u for
	<xfs@oss.sgi.com>; Mon, 26 Jan 2009 18:12:52 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id 19so3913973fgg.8
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 18:12:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497E6759.3060300@sandeen.net>
References: <b211fe280901261723h6dd1db69t9d24c8d6774b18bc@mail.gmail.com>
	<497E6759.3060300@sandeen.net>
Date: Tue, 27 Jan 2009 00:12:50 -0200
Message-ID: <b211fe280901261812g6677ef60j2f64f4b257d3990@mail.gmail.com>
Subject: Re: Disable journaling
From: Iuri Diniz <iuridiniz@gmail.com>
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hello Eric,

On Mon, Jan 26, 2009 at 11:46 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> > Is possible to disable journaling on XFS too?
>
> No, it's not right possible today.  There used to be a sort of config
> option that disabled journaling ages ago, but it's gone now.  Not sure
> it ever worked on Linux.
>
> Ext4 does have an option to disable journaling now, which is
> interesting.


Thanks for this information.


> If I ever have any time I'd like to see how hard it might
> be to allow a mount option to xfs to also make journaling a no-op.
>

I'm new on filesystems but, is there another useful reason for having XFS
with no journaling?

I know that a journaling filesystem will slightly degrade the write
performance because the extra write operation (the write on journaling).


>
> > Thanks in advance
> >
> > [1]
> http://www.phoronix.com/scan.php?page=article&item=ext4_benchmarks&num=4
>
> Fatally flawed article FWIW, their bonnie++ results are comically bad
> (you try deleting 8G files on ext3, see if you can do 200 per second)  I
> alerted them to the bonnie++ problems, and explained what they had done
> wrong in the results parsing, and although they link to my email, they
> leave the ridiculous graphs in place.  The iozone results may be better,
> but I'd be very inclined to do my own testing rather than use those
> results right now.


But about the sequential read tests, do you think that are ok?


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
