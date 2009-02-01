Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n11Axljv174553 for <xfs@oss.sgi.com>; Sun, 1 Feb 2009 04:59:47 -0600
Date: Sun, 1 Feb 2009 11:59:04 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility
	with legacy xfs ioctls
In-Reply-To: <49857BEB.30404@panasas.com>
Message-ID: <Pine.LNX.4.64.0902011151180.20875@anakin>
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de>
	<20090130171423.f99c88d0.akpm@linux-foundation.org>
	<200901310248.42820.arnd@arndb.de> <49856FE6.8020601@panasas.com>
	<Pine.LNX.4.64.0902011104320.20875@anakin>
	<49857BEB.30404@panasas.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Arnd Bergmann <arnd@arndb.de>, mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org, hch@infradead.org, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Sun, 1 Feb 2009, Boaz Harrosh wrote:
> Geert Uytterhoeven wrote:
> > On Sun, 1 Feb 2009, Boaz Harrosh wrote:
> >> Arnd Bergmann wrote:
> >>> +struct space_resv {
> >>> +	__s16		l_type;
> >>> +	__s16		l_whence;
> >>> +	__s64		l_start;
> >>> +	__s64		l_len;		/* len == 0 means until end of file */
> >>> +	__s32		l_sysid;
> >>> +	__u32		l_pid;
> >>> +	__s32		l_pad[4];	/* reserve area			    */
> >>> +};
> >> What about telling the compiler exactly what you said above, just
> >> to be sure we all mean the same thing. (And as documentation for new
> >> comers):
> >>
> >> +struct space_resv_64 {
> >> +	__s16		l_type;
> >> +	__s16		l_whence;
> >> +	__u32		reserved;
> >> +	__s64		l_start;
> >> +	__s64		l_len;		/* len == 0 means until end of file */
> >> +	__s32		l_sysid;
> >> +	__u32		l_pid;
> >> +	__s32		l_pad[4];	/* reserve area			    */
> >> +} __packed;
> > 
> > Because the compiler will assume all fields are always unaligned and will use very
> > suboptimal code to access them?
> 
> This discussion comes up every once in a while. I'm using an old FC7 compiler
> (gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-27)) And tests show that when the layout
> of a structure is exactly the same the "__packed" on structure declarations does
> nothing. It only starts to affect when there are real differences in alignment.
> Also tests with gcc 3.4.x showed the same effect.
> 
> On previous discussions no one could come forward and say what compiler version
> breaks when __packed is applied on structure definition. I'm afraid your statement
> above is a myth.

FC7, targeting ia32? Sure, ia32 has no alignment restrictions.
Try e.g. MIPS.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
