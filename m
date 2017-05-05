Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:50256 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbdEENTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 09:19:48 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 58FDB0C300796200 for linux-xfs@vger.kernel.org; Fri, 5 May 2017 15:19:46 +0200
Subject: Re: XFS and multiple mounts protection (aka preventing multiple  mounts)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 05 May 2017 15:19:45 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170505122547.6gvqmdoxfaqxh3mi@eorzea.usersys.redhat.com>
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
 <2e45f5c8-0b8f-ef99-a8a5-cd3ebb89911e@assyoma.it>
 <20170505122547.6gvqmdoxfaqxh3mi@eorzea.usersys.redhat.com>
Message-ID: <c5e42df06ff981bfd6a72cbc12f10d43@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

Il 05-05-2017 14:25 Carlos Maiolino ha scritto:
> 
> As far as I know, don't, I can always be wrong, but, I re-checked xfs
> superblock, and could not find anything that actually protects it.
> 

So, how do you protect iSCSI targets from erroneous multiple mount? Do 
you protect them only at the target/lun level (eg: access list on the 
target/lun)?

> 
> Eh, I really don't know much about EXT4, but this only works if the 
> clocks are
> properly adjusted (not really hard to achieve though), but still racy.
> 

I think that the mechanism tracks the relative change in the mmp 
structure, rather than absolute value. Sort of "look at it, sleep, 
relook, if the value changed, then does not mount"...

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
