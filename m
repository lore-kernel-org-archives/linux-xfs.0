Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 652B27CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 12:56:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 421B7304039
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 10:56:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MuWnHABaaAscbwF8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 10:56:00 -0700 (PDT)
Date: Thu, 10 Sep 2015 13:55:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: "This is a bug."
Message-ID: <20150910175557.GE27863@bfoster.bfoster>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
	<20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
	<20150910173138.GB18940@tarvainen.info>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910173138.GB18940@tarvainen.info>
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
To: Tapani Tarvainen <tapani@tapanitarvainen.fi>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2015 at 08:31:38PM +0300, Tapani Tarvainen wrote:
> On Thu, Sep 10, 2015 at 10:51:54AM -0400, Brian Foster (bfoster@redhat.com) wrote:
> 
> > First off, I see ~60MB of corruption output before I even get to the
> > reported repair failure, so this appears to be an extremely severe
> > corruption and I wouldn't be surprised if ultimately beyond repair
> 
> I assumed as much already.
> 
> > I suspect what's more interesting at this point is what happened to
> > cause this level of corruption? What kind of event lead to this? Was it
> > a pure filesystem crash or some kind of hardware/raid failure?
> 
> Hardware failure. Details are still a bit unclear but apparently raid
> controller went haywire, offlining the array in the middle of
> heavy filesystem use.
> 
> > Also, do you happen to know the geometry (xfs_info) of the original fs?
> 
> No (and xfs_info doesn't work on the copy made after crash as it
> can't be mounted).
> 
> > Repair was showing agno's up in the 20k's and now that I've mounted the
> > repaired image, xfs_info shows the following:
> [...]
> > So that's a 6TB fs with over 24000 allocation groups of size 256MB, as
> > opposed to the mkfs default of 6 allocation groups of 1TB each. Is that
> > intentional?
> 
> Not to my knowledge. Unless I'm mistaken, the filesystem was created
> while the machine was running Debian Squeeze, using whatever defaults
> were back then.
> 

Strange... was the filesystem created small and then grown to a much
larger size via xfs_growfs? I just formatted a 1GB fs that started with
4 allocation groups and ends with 24576 (same as above) AGs when grown
to 6TB.

Brian

> -- 
> Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
