Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92D477F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 06:46:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C25BAC004
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 04:46:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id t928khS2zfvXLgdG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Oct 2014 04:46:10 -0700 (PDT)
Date: Thu, 30 Oct 2014 07:46:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfsprogs: ignore stripe geom if sunit or swidth ==
	physical sector size
Message-ID: <20141030114605.GA5914@bfoster.bfoster>
References: <544FD3E1.1060000@redhat.com>
	<20141029183721.GA4226@bfoster.laptop>
	<54513635.7050703@sandeen.net> <54515E4E.8010500@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54515E4E.8010500@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 29, 2014 at 04:38:22PM -0500, Stan Hoeppner wrote:
> On 10/29/2014 01:47 PM, Eric Sandeen wrote:
> > On 10/29/14 1:37 PM, Brian Foster wrote:
> >> On Tue, Oct 28, 2014 at 12:35:29PM -0500, Eric Sandeen wrote:
> >>> Today, this geometry:
> >>>
> >>> # modprobe scsi_debug  opt_blks=2048 dev_size_mb=2048
> >>> # blockdev --getpbsz --getss --getiomin --getioopt  /dev/sdd
> >>> 512
> >>> 512
> >>> 512
> >>> 1048576
> >>>
> >>> will result in a warning at mkfs time, like this:
> >>>
> >>> # mkfs.xfs -f -d su=64k,sw=12 -l su=64k /dev/sdd
> >>> mkfs.xfs: Specified data stripe width 1536 is not the same as the volume stripe width 2048
> >>>
> >>> because our geometry discovery thinks it looks like a
> >>> valid striping setup which the commandline is overriding. 
> >>> However, a stripe unit of 512 really isn't indicative of
> >>> a proper stripe geometry.
> >>>
> >>
> >> So the assumption is that the storage reports a non-physical block size
> >> for minimum and optimal I/O sizes for geometry detection. There was a
> >> real world scenario of this, right? Any idea of the configuration
> >> details (e.g., raid layout) that resulted in an increased optimal I/O
> >> size but not minimum I/O size?
> > 
> > Stan?  :)
> 
> Yeah, it was pretty much what you pasted sans the log su, and it was a
> device-mapper device:
> 
> # mkfs.xfs -d su=64k,sw=12 /dev/dm-0
> 

What kind of device is dm-0? I use linear devices regularly and I don't
see any special optimal I/O size reported:

# blockdev --getpbsz --getiomin --getioopt --getbsz /dev/mapper/test-scratch 
512
512
0
4096

Brian

> --
> Stan
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
