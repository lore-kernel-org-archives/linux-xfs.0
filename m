Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Oct 2007 18:01:53 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9O11lXv005381
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2007 18:01:49 -0700
Date: Tue, 23 Oct 2007 20:37:06 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: Slow seek in kernels >= 2.6.18
Message-ID: <20071024003706.GA27516@filer.fsl.cs.sunysb.edu>
References: <4717156C.3030308@firma.seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4717156C.3030308@firma.seznam.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton A Vorobev <anton.vorobev@firma.seznam.cz>
Cc: xfs@oss.sgi.com

On Thu, Oct 18, 2007 at 10:12:28AM +0200, Anton A Vorobev wrote:
> Hi!
>
> A question. We've got an application that runs about 30-40 minutes. After 
> kernel upgrade from 2.6.17 branch, it runs about 3 hours.
> I've made tests with the help of bonnie++, it shows that random seek 
> operations are about 3 times slower in kernels newer than 2.6.18 in 
> comparison with 2.6.17. This difference may be seen only during high load 
> of a server. When it is in normal state, parameters are rather the same.

I think that's about when the defaults for few /proc/sys/vm/ vars changed.
One from 10 to 5, and another from 40 to 10. I forget the exact filenames.

Josef 'Jeff' Sipek.

-- 
Once you have their hardware. Never give it back.
(The First Rule of Hardware Acquisition)
