Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BB287F54
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 09:51:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 781D68F8035
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 07:51:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Rvb3a9lDjXvXKfUI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 07:51:57 -0700 (PDT)
Date: Thu, 10 Sep 2015 10:51:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: "This is a bug."
Message-ID: <20150910145154.GC27863@bfoster.bfoster>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
	<20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910130530.GB28374@tehanu.it.jyu.fi>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2015 at 04:05:30PM +0300, Tapani Tarvainen wrote:
> On 10 Sep 09:01, Brian Foster (bfoster@redhat.com) wrote:
> 
> > > It is 2.5GB so not really nice to mail...
> 
> > Can you compress it?
> 
> Ah. Of course, should've done it in the first place.
> Still 250MB though:
> 
> https://huom.it.jyu.fi/tmp/data1.metadump.gz
> 

First off, I see ~60MB of corruption output before I even get to the
reported repair failure, so this appears to be an extremely severe
corruption and I wouldn't be surprised if ultimately beyond repair (not
that it matters for you, since you are restoring from backups).

The failure itself is an assert failure against an error return value
that appears to have a fallback path, so I'm not really sure why it's
there. I tried just removing it to see what happens. It ran to
completion, but there was a ton of output, write verifier errors, etc.,
so I'm not totally sure how coherent the result is yet. I'll run another
repair pass and do some directory traversals and whatnot and see if it
explodes...

I suspect what's more interesting at this point is what happened to
cause this level of corruption? What kind of event lead to this? Was it
a pure filesystem crash or some kind of hardware/raid failure?

Also, do you happen to know the geometry (xfs_info) of the original fs?
Repair was showing agno's up in the 20k's and now that I've mounted the
repaired image, xfs_info shows the following:

meta-data=/dev/loop0             isize=256    agcount=24576, agsize=65536 blks
         =                       sectsz=4096  attr=2, projid32bit=0
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=1610612736, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

So that's a 6TB fs with over 24000 allocation groups of size 256MB, as
opposed to the mkfs default of 6 allocation groups of 1TB each. Is that
intentional?

Brian

> -- 
> Tapani Tarvainen
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
