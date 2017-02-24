Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150220.vpmbghkbxaufyumm@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mr001msb.fastweb.it ([85.18.95.85]:38504 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdBXL7t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2017 06:59:49 -0500
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 5890BA1F010F5161 for linux-xfs@vger.kernel.org; Fri, 24 Feb 2017 12:47:29 +0100
From: Gionatan Danti <g.danti@assyoma.it>
Subject: Increase sync write performance?
Message-ID: <f7c2bf78-dd91-7a4e-a02d-e0f5f90bcc08@assyoma.it>
Date: Fri, 24 Feb 2017 12:47:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi list,
I am trying to understand if, and how, to increase synchronous write 
performance to an XFS filesystem.

A common scenario is an NFS-exported directory with sync writes enabled 
(default). With EXT4, it is possible to mount it using the 
"data=journal" option which, by eliminating small seeks, give a very 
nice performance boost (at least with short write spikes).

AFAIK, XFS only journals metadata, never user data alone. There is 
nothing I can do to increase its sync write performance in this case?

Short of using a powerloss-protected controller/drives with writeback 
caches enabled, of course...

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
