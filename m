Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20013 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdCPSpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 14:45:35 -0400
Date: Thu, 16 Mar 2017 11:45:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/22] mkfs: move conflicts into the table
Message-ID: <20170316184518.GJ5280@birch.djwong.org>
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-9-jtulak@redhat.com>
 <435070bc-d00b-ac32-a319-4cce9c4b7246@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <435070bc-d00b-ac32-a319-4cce9c4b7246@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 16, 2017 at 11:39:11AM -0700, Eric Sandeen wrote:
> On 3/15/17 9:00 AM, Jan Tulak wrote:
> > @@ -640,7 +655,9 @@ struct opt_params {
> >  			  .defaultval = SUBOPT_NEEDS_VAL,
> >  			},
> >  			{ .index = R_DEV,
> > -			  .conflicts = { {LAST_CONFLICT} },
> > +			  .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
> > +		"rmapbt not supported without CRC support."},
> > +					 {LAST_CONFLICT} },
> >  			  .defaultval = SUBOPT_NEEDS_VAL,
> >  			},
> >  			{ .index = R_FILE,
> > @@ -650,7 +667,9 @@ struct opt_params {
> >  			  .conflicts = { {LAST_CONFLICT} },
> >  			},
> >  			{ .index = R_NAME,
> > -			  .conflicts = { {LAST_CONFLICT} },
> > +			  .conflicts = { {OPT_M, M_RMAPBT, false, 0, 0,
> > +		"rmapbt not supported without CRC support."},
> > +					 {LAST_CONFLICT} },
> >  			  .defaultval = SUBOPT_NEEDS_VAL,
> >  			},
> >  			{ .index = R_NOALIGN,
> 
> These two should be:
> 
> "rmapbt not supported with realtime devices."
> 
> I think.

Yes, rmapbt isn't supported with realtime devices yet.

FWIW we ought to lock out realtime+reflink for the time being too.

At one point I had a prototype for reflink on the rtdev but it bitrotted
and died when the iomap rework came along.  I'll get back to it some
day, but first I need to reduce the number of out of tree patches in
djwong-wtf. :)

--D

> 
> (sorry for the scattershot review, I'll try to get organized going forward) ;)
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
