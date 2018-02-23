Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43509 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbeBWKRa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Feb 2018 05:17:30 -0500
Date: Fri, 23 Feb 2018 10:17:37 +0000
From: Luis Henriques <lhenriques@suse.com>
Subject: Re: [PATCH v2 6/8] fsstress: implement the clonerange/deduperange
 ioctls
Message-ID: <20180223101737.hihkmeykjmqgjko7@hermes.olymp>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314503583.18893.15475795025536691678.stgit@magnolia>
 <20171215020731.GM6896@magnolia>
 <20180222160614.t2afwtdsouxliqie@hermes.olymp>
 <20180222172741.GD9827@magnolia>
 <20180222181731.jlddocrjlaaauaf3@hermes.olymp>
 <20180222183445.GG9827@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180222183445.GG9827@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Feb 22, 2018 at 10:34:45AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 22, 2018 at 06:17:31PM +0000, Luis Henriques wrote:
> > On Thu, Feb 22, 2018 at 09:27:41AM -0800, Darrick J. Wong wrote:
> > > On Thu, Feb 22, 2018 at 04:06:14PM +0000, Luis Henriques wrote:
> > > > On Thu, Dec 14, 2017 at 06:07:31PM -0800, Darrick J. Wong wrote:
> > > > 
> > > > <snip>
> > > > 
> > > > > +void
> > > > > +clonerange_f(
> > > > > +	int			opno,
> > > > > +	long			r)
> > > > > +{
> > > > 
> > > > <snip>
> > > > 
> > > > > +	/* Calculate offsets */
> > > > > +	len = (random() % FILELEN_MAX) + 1;
> > > > > +	len &= ~(stat1.st_blksize - 1);
> > > > > +	if (len == 0)
> > > > > +		len = stat1.st_blksize;
> > > > > +	if (len > stat1.st_size)
> > > > > +		len = stat1.st_size;
> > > > > +
> > > > > +	lr = ((__int64_t)random() << 32) + random();
> > > > > +	if (stat1.st_size == len)
> > > > > +		off1 = 0;
> > > > > +	else
> > > > > +		off1 = (off64_t)(lr % MIN(stat1.st_size - len, MAXFSIZE));
> > > > > +	off1 %= maxfsize;
> > > > > +	off1 &= ~(stat1.st_blksize - 1);
> > > > > +
> > > > > +	/*
> > > > > +	 * If srcfile == destfile, randomly generate destination ranges
> > > > > +	 * until we find one that doesn't overlap the source range.
> > > > > +	 */
> > > > > +	do {
> > > > > +		lr = ((__int64_t)random() << 32) + random();
> > > > > +		off2 = (off64_t)(lr % MIN(stat2.st_size + (1024 * 1024), MAXFSIZE));
> > > > > +		off2 %= maxfsize;
> > > > > +		off2 &= ~(stat2.st_blksize - 1);
> > > > > +	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
> > > > 
> > > > I started seeing hangs in generic/013 on cephfs.  After spending some
> > > > time looking, I found that this loops forever.  And the reason seems to
> > > > be that stat1.st_blksize is too big for this filesystem (4M) -- when
> > > > doing:
> > > 
> > > "Too big for this filesystem"?
> > > 
> > > Uh... maybe you'd better start by giving me more stat buffer info --
> > > what's st_size?
> > > 
> > > > 	off1 &= ~(stat1.st_blksize - 1);
> > > 
> > > These bits round the start offset down to block granularity, since clone
> > > range implementations generally require that the ranges align to block
> > > boundaries.
> > > 
> > > (Though AFAICT ceph doesn't support clone range anyway...)
> > > 
> > > So reading between the lines, is the problem here that ceph advertises a
> > > blocksize of 4M and fsstress calls clonerange_f with files that are
> > > smaller than 4M in size, so the only possible offsets with a 4M
> > > blocksize are zero and that's why we end up looping forever?
> > 
> > Brilliantly described!  That is *exactly* what I'm seeing and failed to
> > describe.  I guess I could use FSSTRESS_AVOID to work around this issue,
> > but there are probably better options.
> 
> Better to patch fsstress.c against this bug. :)
> 
> Does the following patch help?

Yes, it does.  Thanks!  Feel free to add my

Tested-by: Luis Henriques <lhenriques@suse.com>

Cheers,
--
Luís

> 
> --D
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 935f5de..e107099 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -2222,6 +2222,7 @@ clonerange_f(
>  	off64_t			lr;
>  	off64_t			off1;
>  	off64_t			off2;
> +	off64_t			max_off2;
>  	size_t			len;
>  	int			v1;
>  	int			v2;
> @@ -2305,9 +2306,10 @@ clonerange_f(
>  	 * If srcfile == destfile, randomly generate destination ranges
>  	 * until we find one that doesn't overlap the source range.
>  	 */
> +	max_off2 = MIN(stat2.st_size + (1024ULL * stat2.st_blksize), MAXFSIZE);
>  	do {
>  		lr = ((int64_t)random() << 32) + random();
> -		off2 = (off64_t)(lr % MIN(stat2.st_size + (1024 * 1024), MAXFSIZE));
> +		off2 = (off64_t)(lr % max_off2);
>  		off2 %= maxfsize;
>  		off2 &= ~(stat2.st_blksize - 1);
>  	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
> 
