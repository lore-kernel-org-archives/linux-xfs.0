Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Jun 2008 12:51:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5SJp8ac012389
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 12:51:08 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60E6212376DB
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 12:52:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id KlLhRKRkRDFoppP7 for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 12:52:09 -0700 (PDT)
Message-ID: <48669668.4060204@sandeen.net>
Date: Sat, 28 Jun 2008 14:52:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: rfc: kill ino64 mount option
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed> <486589E7.9010705@sgi.com> <4865BEAB.4030108@sandeen.net> <20080628152540.GB22484@lst.de>
In-Reply-To: <20080628152540.GB22484@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: markgw@sgi.com, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Jun 27, 2008 at 11:31:39PM -0500, Eric Sandeen wrote:
>> I guess I'm ambivalent too, is it really that invasive?  Maybe 10, 15
>> lines of code looks like?
> 
> Currently it's implemented by adding m_inoadd surrounded by an
> #if XFS_BIG_INUMS.  This can be cleaned up by adding a helper ala
> 
> xfs_ino_t xfs_user_ino(struct xfs_mount *mp, xfs_ino_t ino);
> 
> but I don't really see the point as the option seems quite useless.  But
> if others thing the option is worth keeping around I'll do the helper
> instead.

Well, to be honest i've never even enabled it  :)

how much does xfsqa use it?

I guess I don't really care if it goes.

-Eric
