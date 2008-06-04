Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 22:28:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m545S8nO027912
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 22:28:10 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AE181E58F5
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 22:29:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id K2ESYV9IJsD7wagW for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 22:29:01 -0700 (PDT)
Date: Wed, 4 Jun 2008 01:28:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Questions for article
Message-ID: <20080604052859.GA6509@infradead.org>
References: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org> <4845C254.6050104@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4845C254.6050104@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Thomas King <kingttx@tomslinux.homelinux.org>, xfs@oss.sgi.com

On Tue, Jun 03, 2008 at 05:14:44PM -0500, Eric Sandeen wrote:
> It's also not clear to me that this is really a critical feature for
> large filesystems; space allocation is not done block by block per se in
> xfs, as Mr. Newman seems (?) to imply (?)  The block granularity is
> there throughout the fs but I'm not sure how much it matters in
> practice.  Dave...?

For streaming I/O workloads it doesn't matter anymore, see Dave's 2006
OLS talk.  The direct to bio I/O path mitigates any blocksize impact.
