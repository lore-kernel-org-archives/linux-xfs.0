Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pavilion.ashurst.eu.org ([85.119.82.45]:34070 "EHLO
        pavilion.ashurst.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdG3OlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jul 2017 10:41:18 -0400
From: Andy Bennett <andyjpb@ashurst.eu.org>
Date: Sun, 30 Jul 2017 15:41:14 +0100
MIME-Version: 1.0
Message-ID: <ffb2d26a-5113-419b-9094-ee8cc781527f@ashurst.eu.org>
In-Reply-To: <20170727124350.GB3858@bfoster.bfoster>
References: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
 <20170726111541.GB59833@bfoster.bfoster>
 <0e11333c-0f02-4e4d-8ab2-0d86cb78d7e4@ashurst.eu.org>
 <20170727124350.GB3858@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Subject: Re: Recover file after truncate
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi,

> The free space btree can be traversed offline via the xfs_db utility.
> Something like the following could give you the free extent information
> for each AG in the fs.
>
> for i in $(seq 0 <maxag>); do
> 	echo agno $i
> 	xfs_db -c "agf $i" -c "addr bnoroot" -c "btdump"  <dev>
> done

My xfs_db didn't have 'btdump' but I discovered 'freesp -d' which 
summarised the free regions for all AGs at once. I also needed to use 
'xfs_db -r ...' to attach it to the filesystem as it was still mounted 
read-write. (I wasn't sure if remounting it or unmounting it and mounting 
it again would destroy the logs.)


Thanks again for your help.



Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF
