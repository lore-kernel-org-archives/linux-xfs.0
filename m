Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38944 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753372AbdIRRhg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 13:37:36 -0400
Subject: Re: [PATCH v2 2/2] mkfs: pass a custom cowextsize into the created
 filesystem
References: <20170901164035.GF3775@magnolia> <20170904174535.GI4671@magnolia>
 <0da45d14-7c4a-9cb9-4c0c-6abc309c5001@sandeen.net>
 <20170918172251.GE6540@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <92956c49-6d6e-c2a5-97c6-38460a25a357@sandeen.net>
Date: Mon, 18 Sep 2017 12:37:35 -0500
MIME-Version: 1.0
In-Reply-To: <20170918172251.GE6540@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>



On 9/18/17 12:22 PM, Darrick J. Wong wrote:
>>> @@ -254,15 +312,17 @@ libxfs_ialloc(
>>>  	ip->i_d.di_extsize = pip ? 0 : fsx->fsx_extsize;
>>>  	ip->i_d.di_dmevmask = 0;
>>>  	ip->i_d.di_dmstate = 0;
>>> -	ip->i_d.di_flags = pip ? 0 : fsx->fsx_xflags;
>>> +	ip->i_d.di_flags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
>> is this a bugfix?
> No.
> 
> Prior to this patch, the only fsx_xflags bits that mkfs could set are
> the ones that correspond exactly to di_flags bits, so it was fine to set
> them directly.  Subtle and annoying, but it worked.
> 
> However, the xfs_mkfs.c changes enable us to set FS_XFLAG_COWEXTSIZE,
> which doesn't correspond to a di_flags bit, so now we need translation
> functions to return the correct di_flags/di_flags2 values for the given
> fsx_xflags.

Oh, ok.  Before I guess it was only XFS_DIFLAG_RTINHERIT,
XFS_DIFLAG_PROJINHERIT and XFS_DIFLAG_EXTSZINHERIT.

Fair enough, maybe I should have seen that.  Thanks.

(I might note it in the changelog on the way in, though, since
it's subtle and annoying) ;)

-Eric
