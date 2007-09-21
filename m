Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Sep 2007 02:14:38 -0700 (PDT)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8L9ESgf021074
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2007 02:14:32 -0700
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: Review: Concurrent Multi-File Data Streams
Date: Fri, 21 Sep 2007 11:13:33 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <12789210.post@talk.nabble.com>
Message-Id: <20070921091441.3ABB88E0B@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Hxsrmeng' <hxsrmeng@gmail.com>, xfs@oss.sgi.com

> Is this feature included in the linux-2.6-xfs kernel downloaded from
> cvs@oss.sgi.com?
> 
> If it is included, in order to enable it, which control flag should be
> set?
> 
> If I write many files concurrently, should each file be stored in
> contiguous
> blocks in the same AG?
> 
> Thanks
> 
> 
> David Chinner wrote:
> >
> >
> > Concurrent Multi-File Data Streams
> >
> > In media spaces, video is often stored in a frame-per-file format.
> > When dealing with uncompressed realtime HD video streams in this format,
> > it is crucial that files do not get fragmented and that multiple files
> > a placed contiguously on disk.
> >

Hello All,

I'm running DSS (Darwin Streaming Server) on one of my servers and that
"Concurrent Multi-File Data Streams" thing seems very interesting :)

I have a separate partition there I store all movies.
Is 2.6.22 kernel already has this patch incorporated already(actually
gentoo-sources-2.6.22-r5)?

Are there any special mkfs.xfs or mount options I should make to make this
thing work or make the FS to be optimized for streaming?


Best Regards,
Leon Kolchinsky
