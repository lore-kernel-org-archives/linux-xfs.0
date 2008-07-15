Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 19:47:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6F2le73010172
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 19:47:40 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15DF12EF9FF
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 19:48:47 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 7BAohlK7B2Spm9ir for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 19:48:47 -0700 (PDT)
Date: Tue, 15 Jul 2008 12:48:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question about xfs_fsync on linux
Message-ID: <20080715024830.GZ29319@disturbed>
References: <20080714230300.GY29319@disturbed> <200807150129.m6F1THE23901@elf.torek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807150129.m6F1THE23901@elf.torek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Torek <chris.torek@windriver.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 14, 2008 at 07:29:16PM -0600, Chris Torek wrote:
> >What kernel(s), exactly, is/are showing this problem?
> 
> Well, that part is a bit tricky.  The base kernel is 2.6.21
> but it has a lot of patches, including the one you mentioned.
> (The customer is double checking to make sure they actually have
> that patch in.)

Well, you are pretty much on your own, then. Really, we cannot help
diagnose problems on old kernels with a random set of backported
patches in them.  If you can provide a reproducable test case that
triggers the problem on a recent, pristine tree then we can find the
problem and fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
