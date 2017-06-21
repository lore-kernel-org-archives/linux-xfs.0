Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752911AbdFUJxl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 05:53:41 -0400
Date: Wed, 21 Jun 2017 05:53:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170621095324.GA28914@bfoster.bfoster>
References: <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
 <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
 <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
 <f2edd27c-615b-d20f-0b03-51cc399221bb@assyoma.it>
 <20170620110548.eruly7ygixydyk2o@eorzea.usersys.redhat.com>
 <dee0d3cc198663bb850ef2576c84d620@assyoma.it>
 <20170620152858.GA3348@bfoster.bfoster>
 <d30c96bafa9d476e1a381a0aaa1bc285@assyoma.it>
 <20170620170208.GC3348@bfoster.bfoster>
 <18cd5d2398dd1187dd1306cdcee508b7@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18cd5d2398dd1187dd1306cdcee508b7@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2017 at 08:43:30PM +0200, Gionatan Danti wrote:
> Il 20-06-2017 19:02 Brian Foster ha scritto:
> > 
> > ISTM you might as well write something in userspace that receives a
> > notification from device-mapper and shuts down or remounts the fs if the
> > volume has gone inactive or hit a watermark. I don't think we'd bury
> > anything in XFS that cuts off and then resumes operations based on
> > underlying device errors like that. That sounds like a very crude
> > approach with a narrow use case.
> 
> Absolutely, crude & ugly...
> 
> > 
> > That said, I don't think I'd be opposed to something in XFS that
> > (optionally) shutdown the fs in response to a similar dm notification
> > provided we know with certainty that the underlying device is inactive
> > (and that it can be accomplished relatively cleanly).
> > 
> 
> This would be a much better approach. Any chances to get it implemented?
> About your patches, I really like that they addresses the fallocate
> propagation issue. Are they a work in progress? Any chances to have them
> shipping in mainline kernel?
> 

Not likely anytime soon, at least. Those patches were an experiment for
an idea on how to improve usability in an XFS/dm-thin setup, but
otherwise didn't seem to get much traction. One major downside is that
the solution is specific to XFS.

Brian

> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
