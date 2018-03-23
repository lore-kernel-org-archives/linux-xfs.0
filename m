Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39634 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751909AbeCWD33 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 23:29:29 -0400
Subject: Re: [PATCH 2/2 v5] fsck.xfs: allow forced repairs using xfs_repair
References: <20180315182850.36783-1-jtulak@redhat.com>
 <20180316170720.44227-1-jtulak@redhat.com>
 <709ab06b-4efc-2925-6621-f17ed4c048c6@sandeen.net>
 <20180323032548.GG4818@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f68aab96-7a08-26ee-2b9c-dfe291689506@sandeen.net>
Date: Thu, 22 Mar 2018 22:29:27 -0500
MIME-Version: 1.0
In-Reply-To: <20180323032548.GG4818@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org



On 3/22/18 10:25 PM, Darrick J. Wong wrote:
>> It make sense to check that it's available before running it, but I think
>> hardcoding paths runs the risk of missing it if it's somewhere unique.

> OTOH hardcoding the path (since we control where xfs_repair gets
> installed) means that we avoid the "someone poisoned PATH" attack.  I'm
> not sure I buy that argument since if you have root access you probably
> can just bind mount a garbage atop /sbin/xfs_repair, but eh.

But this is the initramfs, right?  Do we really have any idea where things
land?  Do initramfs paths follow the installed system paths?  (maybe?)

-Eric
