Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751015AbdE2J2W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 May 2017 05:28:22 -0400
Subject: Re: request for inclusion of 2 xfs patches
From: Nikolay Borisov <nborisov@suse.com>
References: <89781cfb-b826-8d01-d054-f70b0e2d8439@suse.com>
Message-ID: <d4f07925-a558-cf4a-fd1f-b570d17ffd12@suse.com>
Date: Mon, 29 May 2017 12:28:19 +0300
MIME-Version: 1.0
In-Reply-To: <89781cfb-b826-8d01-d054-f70b0e2d8439@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>



On 29.05.2017 12:27, Nikolay Borisov wrote:
> Hello, 
> 
> I'd like to request the following two patches to be 
> included in 4.4 stable: 
> 
> 0facef7fb053 ("xfs: in _attrlist_by_handle, copy the cursor back to userspace")
> 
> 2a6fba6d2311 ("xfs: only return -errno or success from attr ->put_listent")
> 
> The fix a failure in xfstest/269 and also enable the xfs' XFS_IOC_ATTRLIST_BY_HANDLE
> ioctl to function properly. The first commit applies cleanly, whereas the second has 
> a minor conflict due t spacing. Backport is attached. 
> 

Please omit my Acked-by tagged when applying the backport
