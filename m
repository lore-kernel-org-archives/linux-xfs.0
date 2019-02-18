Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33378 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391011AbfBRSRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 13:17:42 -0500
Received: by mail-ot1-f66.google.com with SMTP id i20so29902164otl.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Feb 2019 10:17:41 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <3eb67ffa-76c9-aa66-d162-d4e209330f48@gmail.com>
In-Reply-To: <3eb67ffa-76c9-aa66-d162-d4e209330f48@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Feb 2019 10:17:30 -0800
Message-ID: <CAPcyv4grMnrviSDJrA5FQOFvxuAMUXoKvgNpdy9sF9zi+OHJNA@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Sun, Feb 17, 2019 at 12:29 PM Ric Wheeler <ricwheeler@gmail.com> wrote:
>
> On 2/6/19 4:12 PM, Dan Williams wrote:
> > Before people get too excited this isn't a proposal to kill DAX. The
> > topic proposal is a discussion to resolve lingering open questions
> > that currently motivate ext4 and xfs to scream "EXPERIMENTAL" when the
> > current DAX facilities are enabled. The are 2 primary concerns to
> > resolve. Enumerate the remaining features/fixes, and identify a path
> > to implement it all without regressing any existing application use
> > cases.
> >
> > An enumeration of remaining projects follows, please expand this list
> > if I missed something:
> >
> > * "DAX" has no specific meaning by itself, users have 2 use cases for
> > "DAX" capabilities: userspace cache management via MAP_SYNC, and page
> > cache avoidance where the latter aspect of DAX has no current api to
> > discover / use it. The project is to supplement MAP_SYNC with a
> > MAP_DIRECT facility and MADV_SYNC / MADV_DIRECT to indicate the same
> > dynamically via madvise. Similar to O_DIRECT, MAP_DIRECT would be an
> > application hint to avoid / minimiize page cache usage, but no strict
> > guarantee like what MAP_SYNC provides.
>
>
> Sounds like a great topic to me. Having just gone through a new round of USENIX
> paper reviews, it is interesting to see how many academic systems are being
> pitched in this space (and most of them don't mention the kernel based xfs/ext4
> with dax).

Makes sense, the current fsdax facility is chasing feature
deficiencies relative to device-dax (longterm pin support) and nova
(dax techniques for fs-metadata).
