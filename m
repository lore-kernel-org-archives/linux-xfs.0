Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750717AbdCBGaU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 01:30:20 -0500
Date: Thu, 2 Mar 2017 13:19:00 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: mm allocation failure and hang when running xfstests generic/269
 on xfs
Message-ID: <20170302051900.ct3xbesn2ku7ezll@XZHOUW.usersys.redhat.com>
References: <20170301044634.rgidgdqqiiwsmfpj@XZHOUW.usersys.redhat.com>
 <20170302003731.GB24593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302003731.GB24593@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, mhocko@suse.com
Cc: Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Mar 01, 2017 at 04:37:31PM -0800, Christoph Hellwig wrote:
> On Wed, Mar 01, 2017 at 12:46:34PM +0800, Xiong Zhou wrote:
> > Hi,
> > 
> > It's reproduciable, not everytime though. Ext4 works fine.
> 
> On ext4 fsstress won't run bulkstat because it doesn't exist.  Either
> way this smells like a MM issue to me as there were not XFS changes
> in that area recently.

Yap.

First bad commit:

commit 5d17a73a2ebeb8d1c6924b91e53ab2650fe86ffb
Author: Michal Hocko <mhocko@suse.com>
Date:   Fri Feb 24 14:58:53 2017 -0800

    vmalloc: back off when the current task is killed

Reverting this commit on top of
  e5d56ef Merge tag 'watchdog-for-linus-v4.11'
survives the tests.
