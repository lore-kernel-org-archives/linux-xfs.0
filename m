Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f53.google.com ([209.85.210.53]:37555 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390464AbfBNSZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 13:25:19 -0500
Received: by mail-ot1-f53.google.com with SMTP id b3so12162969otp.4
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 10:25:18 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
In-Reply-To: <20190214134622.GG4525@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 10:25:07 -0800
Message-ID: <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 5:46 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Wed 06-02-19 13:12:59, Dan Williams wrote:
> [...]
> > * Userfaultfd for file-backed mappings and DAX
>
> I assume that other topics are meant to be FS track but this one is MM,
> right?

Yes, but I think it is the lowest priority of all the noted sub-topics
in this proposal. The DAX-reflink discussion, where a given
physical-page may need to be mapped into multiple inodes at different
offsets, might be more fruitful to have as a joint discussion with MM.
