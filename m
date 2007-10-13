Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Oct 2007 11:10:35 -0700 (PDT)
Received: from postfix1-g20.free.fr (postfix1-g20.free.fr [212.27.60.42])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9DIAOpt006509
	for <xfs@oss.sgi.com>; Sat, 13 Oct 2007 11:10:26 -0700
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 537B81B93167
	for <xfs@oss.sgi.com>; Sat, 13 Oct 2007 20:10:25 +0200 (CEST)
Date: Sat, 13 Oct 2007 20:10:15 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Latencies in XFS.
Message-ID: <20071013201015.4a8008bb@galadriel.home>
In-Reply-To: <20071009163635.413dec0c@zeus.pccl.info>
References: <20071009163635.413dec0c@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Clayton <andrew@digital-domain.net>, xfs@oss.sgi.com

Le Tue, 9 Oct 2007 16:36:35 +0100 vous écriviez:

> I think I have narrowed it down to XFS.

I notice you use a bleeding-edge unstable kernel, with a whole new
scheduler. I tried your benchmark on a machine running a known stable
kernel (2.6.20.17) and the slowdown is similar in xfs and other fs.

As a side note, I personnally wouldn't choose xfs for desktop users home
directories (email,web, etc) because it's much better at pure
throughput and quite slower at IOPS than other FSes. Reiserfs is the
best of the common FSes for this.

I'm quite surprised that apparently your production system is running
a prerelease kernel. Why? 

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
