Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 019FD7F6C
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 03:53:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C884A8F8049
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 01:53:13 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id NF1ejGu5VYxcK46F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2015 01:53:11 -0700 (PDT)
Date: Thu, 18 Jun 2015 04:53:09 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <60223436.16408979.1434617589713.JavaMail.zimbra@redhat.com>
In-Reply-To: <5581CDF3.5030408@sandeen.net>
References: <551099978.15978267.1434551318983.JavaMail.zimbra@redhat.com>
	<5581CDF3.5030408@sandeen.net>
Subject: Re: mkfs: a possible bad
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Eric Sandeen" <sandeen@sandeen.net>
> To: "Jan Tulak" <jtulak@redhat.com>, xfs@oss.sgi.com
> Sent: Wednesday, June 17, 2015 9:43:47 PM
> Subject: Re: mkfs: a possible bad
> 
> On 6/17/15 9:28 AM, Jan Tulak wrote:
> > Hi, I'm looking into mkfs/xfs_mkfs.c and I wonder, is "if (xi.dbsize
> > > sectorsize)" correct? It is a check for: Warning: the data
> > subvolume sector size %u is less than the sector size reported by the
> > device (%u).
> > 
> > But psectorsize is assigned to sectorsize, not to xi.dbsize, so the
> > two values seems to be swapped in the condition (and as arguments of
> > the printf too). I think this gone without noticing because usually,
> > when creating a partition, the two values are the same. So even if
> > the condition is wrong, nothing happens. And when -bsize=X is passed,
> > then it is catched earlier and nothing happens again.
> > 
> > Only when I apply a patch that changes how mkfs acts when it gets a
> > file instead of a block device, I start to see the warning, although
> > physical sector size is 512 and block size is set to 4096. The
> > numbers are swapped in the warning too...
> > 
> > I tried to run ./check -g quick and it seems that the change breaks
> > nothing. 
> > 
> > Cheers, Jan
> 
> Hohum, xfs_mkfs.c is such spaghetti-code.  :)  Let me think through
> this as well:
> 
> Ok, we init sectorsize to XFS_MIN_SECTORSIZE at the top of main().
> 
> If we have cmdline args to specify sector size, we reset it there.
> 
> If not specified, we set it to the physical sector size advertised
> by the device.
> 
> And xi.dbsize is set in platform_findsizes, for a device it comes
> from BLKSSZGET, which gives us the logical sector size of the device.
> 
> So this test:
> 
>         if (xi.dbsize > sectorsize) {
>                 fprintf(stderr, _(
> "Warning: the data subvolume sector size %u is less than the sector size \n\
> reported by the device (%u).\n"),
>                         sectorsize, xi.dbsize);
>         }
> 
> is testing whether the logical sector size is greater than the physical
> sector size - which would indeed be a problem (logical is <= physical)

You write "logical is <= physical", but the text of the warning seems to be telling "it should be logical >= physical, but isn't." 
I initially thought it should be reversed, but now I'm not sure. Maybe the warning could use better words to avoid this confusing?
In which case, I have to go back to bug hunting and see what is causing the warning to me...

> 
> however, you are right that this does seem to be caught sooner:
> 
> # modprobe scsi_debug sector_size=4096 dev_size_mb=1024 op_blks=0
> # mkfs.xfs -s size=512 /dev/sdd
> illegal sector size 512; hw sector is 4096
> 
> If we're mkfs'ing a file, then platform_findsizes gives us either
> the sector size of the host filesystem (if it's an xfs filesystem),
> or 512 by default if that fails (other filesystems don't have that
> concept, or that ioctl interface).
> 
> But the same thing applies; if we're mkfsing an image on a 4k sector
> xfs fs, images hosted there should (probably) have 4k sectors as well.
> 
> So, I ... don't think I see a problem with the code as it stands.
> 
> What does your "patch that changes how mkfs acts when it gets a file"
> do?
> 
> -Eric
> 

I'm resurrecting this patch set for cleaning mkfs: http://oss.sgi.com/archives/xfs/2013-11/msg00847.html
The link is directly to the patch which changes detection and handling for files. I did some changes in it, but as a reference, it still works well. 


Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
