Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:39596 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdEELwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 07:52:55 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr002msb.fastweb.it (8.5.140.05)
        id 58E21DDC015491EF for linux-xfs@vger.kernel.org; Fri, 5 May 2017 13:52:53 +0200
Received: from gdanti-laptop.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id 5A0482C9B33
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2017 13:52:53 +0200 (CEST)
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <2e45f5c8-0b8f-ef99-a8a5-cd3ebb89911e@assyoma.it>
Date: Fri, 5 May 2017 13:52:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 05/05/2017 13:32, Carlos Maiolino wrote:
>
> This is not true, XFS can't identify mounts on different systems. It is not a
> shared or clustered filesystem.
>

Ok, this confirm my finding.

To reiterate: there is *no* method to prevent multiple mounts in XFS, right?

> At the worst case, it would need to store something to disk saying the
> filesystem is already mounted, and the mount process would need to read it
> before actually mounting the filesystem. Nothing though would prevent a race
> between two systems, or even make the filesystem unmountable after a crash,
> needing something like xfs_repair to clean some "is_mounted" flag, which would
> trash one of the reasons why we have a journal (fast recovery without needing an
> fsck before mounting).
>

EXT4 uses a "keepalive" approach: enabling the "mmp" feature (which 
require kernel 3.10+), a specific on-disk structure is continuously 
(each 5 seconds, by default) updated with a timestamp by the mounting 
machine. If another machine tries to mount the filesystem, it sees the 
mmp structure changing and it refuse to mount.

It's not perfect, but better than nothing ;)

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
