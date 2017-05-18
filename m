Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51727 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752823AbdERP5e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 11:57:34 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4IFvWbc023573
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 15:57:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4IFvWnZ032216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 15:57:32 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4IFvV7H018276
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 15:57:32 GMT
Date: Thu, 18 May 2017 08:57:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Do we need a way to force xfsaild to run?
Message-ID: <20170518155730.GY4519@birch.djwong.org>
References: <20170518142159.gkr6be4dralc6xiq@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518142159.gkr6be4dralc6xiq@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, May 18, 2017 at 04:21:59PM +0200, Carlos Maiolino wrote:
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
> 
> Anybody else might have interest on it or maybe this is just a waste of time?

"Run" the xfsaild as in 'push all the AIL items out to disk'?

I think xfs_freeze -f (followed immediately by xfs_freeze -u) will push
the AIL as part of the freezing process... though that might be more
work than you're looking for...?

--D

> 
> Cheers
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
