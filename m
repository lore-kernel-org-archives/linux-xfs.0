Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:7041 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755025AbeEaPHR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 11:07:17 -0400
Date: Thu, 31 May 2018 09:07:16 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: Question about Experimental of Filesystem DAX.
Message-ID: <20180531150716.GA19764@linux.intel.com>
References: <20180531112731.0CAC.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531112731.0CAC.E1E9C6FF@jp.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yasunori Goto <y-goto@jp.fujitsu.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 11:27:33AM +0900, Yasunori Goto wrote:
> Hello,
> 
> 
> I would like to know about the Experimental message of Filesystem DAX.
> --------------------------------------------------------
> DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> --------------------------------------------------------
> 
> AFAIK, the final issue of Filesystem DAX is metadata update problem, 
> and it is(will be?) solved by great effort of MAP_SYNC and
> "fix dma vs truncate/hole-punch" patch set. 
> So, I suppose that the Experimental message can be removed,
> but I'm not sure.
> 
> Is it possible?
> Otherwise, are there any other issues in Filesystem DAX yet?
> 
> If this is silly question, sorry for noise....
> 
> Thanks,
> ---
> Yasunori Goto

Adding in the XFS and ext4 developers, as it's really their call when to
remove this notice.

We've talked about this off and on for a long while, but IMHO we should remove
the EXPERIMENTAL warning.  The last few things that we had on our TODO list
before this was removed were:

1) Get consistent handling of the DAX mount option.  We currently have this,
as both filesystems will behave the same and fall back and remove the DAX
mount option if it is unsupported by the block device, etc.

2) Get consistent handling of the DAX inode option.  We currently have this,
as all DAX behavior now happens through the mount option.  If/when we
re-enable the per-inode DAX flag we should do it consistently for all DAX
enabled filesystems.

3) Make DAX work with other XFS features like reflink, etc.  This one isn't
done, but we at least disallow DAX with XFS features like reflink where it
could be an issue.  Darrick, do you still feel like we need to get these
working together to remove EXPERIMENTAL, or are you happy enough that we're
keeping them separated and that we're keeping user data safe?

Jan and the other ext4 guys, do you have any additional things you need done
before removing the EXPERIMENTAL warning from ext4 + DAX?
