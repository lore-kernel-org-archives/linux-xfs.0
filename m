Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:50230 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdEJITl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 04:19:41 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr003msb.fastweb.it (8.5.140.05)
        id 58BF8D44029FB70F for linux-xfs@vger.kernel.org; Wed, 10 May 2017 10:19:39 +0200
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
 <2e45f5c8-0b8f-ef99-a8a5-cd3ebb89911e@assyoma.it>
 <20170505122547.6gvqmdoxfaqxh3mi@eorzea.usersys.redhat.com>
 <c5e42df06ff981bfd6a72cbc12f10d43@assyoma.it>
 <20170510081235.qjez42rvpdkzspf5@eorzea.usersys.redhat.com>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <abdbde12-e17c-c90c-770c-7aa31888f070@assyoma.it>
Date: Wed, 10 May 2017 10:19:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170510081235.qjez42rvpdkzspf5@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

On 10/05/2017 10:12, Carlos Maiolino wrote:
>
> Well, having a planned infra-structure is a way, and using UUIDs for mounting
> the filesystems are two good ways to avoid mistakes with multiple mounts. UUIDs
> are unique for each filesystem, so even if the device name changes between
> boots, you can still be sure to mount the correct filesystem on the correct
> system by using their UUIDs
>

Sure, but this does not protect, for example, from a cloned virtual 
machine which mount a remote iSCSI path and which is started without 
knowing that. When the cloned machine tries to mount the remote path, 
bad things can happen.

The most obvious protection is at the iSCSI level, but only the old IETD 
SCSI target daemon seem to provide such as feature by the virtue of the 
"MaxSessions" parameter (I have not tested it, anyway). Another 
protection at the iSCSI level is granted by SCSI reservation, which 
works quite well but are somewhat harder to setup.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
