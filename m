Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40946 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753348AbdHXSn6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 14:43:58 -0400
Subject: Re: [PATCH 6/6] fiemap: Fix semantics of max_extents (-n arguments)
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
 <1503575272-28263-7-git-send-email-nborisov@suse.com>
 <20170824175159.GH4796@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <94192a37-fd08-c8fe-747b-25cd77cfe852@sandeen.net>
Date: Thu, 24 Aug 2017 13:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <20170824175159.GH4796@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com

On 8/24/17 12:51 PM, Darrick J. Wong wrote:
> On Thu, Aug 24, 2017 at 02:47:52PM +0300, Nikolay Borisov wrote:
>> Currently the semantics of the -n argument are a bit idiosyncratic. We want the
>> argument to be the limit of extents that are going to be output by the tool. This
>> is clearly broken now as evident from the following example on a fragmented file:
> 
> Please update the documentation, since the xfs_io fiemap section refers
> readers to xfs_bmap(8), which says:
> 
> "If this [-n] option is given, xfs_bmap obtains the extent list of the
> file in groups of num_extents extents."
> 
> Which is no longer correct, because now -n limits the number of records
> output, if I'm reading this patch correctly.  TBH I think -n for bmap is
> also wrong...

Yep.  That's fine as patch 7/6 I think - this patch doesn't make the
documentation any more wrong than it already is, but it does need to be
fixed in any case.

> The other patches leading up to this one have been
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!  They looked good to me too modulo the one problem I found.

-Eric
