Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:57034 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932169AbdKONVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 08:21:38 -0500
Subject: Re: [RFC PATCH] iomap: report collisions between directio and
 buffered writes to userspace
References: <20171114214625.GB5119@magnolia>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <8aa299eb-e1c4-6d8e-f536-bf764661e1b2@applied-asynchrony.com>
Date: Wed, 15 Nov 2017 14:16:01 +0100
MIME-Version: 1.0
In-Reply-To: <20171114214625.GB5119@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 11/14/17 22:46, Darrick J. Wong wrote:
(snip)
> +static void iomap_warn_stale_pagecache(struct inode *inode)
> +{
> +	errseq_set(&inode->i_mapping->wb_err, -EIO);
> +	pr_crit_ratelimited("Stale pagecache contents after collision "
> +			    "between direct and buffered write!\n");
> +}

In this form the error message is IMHO useless since it tells me
neither the file in question nor the misbehaving application.
"Something went wrong somewhere" is not actionable information
and in practice will only be ignored.

Since you already have the inode in question at hand, print at least
the full path + filename so that it's clear where things are going
wrong. Usually that will let people deduce which application is
misbehaving.

-h
