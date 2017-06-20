Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbdFTRBb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jun 2017 13:01:31 -0400
Date: Tue, 20 Jun 2017 13:01:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Shutdown filesystem when a thin pool become full
Message-ID: <20170620170127.GB3348@bfoster.bfoster>
References: <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <7e8e16f1-5425-44b3-e908-c0e8a3300e3f@assyoma.it>
 <a89aa00c4f86fbdc674dd8f5b5eeb248@assyoma.it>
 <20170615131433.n33sqvyes4fhcbye@eorzea.usersys.redhat.com>
 <20170615141057.q7fpnicynucq6yk2@eorzea.usersys.redhat.com>
 <f2edd27c-615b-d20f-0b03-51cc399221bb@assyoma.it>
 <20170620110548.eruly7ygixydyk2o@eorzea.usersys.redhat.com>
 <dee0d3cc198663bb850ef2576c84d620@assyoma.it>
 <20170620152858.GA3348@bfoster.bfoster>
 <20170620153444.GM21846@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620153444.GM21846@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On Tue, Jun 20, 2017 at 05:34:44PM +0200, Luis R. Rodriguez wrote:
> On Tue, Jun 20, 2017 at 11:28:58AM -0400, Brian Foster wrote:
> > On Tue, Jun 20, 2017 at 05:03:42PM +0200, Gionatan Danti wrote:
> > > Il 20-06-2017 13:05 Carlos Maiolino ha scritto:
> > > > 
> > ...
> > > > Surely this can be improved, but at the end, the application will always
> > > > need to
> > > > check for its own data.
> > > 
> > > I think the key improvement would be to let the filesystem know about the
> > > full thin pool - ie: returing ENOSPC at some convenient time (a wild guess:
> > > can we return ENOSPC during delayed block allocation?)
> > > 
> > 
> > FWIW, I played with something like this a while ago. See the following
> > (and its predecessor for a more detailed cover letter):
> > 
> >   http://oss.sgi.com/pipermail/xfs/2016-April/048166.html
> 
> Any chance this is up in a tree somewhere?
> 

No, I don't have an upstream tree hosted anywhere unfortunately.

Brian

>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
