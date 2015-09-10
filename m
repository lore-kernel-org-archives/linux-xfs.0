Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26BAA7CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 12:31:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07042304051
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 10:31:44 -0700 (PDT)
Received: from hauki.tapanitarvainen.fi (hauki.tapanitarvainen.fi
	[80.68.90.32]) by cuda.sgi.com with ESMTP id OZ5u1bvC2zBY5hvp
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Sep 2015 10:31:43 -0700 (PDT)
Date: Thu, 10 Sep 2015 20:31:38 +0300
From: Tapani Tarvainen <tapani@tapanitarvainen.fi>
Subject: Re: "This is a bug."
Message-ID: <20150910173138.GB18940@tarvainen.info>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
	<20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910145154.GC27863@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2015 at 10:51:54AM -0400, Brian Foster (bfoster@redhat.com) wrote:

> First off, I see ~60MB of corruption output before I even get to the
> reported repair failure, so this appears to be an extremely severe
> corruption and I wouldn't be surprised if ultimately beyond repair

I assumed as much already.

> I suspect what's more interesting at this point is what happened to
> cause this level of corruption? What kind of event lead to this? Was it
> a pure filesystem crash or some kind of hardware/raid failure?

Hardware failure. Details are still a bit unclear but apparently raid
controller went haywire, offlining the array in the middle of
heavy filesystem use.

> Also, do you happen to know the geometry (xfs_info) of the original fs?

No (and xfs_info doesn't work on the copy made after crash as it
can't be mounted).

> Repair was showing agno's up in the 20k's and now that I've mounted the
> repaired image, xfs_info shows the following:
[...]
> So that's a 6TB fs with over 24000 allocation groups of size 256MB, as
> opposed to the mkfs default of 6 allocation groups of 1TB each. Is that
> intentional?

Not to my knowledge. Unless I'm mistaken, the filesystem was created
while the machine was running Debian Squeeze, using whatever defaults
were back then.

-- 
Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
