Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:51349 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdJTDSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 23:18:39 -0400
Received: by mail-yw0-f193.google.com with SMTP id k3so5315231ywk.8
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2017 20:18:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171019200626.GN4755@magnolia>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-18-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxiuFqoHAvJrLOds3w2dXE2nPyBh=uZusp5JxfOf_3cq-w@mail.gmail.com> <20171019200626.GN4755@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Oct 2017 06:18:38 +0300
Message-ID: <CAOQ4uxiHDWJBcqxPjznP2oyNRruGreM7J8AUoRHr_FDk3VVajQ@mail.gmail.com>
Subject: Re: [PATCH 17/17] Add the parent pointer support to the superblock
 version 5.
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>

On Thu, Oct 19, 2017 at 11:06 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Oct 19, 2017 at 06:57:04AM +0300, Amir Goldstein wrote:
>> On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
>> <allison.henderson@oracle.com> wrote:
>> > [dchinner: forward ported and cleaned up]
>> > [achender: rebased and added parent pointer attribute to
>> >            compatible attributes mask]
>> >
>> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
>> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> > ---
>> > v2: remove unrelated type clean up in xfs_format.h
>>
>> I'm curious how XFS_SB_VERSION2_PARENTBIT fits into the picture?
>> old relic?
>
> A feature bit most probably used by the SGI XFS parent pointer
> implementation.  We don't want to reuse that bit and thereby crash into
> their code.
>

Ah, I was not aware that parallel universe exists.
Perhaps worth a comment near definition of XFS_SB_VERSION2_PARENTBIT
so it won't be confused with Linux parent pointers.

Amir.
