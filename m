Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1433753AbdDZApy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 20:45:54 -0400
Date: Wed, 26 Apr 2017 02:45:28 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 08/12] mkfs: replace variables with opts table: -b,d,s
 options
Message-ID: <20170426004528.GP28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-9-jtulak@redhat.com>
 <20170425052721.GL28800@wotan.suse.de>
 <CACj3i73PnrUGRL+1zQtj=vgdih5ne3AZ8rnmNCn-zTmmnrV8EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73PnrUGRL+1zQtj=vgdih5ne3AZ8rnmNCn-zTmmnrV8EA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 10:37:57AM +0200, Jan Tulak wrote:
> On Tue, Apr 25, 2017 at 7:27 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Sun, Apr 23, 2017 at 08:54:59PM +0200, Jan Tulak wrote:
> >> Remove variables that can be replaced with a direct access to the opts table,
> >> so we have it all in a single place, acessible from anywhere.
> >>
> >> In future, we can remove some passing of values forth and back, but now limit
> >> the changes to simple replacement without a change in the logic.
> >
> > What do you mean passing of values here, as an example with bopts ?
> 
> Passing it to a function and then retrieving with pointers, e.g. change this
> 
> static void
> calc_stripe_factors(
>         int             dsu,
>         int             dsw,
>         int             dsectsz,
>         int             lsu,
>         int             lsectsz,
>         uint64_t        *dsunit,
>         uint64_t        *dswidth,
>         uint64_t        *lsunit)
> 
> 
> to this
> 
> static void
> calc_stripe_factors(struct opt_params * opts) // or no argument at all...

Ah, great, but note that not all options have a respective struct subopt_param,
that is -- we don't allow for them to be specified in the command line, but they
are rather collateral values, which depend on other struct subopt_param's. The
lsunit is one example. Its why I ended up just stuffing all of the needed parameters
into one data struct: struct mkfs_xfs_opts. Your patches round up direct
parameters associated with struct subopt_param on the struct opt_params.

Where would things like lsunit be stuffed into ?

> Which btw needs to be updated anyway because it is still using int...

Right I see.

> >> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >> index 362c9b4..6857c30 100644
> >> --- a/mkfs/xfs_mkfs.c
> >> +++ b/mkfs/xfs_mkfs.c
> >> @@ -1485,15 +1480,12 @@ main(
> >>       int                     argc,
> >>       char                    **argv)
> >>  {
> >> -     uint64_t                agcount;
> >>       xfs_agf_t               *agf;
> >>       xfs_agi_t               *agi;
> >>       xfs_agnumber_t          agno;
> >> -     uint64_t                agsize;
> >>       xfs_alloc_rec_t         *arec;
> >>       struct xfs_btree_block  *block;
> >>       bool                    blflag;
> >
> > Note: blflag
> >
> >> -     uint64_t                blocklog;
> >>       bool                    bsflag;
> >
> > Note: bsflag
> >
> >>       memset(&fsx, 0, sizeof(fsx));
> >> @@ -1629,6 +1613,7 @@ main(
> >>                       break;
> >>               case 'b':
> >>                       p = optarg;
> >> +                     uint64_t tmp;
> >>                       while (*p != '\0') {
> >>                               char    **subopts =
> >>                                               (char **)opts[OPT_B].subopts;
> >> @@ -1636,19 +1621,17 @@ main(
> >>
> >>                               switch (getsubopt(&p, subopts, &value)) {
> >>                               case B_LOG:
> >> -                                     blocklog = parse_conf_val(OPT_B, B_LOG,
> >> -                                                               value);
> >> -                                     blocksize = 1 << blocklog;
> >> +                                     tmp = parse_conf_val(OPT_B, B_LOG,
> >> +                                                          value);
> >> +                                     set_conf_val(OPT_B, B_SIZE, 1 << tmp);
> >>                                       blflag = 1;
> >
> > This is a collateral variable set when blog is set. If we have to parse the
> > blog again, it means similar code would be needed.
> >
> >> -                                     set_conf_val(OPT_B, B_SIZE, blocksize);
> >>                                       break;
> >>                               case B_SIZE:
> >> -                                     blocksize = parse_conf_val(OPT_B,
> >> -                                                                B_SIZE,
> >> -                                                                value);
> >> -                                     blocklog = libxfs_highbit32(blocksize);
> >> +                                     tmp = parse_conf_val(OPT_B, B_SIZE,
> >> +                                                          value);
> >> +                                     set_conf_val(OPT_B, B_LOG,
> >> +                                             libxfs_highbit32(tmp));
> >>                                       bsflag = 1;
> >
> > Likewise for bsflag.
> >
> >> -                                     set_conf_val(OPT_B, B_LOG, blocklog);
> >>                                       break;
> >>                               default:
> >>                                       unknown('b', value);
> >
> > What I'm questioning is whether or not it makes sense instead for parse_conf_val()
> > to return void and do all this meddling for us, this would require stuffing any
> > collateral variables into a struct and passing that to parse_conf_val and using
> > it on main() as well.
> 
> Again, this (both logic and flags) is something I want to do later.

Ah great.

> And in fact, I think that perhaps the whole manual loop in main() can
> be removed in the future once the case logic is moved elsewhere.
> Because then we can extract specific cases from the opts table with
> the help of some helper functions...

Nice yes that would be good.

OK, understood, just so its clear, only once all the direct subopts and collateral
values for subopts for the following main opts are stuffed into a data structure
somehow (and perhaps the logic of processing them are stuffed into a routine) can
the mkfs.xfs.conf blend in well, given the same logic would be used:

                case 'b':                                                       
                case 'd':                                                       
                case 'i':                                                       
                case 'l':                                                       
                case 'm':                                                       
                case 'n':                                                       
                case 'r':                                                       
                case 's':                                                       
                        p = optarg;                                             
                        parse_subopts(c, p, &params); 

So I'll have to hold off my patches until something like this is available, but
knowing its an end goal helps in the review process.

  Luis
