Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388100AbfBNTKR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Feb 2019 14:10:17 -0500
Date: Thu, 14 Feb 2019 14:10:14 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190214191013.GA3420@redhat.com>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
 <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 10:25:07AM -0800, Dan Williams wrote:
> On Thu, Feb 14, 2019 at 5:46 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Wed 06-02-19 13:12:59, Dan Williams wrote:
> > [...]
> > > * Userfaultfd for file-backed mappings and DAX
> >
> > I assume that other topics are meant to be FS track but this one is MM,
> > right?
> 
> Yes, but I think it is the lowest priority of all the noted sub-topics
> in this proposal. The DAX-reflink discussion, where a given
> physical-page may need to be mapped into multiple inodes at different
> offsets, might be more fruitful to have as a joint discussion with MM.

Note that my generic page write protection work can be use for that ie
having a single page correspond to multiple different mapping with also
different offset within each mapping. While in my patchset i only solve
the mapping aliasing issue, the index can be solve in much the same way
because same thinking apply. Namely that when you work on a file you
know the mapping and file offset and thus the index and when you work on
the vma you know the mapping and offset within the vma which translate
to offset within the file. They are only few places that do not have the
informations available and those do not care about it.

I am just again working on my struct page mapping patchset as well as
the generic page write protection that sits on top. I hope to be able
to post the v2 in couple weeks. You can always look at my posting last
year to see more details.

Cheers,
Jérôme
