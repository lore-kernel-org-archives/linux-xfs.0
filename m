Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:55028 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdJKWXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 18:23:22 -0400
Received: by mail-oi0-f53.google.com with SMTP id u130so5529900oib.11
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 15:23:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011200603.27442-17-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-17-jack@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 15:23:21 -0700
Message-ID: <CAPcyv4h4VdGJ0zV6cOFOs6=ufo49WDgSUbmmL2cmDVdc1edraw@mail.gmail.com>
Subject: Re: [PATCH 16/19] ext4: Support for synchronous DAX faults
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
> We return IOMAP_F_NEEDDSYNC flag from ext4_iomap_begin()

I assume this a stale changelog from a previous version and should be
VM_FAULT_NEEDDSYNC?
