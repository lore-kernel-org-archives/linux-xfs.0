Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C60287CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 13:34:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A3B4C8F806F
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 11:34:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qORfNlOQTgGwwa6j (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 11:34:01 -0700 (PDT)
Date: Thu, 10 Sep 2015 14:33:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: "This is a bug."
Message-ID: <20150910183358.GF27863@bfoster.bfoster>
References: <20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
	<20150910173138.GB18940@tarvainen.info>
	<20150910175557.GE27863@bfoster.bfoster>
	<20150910180339.GB18739@tarvainen.info>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910180339.GB18739@tarvainen.info>
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

On Thu, Sep 10, 2015 at 09:03:39PM +0300, Tapani Tarvainen wrote:
> On Thu, Sep 10, 2015 at 01:55:58PM -0400, Brian Foster (bfoster@redhat.com) wrote:
> 
> > > > So that's a 6TB fs with over 24000 allocation groups of size 256MB, as
> > > > opposed to the mkfs default of 6 allocation groups of 1TB each. Is that
> > > > intentional?
> > > 
> > > Not to my knowledge. Unless I'm mistaken, the filesystem was created
> > > while the machine was running Debian Squeeze, using whatever defaults
> > > were back then.
> 
> > Strange... was the filesystem created small and then grown to a much
> > larger size via xfs_growfs?
> 
> Almost certainly yes, although how small it initially was I'm not
> sure.
> 

That probably explains that then. While growfs is obviously supported,
it's not usually a great idea to grow from something really small to
really large like this precisely because you end up with this kind of
weird geometry. mkfs tries to format the fs to an ideal default geometry
based on the current size of the device, but the allocation group size
cannot be modified once the filesystem is created. Therefore, growfs can
only add more AGs of the original size.

As a result, you end up with a 6TB filesystem with >24k allocation
groups, whereas mkfs will format a 6TB device with 6 allocation groups
by default (though I think specifying a stripe unit can tweak this). My
understanding is that this could be increased sanely on large cpu count
systems and such, but we're probably talking about going to something on
the order of 32 or 64 allocation groups as opposed to thousands.

I'd expect such a large filesystem with such small allocation groups to
probably introduce overhead in terms of metadata usage (24k agi's,
agf's, 2x free space btrees and 1x inode btree per AG), spending more
time in AG selection algorithms for allocations and whatnot, increased
fragmentation due to capping the maximum contiguous extent size,
creating more work for userspace tools such as repair, etc., and
probably to have other weird or non-obvious side effects that I'm not
familiar with.

Brian

> -- 
> Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
