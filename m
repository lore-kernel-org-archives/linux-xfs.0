Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E93E07FA7
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 10:19:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9E248F8068
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 08:19:06 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id kQL0bCfABiUEkwtQ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 08:19:05 -0700 (PDT)
Date: Fri, 3 Jul 2015 08:19:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfsprogs: blkid is now mandatory
Message-ID: <20150703151904.GA13839@infradead.org>
References: <1629704668.22787354.1435832837879.JavaMail.zimbra@redhat.com>
	<1435833796-24004-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1435833796-24004-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, sandeen@redhat.com, xfs@oss.sgi.com

Thanks Jan!

On Thu, Jul 02, 2015 at 12:43:16PM +0200, Jan Tulak wrote:
> Because blkid is here for a long time, I hereby propose a patch for removing support
> for NOT having blkid. The current support through set of #ifdef is prone to errors like
> making a patch just in one of the branches, and according to a recent talk between
> Christoph and Eric, it is not necessary to keep it supported.
> 
> Remove code for checking ENABLE_BLKID, and the code when ENABLE_BLKID is not defined.
> The only use of libdisk was in the removed code, so remove libdisk too.
> It makes blkid required for compilation.

Can you wrap your commit description lines after ~ 75 characters,
please?

> +AC_HAVE_BLKID_TOPO(yes)

I don't think we'll need an unused argument for AC_HAVE_BLKID_TOPO.

> -Mac OS X Instructions
> -=====================

Why do you remove this section?

>  
>  default: depend $(LTCOMMAND)
>  
> -ifneq ($(ENABLE_BLKID),yes)
> -default: $(FSTYP)
> -endif
> -
>  include $(BUILDRULES)
>  
> -$(FSTYP):
> -	@echo "    [CC]     $@"
> -	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LIBDISK) $(PLDLIBS)
> -


Please remove fstyp.c  and the definition of FSTYP in the Makefile as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
