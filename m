Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37971 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752906AbcL2TAO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Dec 2016 14:00:14 -0500
Received: by mail-it0-f54.google.com with SMTP id x2so217774813itf.1
        for <linux-xfs@vger.kernel.org>; Thu, 29 Dec 2016 11:00:14 -0800 (PST)
Subject: Re: [PATCH] xfs: don't print warnings when xfs_log_force fails
References: <1482999799-11776-1-git-send-email-hch@lst.de>
 <1482999799-11776-2-git-send-email-hch@lst.de>
 <d7b252bb-c5f8-eb18-b87e-73e8cbb81883@ieee.org>
 <20161229180933.GA16118@lst.de>
From: Alex Elder <elder@ieee.org>
Message-ID: <cb2e778f-8215-bb0f-ed02-7518f7729c1a@ieee.org>
Date: Thu, 29 Dec 2016 13:00:12 -0600
MIME-Version: 1.0
In-Reply-To: <20161229180933.GA16118@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On 12/29/2016 12:09 PM, Christoph Hellwig wrote:
> On Thu, Dec 29, 2016 at 08:42:08AM -0600, Alex Elder wrote:
>> This sounds like a good idea, though I haven't really reviewed
>> the code itself.  But I'd say a one line comment indicating why
>> errors from _xfs_log_force() are being ignored might be good.
> 
> I don't really know the answer, but it probabls is: some callers
> shouldn't ignore it and others can't handle it either.  Maybe I'll
> need to some further work in this area, but it's not really
> related to dropping the message.
> 

I actually misspoke.

What I *meant* to say was that a comment about why we don't
want to log a message in these spots might be nice.  But
now I'm less interested in that and more interested in
why errors from _xfs_log_force*() can be ignored.

Anyway, I won't claim to have reviewed this, but your change
makes sense to me.

					-Alex
