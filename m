Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:40537 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdFJSJn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Jun 2017 14:09:43 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr003msb.fastweb.it (8.5.140.05)
        id 58BF8D440400F061 for linux-xfs@vger.kernel.org; Sat, 10 Jun 2017 20:09:41 +0200
Subject: It is safe to execute a fallocate on a opened and in-use  =?UTF-8?Q?file=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Jun 2017 20:09:40 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <85e83dbc8f31ecd79e018d595aa2e491@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi all,
I would like to understand if it is safe, or not, to execute a fallocate 
on a opened an possibly in-use file.

Scenario: a running Qemu/KVM virtual machine that need its RAW-image 
vdisk to be expanded.

I normally stop the virtual machine and issue "fallocate -l <newsize> 
<filename>", then I restart it. I wonder if I can skip the stop/start 
phases, going directly for the fallocate.

Reasoning on the question, I naively think that fallocating when the VM 
is writing on the file has the potential to cause corruption, due to 
this racing condition:
- I execute fallocate;
- the filesystem begins searching for to-be-allocated chunks, and finds 
one;
- the VM suddenly writes to the very same block found on the previous 
step;
- the filesystem continue allocating the previos block, accidentally 
discarding the just-written data.

This scenario can be avoided if the relevant critical path are protected 
with mutex (or equivalent structures). Is it the case?

In general, how to consider concurrent metadata updates for the same 
file/block? Should I expect file corruption, similar to concurrently 
writing data to the same file/block?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
