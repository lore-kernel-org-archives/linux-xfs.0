Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52773 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754038AbdCBInR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 03:43:17 -0500
Date: Thu, 2 Mar 2017 09:42:23 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: mm allocation failure and hang when running xfstests generic/269
 on xfs
Message-ID: <20170302084222.GA1404@dhcp22.suse.cz>
References: <20170301044634.rgidgdqqiiwsmfpj@XZHOUW.usersys.redhat.com>
 <20170302003731.GB24593@infradead.org>
 <20170302051900.ct3xbesn2ku7ezll@XZHOUW.usersys.redhat.com>
 <d4c2cf89-8d82-ea78-b742-5bf6923a69c1@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4c2cf89-8d82-ea78-b742-5bf6923a69c1@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiong Zhou <xzhou@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu 02-03-17 12:17:47, Anshuman Khandual wrote:
> On 03/02/2017 10:49 AM, Xiong Zhou wrote:
> > On Wed, Mar 01, 2017 at 04:37:31PM -0800, Christoph Hellwig wrote:
> >> On Wed, Mar 01, 2017 at 12:46:34PM +0800, Xiong Zhou wrote:
> >>> Hi,
> >>>
> >>> It's reproduciable, not everytime though. Ext4 works fine.
> >> On ext4 fsstress won't run bulkstat because it doesn't exist.  Either
> >> way this smells like a MM issue to me as there were not XFS changes
> >> in that area recently.
> > Yap.
> > 
> > First bad commit:
> > 
> > commit 5d17a73a2ebeb8d1c6924b91e53ab2650fe86ffb
> > Author: Michal Hocko <mhocko@suse.com>
> > Date:   Fri Feb 24 14:58:53 2017 -0800
> > 
> >     vmalloc: back off when the current task is killed
> > 
> > Reverting this commit on top of
> >   e5d56ef Merge tag 'watchdog-for-linus-v4.11'
> > survives the tests.
> 
> Does fsstress test or the system hang ? I am not familiar with this
> code but If it's the test which is getting hung and its hitting this
> new check introduced by the above commit that means the requester is
> currently being killed by OOM killer for some other memory allocation
> request.

Well, not exactly. It is sufficient for it to be _killed_ by SIGKILL.
And for that it just needs to do a group_exit when one thread was still
in the kernel (see zap_process). While I can change this check to
actually do the oom specific check I believe a more generic
fatal_signal_pending is the right thing to do here. I am still not sure
what is the actual problem here, though. Could you be more specific
please?

-- 
Michal Hocko
SUSE Labs
