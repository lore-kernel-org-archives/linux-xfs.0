Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B79E67CBF
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 10:11:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A125F8F8037
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 08:11:27 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id EX0YJDPlAcfxQVEL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jul 2015 08:11:23 -0700 (PDT)
Date: Tue, 7 Jul 2015 11:10:58 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150703151904.GA13839@infradead.org>
References: <1629704668.22787354.1435832837879.JavaMail.zimbra@redhat.com>
	<1435833796-24004-1-git-send-email-jtulak@redhat.com>
	<20150703151904.GA13839@infradead.org>
Subject: Re: [PATCH v2] xfsprogs: blkid is now mandatory
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
To: Christoph Hellwig <hch@infradead.org>
Cc: sandeen@redhat.com, xfs@oss.sgi.com



----- Original Message -----
> From: "Christoph Hellwig" <hch@infradead.org>
> 
> Can you wrap your commit description lines after ~ 75 characters,
> please?
>
Sure. I changed it to ~ 68 by Dave's suggestion.

> 
> > +AC_HAVE_BLKID_TOPO(yes)
> 
> I don't think we'll need an unused argument for AC_HAVE_BLKID_TOPO.

Fixed.

> 
> > -Mac OS X Instructions
> > -=====================
> 
> Why do you remove this section?
> 

I shouldn't put it into this patch but a standalone one: I tried to build the current version of XFS on OS X (10.10 Yosemite), but so far without a success. (I got to some errors in #defines where I thought I have better things to do.) Neither Macports, nor Homebrew [*] seems to ships XFS... Essentially, even if our docs contain a howto for OS X, it is not working and it looks like no one is using it. So I found this section ready for discarding. :-)

Regarding OS X and blkid... Macports contains util-linux with libblkid, so the new dependency shouldn't be breaking the possibility to port it, if anyone wants to try it...

[*] Macports and Hombrew - two biggest (AFAIK the only ones who are widely used) software repositories for OS X in Linux/BSD style. Macports are basically a port of BSD's Port.

> >  
> >  default: depend $(LTCOMMAND)
> >  
> > -ifneq ($(ENABLE_BLKID),yes)
> > -default: $(FSTYP)
> > -endif
> > -
> >  include $(BUILDRULES)
> >  
> > -$(FSTYP):
> > -	@echo "    [CC]     $@"
> > -	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
> > -
> 
> 
> Please remove fstyp.c  and the definition of FSTYP in the Makefile as well.
> 

I assume fstyp.h should go too...

Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
