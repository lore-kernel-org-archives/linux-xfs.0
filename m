Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32963 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968442AbdAIRV0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 12:21:26 -0500
Received: by mail-oi0-f65.google.com with SMTP id j15so12848357oih.0
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2017 09:21:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170109155158.GA19396@infradead.org>
References: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
 <1483967189-27313-2-git-send-email-amir73il@gmail.com> <20170109155158.GA19396@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Jan 2017 19:21:25 +0200
Message-ID: <CAOQ4uxi4AWSN89MtZH6f0B9aC_AMmC6bxbUCAh9LMU4G+Z9U1A@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] xfs: fix the size of xfs_mode_to_ftype table
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 9, 2017 at 5:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jan 09, 2017 at 03:06:27PM +0200, Amir Goldstein wrote:
>> Fix the size of the xfs_mode_to_ftype conversion table,
>> which was too small to handle an invalid value of mode=S_IFMT.
>>
>> Use a convenience macro S_DT(mode) to convert from
>> mode to dirent file type and change the name of the table
>> to xfs_dtype_to_ftype to correctly describe its index values.
>
> This looks like an awful lot of magic.  Would a switch statement
> generate so much worse code?

I doubt it really matters that much, so it's down to a matter of taste.
I personally like the existing map table better than switch if anyone cares ;-)
but I think that the strongest argument in favor of the existing code
is that it works, so no reason to change it.
IMHO, this minor fix and cleanup do not justify switching the code over to
switch statement.
