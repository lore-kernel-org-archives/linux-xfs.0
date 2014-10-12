Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0AF387F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 09:20:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77066AC003
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 07:20:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vBLQzyPOh37CYRBd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 07:20:12 -0700 (PDT)
Date: Sun, 12 Oct 2014 10:20:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Mount: Structure needs cleaning
Message-ID: <20141012142008.GB35667@bfoster.bfoster>
References: <1413103408756-35026.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413103408756-35026.post@n7.nabble.com>
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
To: tommason <tom_in_canada@hotmail.com>
Cc: xfs@oss.sgi.com

On Sun, Oct 12, 2014 at 01:43:28AM -0700, tommason wrote:
> Hi,
> 
> First up - my knowledge of linux is pretty sparse - I've used it a few times
> before, so please be gentle!
> 
> I've had a neil poulton network space for some time now - it freaked out a
> while ago and I managed to rig it up to a Ubuntu liveCD via a SATA dock and
> rescue the files.
> 
> This has now happened again - the drive would not get out of a cycle and was
> not spinning properly. Bring out the dock and liveCD (this time Knoppix).
> All good. This time however as I eagerly copied files to another drive (a
> USB powered lacie rugged thing) and left it overnight i woke up to an error.
> I was copying around 500GB in a few diffferent chunks. The first error it
> reported was I think error 15? mount structure needs cleaning...
> 

Logs? Kernel version? etc.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> I then tried with a Ubuntu liveCD - same error. This is maybe where I made a
> bit of an error of my own. In an attempt to shake it out of it's stupor I
> 'stupidly' plugged it into windows and opened up the disk utility (sorry I'm
> generally mac based) and deleted in total 5 partitions (3x8mb, 1x250odd mb &
> 1x600mbish partition) This left the partition that I assumed contained all
> my files: a 920GB partition. Tried to look at it again on Linux & (both
> Knoppix & Ubuntu) and the error message had changed slightly. It now reads:
> "Error mounting /dev/sdc2 at
> /media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd: Command-line `mount -t
> "xfs" -o "uhelper=udisks2,nodev,nosuid" "/dev/sdc2"
> "/media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd"' exited with non-zero
> exit status 32: mount: Structure needs cleaning"
> 

To be clear, you've deleted partitions other than the partition of
interest? I suppose that shouldn't effect things either way, but I'm not
really sure what the disk utility might do. It might be worth checking
whether 'file -s <device>' still identifies the partition as an XFS
filesystem..?

Beyond that, I'd suggest to capture and post the logs of the failed
mount and perhaps the output of 'xfs_repair -n <dev>.' This will attempt
a dry-run (e.g., no modifications) check and repair of the filesystem.

Brian

> This drive has all my audio and video stored on it! Any help to move me
> toward a solution would be much appreciated!
> 
> Thanks for your time...
> 
> Tom 
> 
> 
> 
> --
> View this message in context: http://xfs.9218.n7.nabble.com/Mount-Structure-needs-cleaning-tp35026.html
> Sent from the Xfs - General mailing list archive at Nabble.com.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
