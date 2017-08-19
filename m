Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:58061 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdHSKKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 06:10:20 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr001msb.fastweb.it (8.5.140.05)
        id 59918211002E58B3 for linux-xfs@vger.kernel.org; Sat, 19 Aug 2017 12:05:07 +0200
Subject: Estimate =?UTF-8?Q?xfs=5Frepair=20run=20time?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Aug 2017 12:05:07 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <22ed5cf73260ae39bf59779b302d8ad3@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi list,
using XFS on relatively big filesystems (> 8TB) I was wondering if it is 
possible to estimate how much time an emergency "xfs_repair" would take.

Some specific questions:
- will total time depend on how much the filesystem is filled (I think 
so...)?
- will total time depend on how data are layed on the physical disks 
(ie: fragmented vs sequential)?
- will total time scale down with increasing spindle count (ie: single 
disk vs 4-way RAID10)?

On a related question: I generally use LVM to segregate/isolate my 
virtual machine images. In this manner, even a completely blowed up 
filesystem on one LV can not affect other LV.

How do you feel using a single big LV + XFS + preallocated RAW disk 
images? Can a problem on the main XFS filesystem be contained on only 
some VM files, or it really risks to destroy the entire filesystem?

Thank you all.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
