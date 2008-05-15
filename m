Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 07:10:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FEAYUM031928
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 07:10:36 -0700
Date: Thu, 15 May 2008 10:11:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080515141121.GA14198@infradead.org>
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515045700.GA4328@infradead.org> <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com> <DCB15FFF-F942-47BD-B8FB-38AADC24B9D6@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DCB15FFF-F942-47BD-B8FB-38AADC24B9D6@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Barry Naujok <bnaujok@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, May 15, 2008 at 02:43:44PM +0100, Anton Altaparmakov wrote:
> Yes, and you can get the performance back if you allow negative dentries to 
> be created.  You just have to make sure that every time a directory entry 
> is created in directory X, all negative dentries which are children of 
> directory X are thrown away.

We might even be able to optimize this a little by calling d_compare on
each alias to see if it hashes down to the same one down in the fs.
