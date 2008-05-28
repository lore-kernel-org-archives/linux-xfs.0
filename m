Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 09:45:30 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4SGjRAW024647
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 09:45:27 -0700
Received: from atlantis.cc.ndsu.NoDak.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 330DE1747621
	for <xfs@oss.sgi.com>; Wed, 28 May 2008 09:46:18 -0700 (PDT)
Received: from atlantis.cc.ndsu.NoDak.edu (atlantis.cc.ndsu.NoDak.edu [134.129.99.37]) by cuda.sgi.com with ESMTP id yaNQiERLryHPqWYz for <xfs@oss.sgi.com>; Wed, 28 May 2008 09:46:18 -0700 (PDT)
Date: Wed, 28 May 2008 11:46:16 -0500
From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Message-ID: <20080528164616.GB29722@atlantis.cc.ndsu.NoDak.edu>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jens =?iso-8859-1?Q?B=E4ckman?= <jens.backman@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 28, 2008 at 06:34:00PM +0200, Jens Bäckman wrote:

> Either the RAID 1 read speed must be wrong, or something is odd in the
> Linux implementation. There's six drives that can be used for reading
> at the same time, as they contain the very same data. 63MB/s
> sequential looks like what you would get from a single drive.

The RAID 1 read speed metrics do not depict multithreaded
processes reading from the array simutaneouly. I would suspect
that the read performance metrics would look better if 2 bonnie
simulations were ran together (for RAID 1 that is).

Bryan 
