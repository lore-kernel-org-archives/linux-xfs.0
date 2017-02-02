Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34090 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdBBTd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 14:33:26 -0500
Received: by mail-oi0-f66.google.com with SMTP id w144so1978129oiw.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Feb 2017 11:33:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170202174723.GA7760@lst.de>
References: <20170202162456.20574-1-hch@lst.de> <20170202174547.GN9134@birch.djwong.org>
 <20170202174723.GA7760@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 2 Feb 2017 21:33:20 +0200
Message-ID: <CAOQ4uxgOuee44qmHvXRnGw6KFx6HSwPytNUoURMCfnd=-zXGxw@mail.gmail.com>
Subject: Re: [PATCH] xfs: update ctime and mtime on clone destinatation inodes
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Feb 2, 2017 at 7:47 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Feb 02, 2017 at 09:45:47AM -0800, Darrick J. Wong wrote:
>> On Thu, Feb 02, 2017 at 05:24:56PM +0100, Christoph Hellwig wrote:
>> > We're changing both metadata and data, so we need to update the
>> > timestamps.   This follows existing btrfs behavior.
>>
>> /me wonders, should the mtime change if we're deduping?  We're
>> definitely changing metadata, but we shouldn't be making any
>> user-visible changes to the file data.
>
> Good point - we're hitting this from the dedup path as well.
> I think we should not be updating mtime for dedupe.

Since CAP_ADMIN is allowed to dedup to an O_RDONLY dest
updating mtime would be even creepier.
