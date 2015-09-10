Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD1127CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 13:03:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBED78F8050
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 11:03:43 -0700 (PDT)
Received: from hauki.tapanitarvainen.fi (hauki.tapanitarvainen.fi
	[80.68.90.32]) by cuda.sgi.com with ESMTP id bNoGQ6BDR9ZwFNUB
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Sep 2015 11:03:41 -0700 (PDT)
Date: Thu, 10 Sep 2015 21:03:39 +0300
From: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Subject: Re: "This is a bug."
Message-ID: <20150910180339.GB18739@tarvainen.info>
References: <20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
	<20150910123603.GA27863@bfoster.bfoster>
	<20150910125441.GA28374@tehanu.it.jyu.fi>
	<20150910130106.GB27863@bfoster.bfoster>
	<20150910130530.GB28374@tehanu.it.jyu.fi>
	<20150910145154.GC27863@bfoster.bfoster>
	<20150910173138.GB18940@tarvainen.info>
	<20150910175557.GE27863@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910175557.GE27863@bfoster.bfoster>
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

On Thu, Sep 10, 2015 at 01:55:58PM -0400, Brian Foster (bfoster@redhat.com) wrote:

> > > So that's a 6TB fs with over 24000 allocation groups of size 256MB, as
> > > opposed to the mkfs default of 6 allocation groups of 1TB each. Is that
> > > intentional?
> > 
> > Not to my knowledge. Unless I'm mistaken, the filesystem was created
> > while the machine was running Debian Squeeze, using whatever defaults
> > were back then.

> Strange... was the filesystem created small and then grown to a much
> larger size via xfs_growfs?

Almost certainly yes, although how small it initially was I'm not
sure.

-- 
Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
