Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36925 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752035AbdHBTTe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 15:19:34 -0400
Date: Wed, 2 Aug 2017 21:19:32 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
Message-ID: <20170802191932.GG18884@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-2-jtulak@redhat.com>
 <20170727162752.GK18884@wotan.suse.de>
 <0c34504a-923a-20ac-9f03-6972e38bbfde@redhat.com>
 <20170729171207.GN18884@wotan.suse.de>
 <723e3733-0a80-1bf2-89ed-e80b914037ed@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <723e3733-0a80-1bf2-89ed-e80b914037ed@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Wed, Aug 02, 2017 at 04:30:09PM +0200, Jan Tulak wrote:
> On 29/07/2017 19:12, Luis R. Rodriguez wrote:
> > On Fri, Jul 28, 2017 at 04:45:58PM +0200, Jan Tulak wrote:
> > > 
> > > On 27/07/2017 18:27, Luis R. Rodriguez wrote:
> > > > On Thu, Jul 20, 2017 at 11:29:26AM +0200, Jan Tulak wrote:
> > > > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > > > index a69190b9..4b030101 100644
> > > > > --- a/mkfs/xfs_mkfs.c
> > > > > +++ b/mkfs/xfs_mkfs.c
> > > > > @@ -107,6 +107,11 @@ unsigned int		sectorsize;
> > > > >     *     sets what is used with simple specifying the subopt (-d file).
> > > > >     *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
> > > > >     *     value in any case.
> > > > > + *
> > > > > + *   raw_input INTERNAL
> > > > > + *     Filled raw string from the user, so we never lose that information e.g.
> > > > > + *     to print it back in case of an issue.
> > > > > + *
> > > > >     */
> > > > >    struct opt_params {
> > > > >    	const char	name;
> > > > > @@ -122,6 +127,7 @@ struct opt_params {
> > > > >    		long long	minval;
> > > > >    		long long	maxval;
> > > > >    		long long	defaultval;
> > > > > +		const char	*raw_input;
> > > > >    	}		subopt_params[MAX_SUBOPTS];
> > > > >    };
> > > > > @@ -729,6 +735,18 @@ struct opt_params mopts = {
> > > > >     */
> > > > >    #define WHACK_SIZE (128 * 1024)
> > > > > +static inline void
> > > > > +set_conf_raw(struct opt_params *opt, int subopt, const char *value)
> > > > > +{
> > > > > +	opt->subopt_params[subopt].raw_input = value;
> > > > > +}
> > > > There are no bounds check on the array here, I think set_conf_raw()
> > > > should return int and we would check the return value. It could
> > > > return -EINVAL if the subopt is invalid for instance.
> > > Good idea. The only issue is with the return code, that causes some issues
> > > when we are also returning values - I wanted the values to be turned into
> > > uint64. But do we need to return an error? I don't see what usecase there
> > > would be for it, other than detecting a bug. So an assert might be a better
> > > solution - then it can't happen that a wrong index is used and result not
> > > tested.
> > The setting of the value can be done by using an extra argument pointer. Then
> > if its set it be assigned. Otherwise it would be left alone. The return value
> > would return 0 on success, otherwise a standard return value indicating the
> > cause of the error.
> I strongly prefer to return the value, not an error code. We can do the
> other way around, put the error code into an argument to get roughly the
> same result, while constructions like set_conf_raw(FOO, BAR, baz *
> get_conf_raw(FOO, BAR)) will continue to work without the need for
> intermediate variables.
> 
> The *_raw functions are used on few places only, so it would be only a small
> issue there, but for consistency, (get|set)_conf_val should have the same
> behavior and an intermediate variable for every use of those would be really
> annoying. So, how about this?

It would not be intermediate, the main error variable from the start of
each function could be used, as is typical in many properly written C
programs.

> static inline void
> set_conf_raw(struct opt_params *opt, int subopt, const char *value, int
> *err)
> {
>     if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>         if (err != NULL) *err = EINVAL;
>         return;
>     }
>     opt->subopt_params[subopt].raw_input = value;
> }

If you go with the strdup thing to avoid limiting the context of the use of
the pointer then you'll still have to return an error or abort, and I think
returning an error is best.

> > I don't think we need the too small or too big, a simple range issue should
> > suffice and we have -ERANGE.
> > 
> At this moment, we are telling if it is too small or too big, but when there
> is no standard error code for that, ERANGE has to suffice.

Sure, my point was that we have special values for too big or too small, and
I consider that hacky, we could just *say* if it was too big or too small
but just use ERANGE as its standard and non-hacky.

  Luis
