Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36277 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758172AbdKOSyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 13:54:36 -0500
Date: Wed, 15 Nov 2017 10:54:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171115185428.GF5119@magnolia>
References: <20171114214625.GB5119@magnolia>
 <8aa299eb-e1c4-6d8e-f536-bf764661e1b2@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8aa299eb-e1c4-6d8e-f536-bf764661e1b2@applied-asynchrony.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 15, 2017 at 02:16:01PM +0100, Holger Hoffstätte wrote:
> On 11/14/17 22:46, Darrick J. Wong wrote:
> (snip)
> > +static void iomap_warn_stale_pagecache(struct inode *inode)
> > +{
> > +	errseq_set(&inode->i_mapping->wb_err, -EIO);
> > +	pr_crit_ratelimited("Stale pagecache contents after collision "
> > +			    "between direct and buffered write!\n");
> > +}
> 
> In this form the error message is IMHO useless since it tells me
> neither the file in question nor the misbehaving application.
> "Something went wrong somewhere" is not actionable information
> and in practice will only be ignored.
> 
> Since you already have the inode in question at hand, print at least
> the full path + filename so that it's clear where things are going
> wrong. Usually that will let people deduce which application is
> misbehaving.

The whole point of the errseq_set call in this patch is to record the
write collision so that all the writers of this file will receive an EIO
the next time they try to flush the file.  You can pinpoint exactly
which fd(s) in which application(s) caused the problem.  The old dmesg
spew only captured which program issued the dio write.

(And the whole point of this patch is to see what people think about
that change of behavior w.r.t. us no longer letting userspace silently
corrupt the file...)

--D

> -h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
