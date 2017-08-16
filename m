Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40606 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbdHPViV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 17:38:21 -0400
Date: Wed, 16 Aug 2017 14:38:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6 v2] mkfs: extend opt_params with a value field
Message-ID: <20170816213812.GC4796@magnolia>
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-5-jtulak@redhat.com>
 <4a7d1fe9-8094-78e8-aca9-f7f0156f0aa7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a7d1fe9-8094-78e8-aca9-f7f0156f0aa7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Aug 16, 2017 at 04:13:52PM -0500, Eric Sandeen wrote:
> On 8/15/17 10:08 AM, Jan Tulak wrote:
> > This patch adds infrastructure that will be used in subsequent patches.
> > 
> > The Value field is the actual value used in computations for creating
> > the filesystem.  This is initialized with sensible default values. If
> > initialized to 0, the value is considered disabled. User input will
> > override default values.  If the field is a string and not a number, the
> > value is set to a positive non-zero number when user input has been
> > supplied.
> > 
> > Add functions that can be used to get/set values to opts table.
> 
> Ok, I need to back up here a bit and look at this conceptually.
> 
> (Again, though, if this is infra for some other patchset, I'd just send
> it with /that/ patchset, not this one ...)
> 
> But anyway, things like this confuse and worry me:
> 
> > +	case OPT_S:
> > +		switch (subopt) {
> > +		case S_LOG:
> > +		case S_SECTLOG:
> > +			set_conf_val(OPT_S, S_LOG, val);
> > +			set_conf_val(OPT_D, D_SECTLOG, val);
> > +			set_conf_val(OPT_L, L_SECTLOG, val);
> > +			set_conf_val(OPT_D, D_SECTSIZE, 1 << val);
> > +			set_conf_val(OPT_S, S_SIZE, 1 << val);
> > +			set_conf_val(OPT_S, S_SECTSIZE, 1 << val);
> > +			set_conf_val(OPT_L, L_SECTLOG, val);
> > +			set_conf_val(OPT_L, L_SECTSIZE, 1 << val);
> > +			set_conf_val(OPT_L, L_SECTSIZE, val);> +			break;
> > +		case S_SIZE:
> > +		case S_SECTSIZE:
> > +			set_conf_val(OPT_S, S_SIZE, val);
> > +			set_conf_val(OPT_D, D_SECTSIZE, val);
> > +			set_conf_val(OPT_D, D_SECTLOG, libxfs_highbit32(val));
> > +			set_conf_val(OPT_S, S_LOG, libxfs_highbit32(val));
> > +			set_conf_val(OPT_S, S_SECTLOG, libxfs_highbit32(val));
> > +			set_conf_val(OPT_L, L_SECTSIZE, val);
> > +			set_conf_val(OPT_L, L_SECTLOG, libxfs_highbit32(val));
> > +			break;
> > +		}
> > +		break;
> > +	}
> 
> Partly because this seems to be going opposite of the simplicity
> we were aiming for - before all this work, if we set teh data sector size,
> via any of these options, it got stored in a variable - "sectorsize".
> 
> Now, if we issue "-s size=4k" the code will calculate and set that same
> value (or its log) into 7 to (or 9?) different internal variables?
> Why is that needed?  There is/are only one (or two) sector size(s) in the
> filesystem, so should there not be one point of truth here?
> 
> But also because the above is wrong; it is possible for the filesystem data
> portion and log portion to have different sector sizes, if the log is external. [1]
> The above would seem to break that, always setting data & log sizes together.
> 
> On top of that, it's getting so complicated that it seems to be difficult to get
> right; i.e. this:
> 
> > +			set_conf_val(OPT_L, L_SECTSIZE, 1 << val);
> > +			set_conf_val(OPT_L, L_SECTSIZE, val);
> 
> surely isn't correct.  I found that when noticing that 1 block sets 9 vals, while
> the other only 7, and wondered why.  So that accounts for one.  After another minute
> of scrutiny I see that OPT_S, S_SECTSIZE isn't set in the 2nd chunk, so that's a bug
> as well.
> 
> This makes me fear fragility in this approach.
> 
> One goal of all this work, I thought, was to clearly describe interdependencies between
> options, but the above seems to add nasty, hidden, implicit, and wrong dependencies
> between log & data sector sizes (for example).

FWIW I thought all this really did was replace the dozens of local
variables holding geometry info with a huge nested struct, which is a
reasonable start on adding support for a config file (where is that,
anyway?) but didn't make any functional changes.

Ofc I didn't realize that xfs/191-input-validation isn't a totally
thorough exerciser of all the mkfs options.

> If we have several commandline options that all set the same fundamental property,
> (i.e. data sector size), then it seems that should somehow be stored in one single
> point of truth within mkfs as it was before.
> 
> -Eric
> 
> [1] # mkfs.xfs -dfile,name=fsfile,size=1g,sectsize=4k -lfile,name=logfile,size=512m,sectsize=512

I see -d sectsize is in the --help screen but not the manpage.  Can we
fix that?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
