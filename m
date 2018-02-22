Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48662 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933210AbeBVR1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 12:27:49 -0500
Date: Thu, 22 Feb 2018 09:27:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 6/8] fsstress: implement the clonerange/deduperange
 ioctls
Message-ID: <20180222172741.GD9827@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314503583.18893.15475795025536691678.stgit@magnolia>
 <20171215020731.GM6896@magnolia>
 <20180222160614.t2afwtdsouxliqie@hermes.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180222160614.t2afwtdsouxliqie@hermes.olymp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Henriques <lhenriques@suse.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Feb 22, 2018 at 04:06:14PM +0000, Luis Henriques wrote:
> On Thu, Dec 14, 2017 at 06:07:31PM -0800, Darrick J. Wong wrote:
> 
> <snip>
> 
> > +void
> > +clonerange_f(
> > +	int			opno,
> > +	long			r)
> > +{
> 
> <snip>
> 
> > +	/* Calculate offsets */
> > +	len = (random() % FILELEN_MAX) + 1;
> > +	len &= ~(stat1.st_blksize - 1);
> > +	if (len == 0)
> > +		len = stat1.st_blksize;
> > +	if (len > stat1.st_size)
> > +		len = stat1.st_size;
> > +
> > +	lr = ((__int64_t)random() << 32) + random();
> > +	if (stat1.st_size == len)
> > +		off1 = 0;
> > +	else
> > +		off1 = (off64_t)(lr % MIN(stat1.st_size - len, MAXFSIZE));
> > +	off1 %= maxfsize;
> > +	off1 &= ~(stat1.st_blksize - 1);
> > +
> > +	/*
> > +	 * If srcfile == destfile, randomly generate destination ranges
> > +	 * until we find one that doesn't overlap the source range.
> > +	 */
> > +	do {
> > +		lr = ((__int64_t)random() << 32) + random();
> > +		off2 = (off64_t)(lr % MIN(stat2.st_size + (1024 * 1024), MAXFSIZE));
> > +		off2 %= maxfsize;
> > +		off2 &= ~(stat2.st_blksize - 1);
> > +	} while (stat1.st_ino == stat2.st_ino && llabs(off2 - off1) < len);
> 
> I started seeing hangs in generic/013 on cephfs.  After spending some
> time looking, I found that this loops forever.  And the reason seems to
> be that stat1.st_blksize is too big for this filesystem (4M) -- when
> doing:

"Too big for this filesystem"?

Uh... maybe you'd better start by giving me more stat buffer info --
what's st_size?

> 	off1 &= ~(stat1.st_blksize - 1);

These bits round the start offset down to block granularity, since clone
range implementations generally require that the ranges align to block
boundaries.

(Though AFAICT ceph doesn't support clone range anyway...)

So reading between the lines, is the problem here that ceph advertises a
blocksize of 4M and fsstress calls clonerange_f with files that are
smaller than 4M in size, so the only possible offsets with a 4M
blocksize are zero and that's why we end up looping forever?

--D

> 
> off1 (and off2) will both end up with 0.  Does this make sense?  Would
> something like:
> 
> -	off1 &= ~(stat1.st_blksize - 1);
> +	if (stat1.st_blksize <= stat1.st_size)
> +		off1 &= ~(stat1.st_blksize - 1);
> 
> be acceptable?  (and a similar change for off2, of course.)

> Cheers,
> --
> Luís
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
