Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755508AbeDWPet (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 11:34:49 -0400
Date: Mon, 23 Apr 2018 11:34:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS and Memory allocation
Message-ID: <20180423153447.GI43600@bfoster.bfoster>
References: <CA+1g8semVirCEfbQRNt8h-Cj7NV7p1FYP76XLjH4vVMVU7F=aw@mail.gmail.com>
 <20180423143605.GH43600@bfoster.bfoster>
 <CA+1g8seTYOgERkM=dnDZFDX3QZQ1w6pMGOw1HVC-tdQxVON=vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1g8seTYOgERkM=dnDZFDX3QZQ1w6pMGOw1HVC-tdQxVON=vA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrea del Monaco <andrea.delmonaco@clustervision.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 05:21:57PM +0200, Andrea del Monaco wrote:
> Hi Brian,
> 
> Thanks a lot for your fast reply.
> I will then try to update the package - even though i could notice
> that it is not available in Centos repos yet.
> 

Note that this update is not yet in RHEL kernels (and thus not in
CentOS). You'll probably need to file a distro bug for that. In the
meantime, (if you confirm the problem) you may need to do something like
look into reducing the extent count of the files that tend to cause
this.

Brian

> I have increased the error_level. Let's see what do we get.
> 
> Regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
