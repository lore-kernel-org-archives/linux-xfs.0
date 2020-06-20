Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A739CC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 02:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6E222D70
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 02:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731696AbgFTCKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 22:10:09 -0400
Received: from p10link.net ([80.68.89.68]:44063 "EHLO P10Link.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730293AbgFTCKI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jun 2020 22:10:08 -0400
Received: from [192.168.1.2] (unknown [94.2.179.121])
        by P10Link.net (Postfix) with ESMTPSA id 4D93B40C00F;
        Sat, 20 Jun 2020 03:10:06 +0100 (BST)
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
        953537@bugs.debian.org
References: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
 <20200619044734.GB11245@magnolia>
 <ea662f0b-7e73-0bbe-33aa-963389b9e215@sandeen.net>
 <20200619224325.GP2005@dread.disaster.area>
From:   peter green <plugwash@p10link.net>
Message-ID: <3ecca5f3-f448-195a-4fd7-d078139972f9@p10link.net>
Date:   Sat, 20 Jun 2020 03:10:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200619224325.GP2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Putting the debian bug back in cc, previous mails are visible at https://marc.info/?l=linux-xfs&m=159253950420613&w=2

On 19/06/2020 23:43, Dave Chinner wrote:

> Isn't the configure script supposed to handle install locations?
> Both xfsprogs and xfsdump have this in their include/builddefs.in:
> 
> PKG_ROOT_SBIN_DIR = @root_sbindir@
> PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
> 
> So the actual install locations are coming from the autoconf setup
> the build runs under. Looking in configure.ac in xfsprogs and
> xfsdump, they both do the same thing:
> 
The issue is that xfsdump installs the programs in /sbin but it *also* creates symlinks in /usr/sbin,
presumablly at some point the binaries were moved to /sbin but the developers wanted to keep
packages that hardcoded the paths working.

Those symlinks are suppressed if installing directly to a merged-usr system, which is fine for
end-users installing the program directly but isn't useful if installing to a destination dir for
packaing purposed.
