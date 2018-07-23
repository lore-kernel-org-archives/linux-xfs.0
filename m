Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-bn3nam01on0135.outbound.protection.outlook.com ([104.47.33.135]:62912
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388113AbeGWP2f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 11:28:35 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Re: Query about the handling of a bug reported before
Date: Mon, 23 Jul 2018 14:27:02 +0000
Message-ID: <0845407C-6013-44BB-95D0-F1CC66B0ECB6@gatech.edu>
References: <21AA8603-85D9-429A-A713-8B86F341FFC4@gatech.edu>
 <20180723123239.GA46987@bfoster>
In-Reply-To: <20180723123239.GA46987@bfoster>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4684B08A3A93DE4D8964ECC9349855FB@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

Hi Brian,

Yeah I tested it which is fixed in latest kernel. I just wonder if there is a specific patch
for this.

Thanks,
Wen

> On Jul 23, 2018, at 8:32 AM, Brian Foster <bfoster@redhat.com> wrote:
> 
> On Sun, Jul 22, 2018 at 06:30:03AM +0000, Xu, Wen wrote:
>> Hi XFS developers,
>> 
>> I wonder if this bug
>> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=200127
>> 
>> has already been resolved by any patch.
>> 
> 
> It looks like you're on a kernel that already has the agfl reset
> mechanism. I'm not aware of anything else in that area off the top of my
> head, but FWIW, I don't see the KASAN error with a quick check on a
> KASAN-enabled latest for-next (4.18.0-rc4) kernel. Have you given that a
> try?
> 
> Brian
> 
>> Thanks,
>> Wen
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

