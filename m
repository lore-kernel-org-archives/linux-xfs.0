Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:50866 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751642AbdFJWAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Jun 2017 18:00:12 -0400
Subject: Re: It is safe to execute a fallocate on a opened and in-use  =?UTF-8?Q?=20file=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Jun 2017 00:00:06 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170610211822.GN4530@birch.djwong.org>
References: <85e83dbc8f31ecd79e018d595aa2e491@assyoma.it>
 <20170610211822.GN4530@birch.djwong.org>
Message-ID: <cb698069da3f4a5446785887ef096f6a@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 10-06-2017 23:18 Darrick J. Wong ha scritto:
> 
> Yes, writes and fallocates are serialized with each other to avoid 
> corruption.
> 

Great. Is this behavior valid for all filesystem (ie: it is implemented 
on the VFS layer) or is it filesystem-specific?

> 
> How do you get qemu to announce the disk size change the guest?
> 

You can do that via virsh blockresize which, in turn, taps on qemu 
monitor (which can even be used directly, without libvirt intervention). 
 From virsh man page:

"blockresize domain path size
Resize a block device of domain while the domain is running, path 
specifies the absolute path of the block device; it corresponds to a 
unique target name (<target dev='name'/>) or source file (<source 
file='name'/>) for one of the disk devices attached to domain (see also 
domblklist for listing these names)."

Thanks.

> --D
> 
>> In general, how to consider concurrent metadata updates for the same
>> file/block? Should I expect file corruption, similar to concurrently 
>> writing
>> data to the same file/block?
>> 
>> Thanks.
>> 
>> --
>> Danti Gionatan
>> Supporto Tecnico
>> Assyoma S.r.l. - www.assyoma.it
>> email: g.danti@assyoma.it - info@assyoma.it
>> GPG public key ID: FF5F32A8
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
