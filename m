Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 16:22:21 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5CNMDWt027336
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 16:22:16 -0700
Subject: Re: sunit not working
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <902286657-1181653953-cardhu_decombobulator_blackberry.rim.net-1527539029-@bxe120.bisx.prod.on.blackberry>
References: <1181606134.7873.72.camel@holwrs01>
	 <1181608444.3758.73.camel@edge.yarra.acx>
	 <902286657-1181653953-cardhu_decombobulator_blackberry.rim.net-1527539029-@bxe120.bisx.prod.on.blackberry>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 09:21:18 +1000
Message-Id: <1181690478.3758.108.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: salmr0@bp.com
Cc: "Salmon, Rene" <Rene.Salmon@bp.com>, xfs@oss.sgi.com

On Tue, 2007-06-12 at 13:12 +0000, salmr0@bp.com wrote:
> 
> 
> 
> 
> 
> Thanks that helps.  Now that I know I have the right sunit and swidth
> I have a performace related question.
> 
> If I do a dd on the raw device or to the lun directy I get speeds of
> around 190-200 MBytes/sec.
> 
> As soon as I add xfs on top of the lun my speeds go to around 150
> MBytes/sec. This is for a single stream write using various block
> sizes on a 2 Gbit/sec fiber channel card.
> 

Reads or writes?
What are your I/O sizes?
Buffered or direct IO?
Including fsync time in there or not?  etc, etc.

(Actual dd commands used and their output results would be best)
xfs_io is pretty good for this kind of analysis, as it gives very
fine grained control of operations performed, has integrated bmap
command, etc - use the -F flag for the raw device comparisons).

> Is this overhead more or less what you would expect from xfs? Or is
> there some tunning I need to do? 

You should be able to get very close to raw device speeds esp. for a
single stream reader/writer, with some tuning.

cheers.
