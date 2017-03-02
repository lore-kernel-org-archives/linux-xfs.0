Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44419 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753683AbdCBAhc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2017 19:37:32 -0500
Date: Wed, 1 Mar 2017 16:37:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mm allocation failure and hang when running xfstests generic/269
 on xfs
Message-ID: <20170302003731.GB24593@infradead.org>
References: <20170301044634.rgidgdqqiiwsmfpj@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170301044634.rgidgdqqiiwsmfpj@XZHOUW.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Mar 01, 2017 at 12:46:34PM +0800, Xiong Zhou wrote:
> Hi,
> 
> It's reproduciable, not everytime though. Ext4 works fine.

On ext4 fsstress won't run bulkstat because it doesn't exist.  Either
way this smells like a MM issue to me as there were not XFS changes
in that area recently.
