Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 16:01:19 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l55N1FWt003808
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 16:01:16 -0700
Date: Tue, 5 Jun 2007 19:01:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: corruption bug in 2.6.17
In-Reply-To: <1181084327.3176.4.camel@edge.yarra.acx>
Message-ID: <Pine.LNX.4.64.0706051901090.27983@p34.internal.lan>
References: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
 <alpine.DEB.0.99.0706022300140.16496@sheep.housecafe.de>
 <5d96567b0706050127y7f5eap7b92cddb5cdae02d@mail.gmail.com>
 <alpine.DEB.0.99.0706052217320.21004@foobar-g4> <1181084327.3176.4.camel@edge.yarra.acx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Christian Kujau <lists@nerdbynature.de>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, xfs@oss.sgi.com



On Wed, 6 Jun 2007, Nathan Scott wrote:

> On Tue, 2007-06-05 at 22:24 +0200, Christian Kujau wrote:
>> ...
>>   2) generate some IO on the xfs-mounted partition...and wait until
>> the
>>      fs shut down.
>
> The problem was actually related to a particular form of btree
> dir2 transition - so, certain combinations of file names in a
> relatively large directory with size changes would trigger it.
>
> "generate some IO" is a bit too vague to be helpful.
>
> cheers.
>
> --
> Nathan
>
>

The patch that fixed it:

--- linux-2.6.17.6.orig/fs/xfs/xfs_dir2_node.c
+++ linux-2.6.17.6/fs/xfs/xfs_dir2_node.c
@@ -970,7 +970,7 @@ xfs_dir2_leafn_remove(
                         /*
                          * One less used entry in the free table.
                          */
-                       free->hdr.nused = cpu_to_be32(-1);
+                       be32_add(&free->hdr.nused, -1);
                         xfs_dir2_free_log_header(tp, fbp);
                         /*
                          * If this was the last entry in the table, we can
