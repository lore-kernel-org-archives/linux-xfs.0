Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr011msb.fastweb.it ([85.18.95.108]:59578 "EHLO
        mr011msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbeBZVj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Feb 2018 16:39:26 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Feb 2018 22:39:22 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180226213102.GD19312@magnolia>
References: <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
 <20180226172601.GC19312@magnolia>
 <2f48d103c0a6eff6c0a1136057e828b6@assyoma.it>
 <20180226213102.GD19312@magnolia>
Message-ID: <911d43a3fddd91174748f2b508cc3502@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, g.danti@assyoma.it

Il 26-02-2018 22:31 Darrick J. Wong ha scritto:
> I believe qemu-ga takes care of guest fs freeze inside the guest,
> and you can invoke it from the host via 'virsh domfsfreeze' or the
> --quiesce argument to snapshot-create... but you ought to confirm that
> for yourself.

Sure, and I can confirm it works properly in Linux VMs (Windows VMs are 
another matter, if things have not changed).
However it also poses a security risk: a malicious agent can will block 
your *entire* backup process (even for other virtual machines).

So, in some environments, an agentless backup solution is preferred.
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
