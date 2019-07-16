Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbfGPNau (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jul 2019 09:30:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F40581F18
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 13:30:50 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34D825C260
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 13:30:50 +0000 (UTC)
Subject: Re: [PATCH 4/4] xfsprogs: don't use enum for buffer flags
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
 <9a4275dd-3e33-1fbb-efd4-57db6f646bff@redhat.com>
 <20190716113805.jx4nch3aclzwjrrc@pegasus.maiolino.io>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <f5b0d9da-ac2b-4337-4462-4cb4e6d1fab3@redhat.com>
Date: Tue, 16 Jul 2019 08:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <20190716113805.jx4nch3aclzwjrrc@pegasus.maiolino.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

On 7/16/19 6:38 AM, Carlos Maiolino wrote:
>> +typedef unsigned int xfs_buf_flags_t;
> I'd argue about the need of hiding an unsigned int into a typedef, which IMHO
> doesn't look necessary here, but I also don't see why not if your main reason is
> try to care about your sanity and bring xfsprogs code closer to kernel, other
> than that, the patch is fine and you can add my review tag with or without the
> typedef.
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Cheers
> 

The point is to match the kernel code, warts and all.

thanks,
-Eric
