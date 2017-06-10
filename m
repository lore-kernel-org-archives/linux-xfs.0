Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32992 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdFJVSe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Jun 2017 17:18:34 -0400
Date: Sat, 10 Jun 2017 14:18:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: It is safe to execute a fallocate on a opened and in-use  file?
Message-ID: <20170610211822.GN4530@birch.djwong.org>
References: <85e83dbc8f31ecd79e018d595aa2e491@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85e83dbc8f31ecd79e018d595aa2e491@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 10, 2017 at 08:09:40PM +0200, Gionatan Danti wrote:
> Hi all,
> I would like to understand if it is safe, or not, to execute a fallocate on
> a opened an possibly in-use file.
> 
> Scenario: a running Qemu/KVM virtual machine that need its RAW-image vdisk
> to be expanded.
> 
> I normally stop the virtual machine and issue "fallocate -l <newsize>
> <filename>", then I restart it. I wonder if I can skip the stop/start
> phases, going directly for the fallocate.
> 
> Reasoning on the question, I naively think that fallocating when the VM is
> writing on the file has the potential to cause corruption, due to this
> racing condition:
> - I execute fallocate;
> - the filesystem begins searching for to-be-allocated chunks, and finds one;
> - the VM suddenly writes to the very same block found on the previous step;
> - the filesystem continue allocating the previos block, accidentally
> discarding the just-written data.
> 
> This scenario can be avoided if the relevant critical path are protected
> with mutex (or equivalent structures). Is it the case?

Yes, writes and fallocates are serialized with each other to avoid corruption.

How do you get qemu to announce the disk size change the guest?

--D

> In general, how to consider concurrent metadata updates for the same
> file/block? Should I expect file corruption, similar to concurrently writing
> data to the same file/block?
> 
> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
