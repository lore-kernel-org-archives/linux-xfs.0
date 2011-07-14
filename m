Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EIeLNe154115 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:40:21 -0500
Subject: Re: XFS Test Case:252 - Shows Wrong Output
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <BANLkTi=yk3Z2KUnwtr6-H1BNhWG-XvJZPw@mail.gmail.com>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
	<4E022818.7030406@linux.vnet.ibm.com>
	<BANLkTimuv183W0ef0aYCySWPnv9rLqNuww@mail.gmail.com>
	<20110623062030.GY32466@dastard>
	<BANLkTi=2rTU2R_hGGeMhLYzM6FKPOW0L8w@mail.gmail.com>
	<BANLkTinQig04y6Rc9MHGSfpbTSKZpmtHpQ@mail.gmail.com>
	<BANLkTin8oJi04CCrtGVsxFGiA9PLQEEtpA@mail.gmail.com>
	<BANLkTi=yk3Z2KUnwtr6-H1BNhWG-XvJZPw@mail.gmail.com>
Date: Thu, 14 Jul 2011 13:40:15 -0500
Message-ID: <1310668815.2067.53.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Fri, 2011-06-24 at 12:45 +0530, Amit Sahrawat wrote:
> This has to be an issue with everyone who is using XFS version which is not
> supporting "fpunch" but still none has raised this. As per my view, the
> support checking function *_require_xfs_io_falloc_punch() *is not working
> correctly otherwise it should return from that point.
> 
> *Instead of:*
> echo $testio | grep -q "not found"
> If we are sure of a *"hole"* from that command, then we can grep for "hole"
> in $testio.
> 
> Please correct me if I am wrong.
> 
> Thanks & Regards,
> Amit Sahrawat

I think what you are saying is that in your environment,
_require_xfs_io_falloc_punch() is not properly deciding
whether the fpunch operation is supported.  And you are
suggesting a way to determine it properly, is that right?

Unfortunately it is difficult to know whether your
suggestion is a proper fix without knowing details of
your current system, as well as details about what
you are seeing that is incorrect.

We welcome suggested fixes from people.  Often that
takes the form of a patch that proposes a fix, but
if enough precise information is provided about the
problem we can sometimes develop a fix for you.

Can you supply either a patch with a proposed fix,
or else provide more information about exactly
what you are seeing?  Otherwise I don't think
we're going to be able to help.

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
