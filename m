Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49827 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751921AbdHCWZ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Aug 2017 18:25:28 -0400
Date: Fri, 4 Aug 2017 00:25:27 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
Message-ID: <20170803222527.GH27873@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-2-jtulak@redhat.com>
 <20170727162752.GK18884@wotan.suse.de>
 <0c34504a-923a-20ac-9f03-6972e38bbfde@redhat.com>
 <20170729171207.GN18884@wotan.suse.de>
 <723e3733-0a80-1bf2-89ed-e80b914037ed@redhat.com>
 <20170802191932.GG18884@wotan.suse.de>
 <bf5c5e66-526e-4431-335a-b9fc98fc31e8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf5c5e66-526e-4431-335a-b9fc98fc31e8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Thu, Aug 03, 2017 at 03:07:20PM +0200, Jan Tulak wrote:
> OK, I'm willing to return errors for the _raw functions. These are used only
> on few places, so it is not a big issue. Especially if I add a wrapper for
> the get_conf_raw function - right now, these are used only as fprintf()
> arguments to print an error. So the wrapper makes it easy to use in this
> case (with the old die-on-error behavior), but if you want to use it for
> something else, you can use it directly and get an error as a return code.
> Does this looks good?
> 
> +/*
> + * Return 0 on success, -ENOMEM if it could not allocate enough memory for
> + * the string to be saved into the out pointer.
> + */
> +static int
> +get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
> +{
> +       if (subopt < 0 || subopt >= MAX_SUBOPTS) {
> +               fprintf(stderr,
> +               "This is a bug: get_conf_raw called with invalid opt/subopt:
> %c/%d\n",
> +               opt->name, subopt);
> +               exit(1);

Why not return -EINVAL?

> +       }
> +       *out = strdup(opt->subopt_params[subopt].raw_input);
> +       if (*out == NULL)
> +               return -ENOMEM;
> +       return 0;
> +
> +}
> +
> +/*
> + * Same as get_conf_raw(), except it returns the string through return
> + * and dies on any error.
> + */
> +static char *
> +get_conf_raw_safe(const struct opt_params *opt, const int subopt)
> +{
> +       char *str;
> +       if (get_conf_raw(opt, subopt, &str) == -ENOMEM) {
> +               fprintf(stderr, "Out of memory!");
> +               exit(1);

I'd say no, just return NULL; these aborts drive me personally nuts.

> +       }
> +       return str;
> +}
> 
> 
> > 
> > > > I don't think we need the too small or too big, a simple range issue should
> > > > suffice and we have -ERANGE.
> > > > 
> > > At this moment, we are telling if it is too small or too big, but when there
> > > is no standard error code for that, ERANGE has to suffice.
> > Sure, my point was that we have special values for too big or too small, and
> > I consider that hacky, we could just *say* if it was too big or too small
> > but just use ERANGE as its standard and non-hacky.
> We don't have special values, we just print it out and die. But yes, if we
> will pass the information anywhere, then it is better to use ERANGE rather
> than some custom error number.

Great.

  Luis
