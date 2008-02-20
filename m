Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 15:39:44 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1KNdRmX031392
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 15:39:31 -0800
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40602E7E130
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 15:39:52 -0800 (PST)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id 5lqD7uijNbLWPbma for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 15:39:52 -0800 (PST)
Date: Wed, 20 Feb 2008 18:39:51 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix mount option pasing to make inode cluster deletion
	default (again)
Message-ID: <20080220233951.GE19790@josefsipek.net>
References: <47B3B6AE.4030505@sandeen.net> <47B99864.3050401@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B99864.3050401@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 18, 2008 at 08:38:28AM -0600, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > mod xfs-linux-melb:xfs-kern:29683a / 
> > git commit 574342f4ad450b33bc85ec53210b8aa8bfff2fcf
> > 
> > broke default options in such a way that empty inode clusters 
> > are no longer deleted by default, because if no options are 
> > given, we "goto done;" without setting the default 
> > XFSMNT_IDELETE flag.
> > 
> > All this logic could probably be rearranged to make things
> > clearer, but for now I think this small patch fixes it:
> > 
> > Set IDELETE a.k.a. "noikeep" by default, but if dmapi is in
> > use, turn it back off (i.e. "ikeep") *unless* noikeep was 
> > specifically requested.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> While I like Jeff's patch in the long run... unless you are considering
> submitting it for 2.6.25, might you consider this smaller patch for
> 2.6.25 to fix the inode reclamation problem in the short-term?
 
Yup. Either patch fixes a bug and so it should get sent out rather sooner
than later.

Josef 'Jeff' Sipek.

-- 
Si hoc legere scis nimium eruditionis habes.
