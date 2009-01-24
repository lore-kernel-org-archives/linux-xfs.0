Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O0YILX236164 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 18:34:19 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7719185B528
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 16:33:33 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	9SmpFvlDGFxCRZfz for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2009 16:33:33 -0800 (PST)
Date: Sat, 24 Jan 2009 11:33:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange fragmentation in nearly empty filesystem
Message-ID: <20090124003329.GE32390@disturbed>
References: <20090123102130.GB8012@doctronic.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090123102130.GB8012@doctronic.de>
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
To: Carsten Oberscheid <oberscheid@doctronic.de>
Cc: xfs@oss.sgi.com

On Fri, Jan 23, 2009 at 11:21:30AM +0100, Carsten Oberscheid wrote:
> Hi there,
> 
> I am experiencing my XFS filesystem degrading over time in quite a
> strange and annoying way. Googling "XFS fragmenation" tells me either
> that this does not happen or to use xfs_fsr, which doesn't really help
> me anymore -- see below. I'd appreciate any help on this.
> 
> Background: I am using two VMware virtual machines on my Linux
> desktop. These virtual machines store images of their main memory in
> .vmem files, which are about half a gigabyte in size for each of my
> VMs. The .vmem files are created when starting the VM, written when
> suspending it and read when resuming. I prefer suspendig and resuming
> over shutting down and booting again, so with my VMs these files can
> have a lifetime of several weeks.

Oh, that's vmware being incredibly stupid about how they write
out the memory images. They only write pages that are allocated
and it's sparse file full of holes. Effectively this guarantees
file fragmentation over time as random holes are filled. For
example, a .vmem file on a recent VM I built:

$ xfs_bmap -vvp foo.vmem |grep hole |wc -l
675
$ xfs_bmap -vvp foo.vmem |grep -v hole |wc -l
885
$

Contains 675 holes and almost 900 real extents in a 512MB memory
image that has only 160MB of data blocks allocated.

In reality, this is a classic case of the application doing a "smart
optimisation" that looks good in the short term (i.e.  saves some
disk space), but that has very bad long term side effects (i.e.
guaranteed fragmentation of the file in the long term).

You might be able to pre-allocate the .vmem files after the file
is created with an xfs_io hack prior to it being badly fragmented;
that should avoid the worse case fragmentation caused by writing
randomly to a sparse file.

In summary, this is an application problem, not a filesystem
issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
