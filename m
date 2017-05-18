Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24643 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755323AbdEROcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 10:32:24 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4IEWNg6030306
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 14:32:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4IEWMvI012543
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 14:32:23 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v4IEWKU1020101
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 14:32:21 GMT
Subject: Re: Do we need a way to force xfsaild to run?
References: <20170518142159.gkr6be4dralc6xiq@eorzea.usersys.redhat.com>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <2a1d273d-da74-bdc9-2c8d-06311cb77d4f@oracle.com>
Date: Thu, 18 May 2017 22:32:11 +0800
MIME-Version: 1.0
In-Reply-To: <20170518142159.gkr6be4dralc6xiq@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 2017年05月18日 22:21, Carlos Maiolino wrote:
> Hi,
>
> This is something I was thinking while working on that buffer retry stuff.
>
> Currently, we have no way to force xfsaild to run, and I was wondering if
> somebody has any opinion if it would be useful to create a new xfsctl, to start
> xfsaild for debugging purposes, using xfs_io to trigger it.
>
> My specific use case is while testing the code I've been working on for the
> buffer retry stuff, where, I need to wait xfsaild to run to trigger the bug,
> adding a way to force it, in this case at least, would be useful for me, I could
> work on that, but only if somebody else can actually think this to be
> interesting, adding a new xfsctl just for 'me' does not sound worth the time :)

For the debugging purpose how about mkfs with a small size of log
for instance 50MB and then use benchmark tools like fs_mark to
fill the log quickly(write lots of small files instead of a single
huge file), then the xfsaild will run frequently :)

Thanks
Shan Hai
> Anybody else might have interest on it or maybe this is just a waste of time?
>
> Cheers
>

