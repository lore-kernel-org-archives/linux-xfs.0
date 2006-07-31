Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 05:39:28 -0700 (PDT)
Received: from web31713.mail.mud.yahoo.com (web31713.mail.mud.yahoo.com [68.142.201.193])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6VCd4DW002324
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 05:39:04 -0700
Message-ID: <20060731123837.28243.qmail@web31713.mail.mud.yahoo.com>
Date: Mon, 31 Jul 2006 05:38:37 -0700 (PDT)
From: Heilige Gheist <hgheist@yahoo.com>
Subject: Re: XFS setting custom extent size: real-time section only?
In-Reply-To: <20060726090051.C2118045@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com


[..] 
> Hmm.
> 
> > When you speak of pre-allocation, do you suggest using
> XFS_IOC_RESVSP
> > ioctl interface to explicitly reserve blocks in advance?
> Yes, thats the one.
> 
> > Can it guarantee contiguous chunk allocation?
> No, but it does the best it can under the circumstances,
> which is usually pretty good.
> 
> > management, isn't it? Basically you pay for unfragmented contiguous
> > block layout with extra disk space reserved for unwritten data.
> But its not really "extra" if you know you're going to use it,
> right?
> 
> > If so, why offer custom extent size in the first place?
> Its a different concept, solving different problems really.  One is
> at the extent level, the other is at (typically large) ranges of
> bytes that can be more than an extent.  
> One is a "harder" guarantee than the the other of getting contiguous
> space, as they call into the allocator in different ways.

I think that I'll go for the custom extent size as the harder guarantee
against fragmentation. It also looks to me that custom extent is easier
for application to implement.
Are there any other reasons why NOT use custom extent size?

> 
> > [..]
> > > > Do I have to have non-realtime regular section?
> > > Yes.  All metadata is stored there.
> > Is there any way I can do sizing of the meta-data? 
> 
> I'm not sure what you're asking there...?
Provided I have 150G real-time section, how can I estimate a size of
data section that I need to allocate in order to store filesystem
meta-data?

--alan.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
