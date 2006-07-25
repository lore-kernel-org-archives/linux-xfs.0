Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 11:09:05 -0700 (PDT)
Received: from web31702.mail.mud.yahoo.com (web31702.mail.mud.yahoo.com [68.142.201.182])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6PI8XDW023588
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 11:08:35 -0700
Message-ID: <20060725180807.64194.qmail@web31702.mail.mud.yahoo.com>
Date: Tue, 25 Jul 2006 11:08:07 -0700 (PDT)
From: Heilige Gheist <hgheist@yahoo.com>
Subject: Re: XFS setting custom extent size: real-time section only?
In-Reply-To: <20060725084356.B2090627@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

[..]
> 
> OK.  Are you certain you need this feature?  (can you describe your
> usage a bit?)  You can get large contiguous chunks of disk space via
> large direct writes for example, or preallocation, so maybe you could
> attack the issue from a different angle to solve it?

The application is reading and writing sparse file of 0.5-1GB, with
heavy skew toward read. The data is written in clusters of various
size, depending on data stream type. The filesystem is constantly being
updated with new data, older files are removed, the filesystem gets
fragmented and we're down to the allocation extent size in terms of
available contiguous disk space.

When you speak of pre-allocation, do you suggest using XFS_IOC_RESVSP
ioctl interface to explicitly reserve blocks in advance?
Can it guarantee contiguous chunk allocation?
Provided it can, pre-allocation is pretty much the same as extent
management, isn't it? Basically you pay for unfragmented contiguous
block layout with extra disk space reserved for unwritten data.
If so, why offer custom extent size in the first place?

[..]
> > Do I have to have non-realtime regular section?
> Yes.  All metadata is stored there.
Is there any way I can do sizing of the meta-data? 

--alan


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
