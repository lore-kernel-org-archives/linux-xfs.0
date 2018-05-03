Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49746 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbeECV4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 17:56:16 -0400
Date: Thu, 3 May 2018 14:55:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/9] xfs_info: call xfs_db for offline filesystems
Message-ID: <20180503215554.GE26569@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401958146.13048.3834702512829151272.stgit@magnolia>
 <e7dea090-ae58-d3d8-c9d0-33917e993d16@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7dea090-ae58-d3d8-c9d0-33917e993d16@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 04:22:24PM -0500, Eric Sandeen wrote:
> On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If the online filesystem geometry query doesn't work, try using xfs_db
> > to see if we can grab the information offline.
> > 
> 
> I'm slightly concerned that having all-singing, all-dancing tools
> that operate on mounted, unmounted, devices, mountpoints, and images
> will further encourage people to think that operations on mounted
> block devices are Just Fine(tm).

<nod> The current semantics of xfs_info are that one has to feed it a
mountpoint, which means the arg is a direct... oh dangit.

# touch mugga
# mount /bin/true mugga --bind
# xfs_info ./mugga 
meta-data=/dev/mapper/system-root isize=512    agcount=4, agsize=1953024 blks

Uh, ok, so the new behavior of xfs_info is that if you pass it a block
device or a file it'll try to call xfs_db (assuming it's a fs, fs image
file, or I guess future-dchinner subvolume); and if it's any other kind
of fs object it'll try spaceman (which requires a mountpoint arg).

Hopefully that's ok with Dave's subvol plans?

> But ... I suppose the convenience is worth it.
> 
> ...
> 
> > diff --git a/man/man8/xfs_info.8 b/man/man8/xfs_info.8
> > new file mode 100644
> > index 0000000..c4c470d
> > --- /dev/null
> > +++ b/man/man8/xfs_info.8
> > @@ -0,0 +1,95 @@
> > +.\" Verbatim blocks taken from openssl req manpage content
> > +.de Vb \" Begin verbatim text
> > +.ft CW
> > +.nf
> > +.ne \\$1
> > +..
> > +.de Ve \" End verbatim text
> > +.ft R
> > +.fi
> > +..
> > +
> > +.TH xfs_info 8
> > +.SH NAME
> > +xfs_info, \- display XFS filesystem geometry information
> 
> drop the comma pls, or I can do this.

I'll drop it in my patches, though if you don't find any serious
problems that warrant a reissue then you should do it.

> ...
> 
> > +.BR \-V .
> > +.SH "EXAMPLES"
> > +
> > +Understanding xfs_info output.
> > +.PP
> > +Suppose one has the following "xfs_info /dev/sda" output:
> > +.PP
> > +.RS 2
> > +.Vb
> > +\&meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
> > +\&         =              sectsz=512   attr=2
> > +\&data     =              bsize=4096   blocks=536869888, imaxpct=5
> > +\&         =              sunit=32     swidth=128 blks
> > +\&naming   =version 2     bsize=4096
> > +\&log      =internal log  bsize=4096   blocks=32768, version=2
> > +\&         =              sectsz=512   sunit=32 blks, lazy-count=1
> > +\&realtime =none          extsz=524288 blocks=0, rtextents=0
> > +.Ve
> 
> Should we update this to a more modern version?  *shrug*

Yeah probably.

--D

> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
