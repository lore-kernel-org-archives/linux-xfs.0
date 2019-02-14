Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33487 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390551AbfBNUUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 15:20:23 -0500
Received: by mail-ot1-f68.google.com with SMTP id i20so12824786otl.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 12:20:22 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz> <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
 <20190214191013.GA3420@redhat.com> <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
 <20190214200840.GB12668@bombadil.infradead.org>
In-Reply-To: <20190214200840.GB12668@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 12:20:11 -0800
Message-ID: <CAPcyv4hsDqvrV5yiDq8oWPuWb3WpuCEk_HB4qBxfiDpUwo75QQ@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Feb 14, 2019 at 11:31:24AM -0800, Dan Williams wrote:
> > On Thu, Feb 14, 2019 at 11:10 AM Jerome Glisse <jglisse@redhat.com> wrote:
> > > I am just again working on my struct page mapping patchset as well as
> > > the generic page write protection that sits on top. I hope to be able
> > > to post the v2 in couple weeks. You can always look at my posting last
> > > year to see more details.
> >
> > Yes, I have that in mind as one of the contenders. However, it's not
> > clear to me that its a suitable fit for filesystem-reflink. Others
> > have floated the 'page proxy' idea, so it would be good to discuss the
> > merits of the general approaches.
>
> ... and my preferred option of putting pfn entries in the page cache.

Another option to include the discussion.

> Or is that what you meant by "page proxy"?

Page proxy would be an object that a filesystem could allocate to
point back to a single physical 'struct page *'. The proxy would
contain an override for page->index.
