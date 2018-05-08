Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56886 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbeEHRCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 13:02:55 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 04/21] xfs: Add attibute remove and helper functions
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-5-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxiNvdvw6Hn4bvESitVPgzYYy581KdYiqdBX0XXFpL59Xw@mail.gmail.com>
Message-ID: <ef9ad62a-5e2e-1b8d-4095-7dd2beb0560c@oracle.com>
Date: Tue, 8 May 2018 10:02:52 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiNvdvw6Hn4bvESitVPgzYYy581KdYiqdBX0XXFpL59Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 05/08/2018 12:33 AM, Amir Goldstein wrote:
> On Sun, May 6, 2018 at 8:24 PM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
>> This patch adds xfs_attr_remove_args. These sub-routines remove
>> the attributes specified in @args. We will use this later for setting
>> parent pointers as a deferred attribute operation.
>>
> 
> But this patch also adds xfs_defer_init()+xfs_trans_ijoin()
> so maybe I am not understanding how this work, but it seems
> to be changing logic as well.
> 
> Please say something about this in commit message.
> 
> Thanks,
> Amir.
> 
Oh, let me see if I can take those out.  I think I had tried some code 
in here earlier that used it, but I'm pretty sure it doesnt need to be 
there now.  Will clean up.  Thx!

Allison
