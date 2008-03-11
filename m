Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 11:02:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2BI1fvS028494
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:01:47 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D68DF65E51
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:02:12 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id cAVekRemrDS30mha for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 11:02:12 -0700 (PDT)
Received: from josefsipek.net (baal.fsl.cs.sunysb.edu [130.245.126.78])
	by filer.fsl.cs.sunysb.edu (8.12.11.20060308/8.13.1) with ESMTP id m2BI29Xb013866
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 14:02:10 -0400
Date: Tue, 11 Mar 2008 14:02:10 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: can I shrink an xfs?
Message-ID: <20080311180210.GB5767@josefsipek.net>
References: <20080311172958.GA31833@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311172958.GA31833@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, Mar 11, 2008 at 06:29:58PM +0100, Louis-David Mitterrand wrote:
> Hi,
> 
> Is it possible to shrink an xfs? I tried using xfs_growfs to no avail.
 
There's no official/supported way to do it. There might be some tool to do
it, but I'm not aware of any.

Dave, et. al.: why not support shrinking? I know, inode numbers and whatnot,
but that's already being messed up (at least to a degree) with the noikeep
mount option. I think that shrinking would be useful to have - even if you
have to pass it --i-know-what-i-am-doing kind of option. Maybe a offline
shrink via repair would be more viable?

Josef 'Jeff' Sipek.

-- 
Hegh QaQ law'
quvHa'ghach QaQ puS
