Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406868AbfBNUeP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Feb 2019 15:34:15 -0500
Date: Thu, 14 Feb 2019 15:34:12 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190214203411.GC3420@redhat.com>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
 <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
 <20190214191013.GA3420@redhat.com>
 <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
 <20190214200840.GB12668@bombadil.infradead.org>
 <CAPcyv4hsDqvrV5yiDq8oWPuWb3WpuCEk_HB4qBxfiDpUwo75QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4hsDqvrV5yiDq8oWPuWb3WpuCEk_HB4qBxfiDpUwo75QQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 12:20:11PM -0800, Dan Williams wrote:
> On Thu, Feb 14, 2019 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Feb 14, 2019 at 11:31:24AM -0800, Dan Williams wrote:
> > > On Thu, Feb 14, 2019 at 11:10 AM Jerome Glisse <jglisse@redhat.com> wrote:
> > > > I am just again working on my struct page mapping patchset as well as
> > > > the generic page write protection that sits on top. I hope to be able
> > > > to post the v2 in couple weeks. You can always look at my posting last
> > > > year to see more details.
> > >
> > > Yes, I have that in mind as one of the contenders. However, it's not
> > > clear to me that its a suitable fit for filesystem-reflink. Others
> > > have floated the 'page proxy' idea, so it would be good to discuss the
> > > merits of the general approaches.
> >
> > ... and my preferred option of putting pfn entries in the page cache.
> 
> Another option to include the discussion.
> 
> > Or is that what you meant by "page proxy"?
> 
> Page proxy would be an object that a filesystem could allocate to
> point back to a single physical 'struct page *'. The proxy would
> contain an override for page->index.

Note that generic page write protection has such object, kind of like
stable_node in KSM. You overwritte page->mapping to point to this
generic struct which has a pointer to set of callback so that whatever
is protecting the page can offer API to break protection (break sharing
here).

So instead of having struct proxy_page -> struct page you would have the
reverse: struct page -> struct proxy and so you do not have to change
much in all the file system beside removing the reliance on page->mapping
which is what most of my patches are about.

Cheers,
Jérôme
