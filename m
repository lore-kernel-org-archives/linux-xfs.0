Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from amazon.4net.rs ([159.69.148.70]:54812 "EHLO amazon.4net.rs"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730269AbeLOPgP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 Dec 2018 10:36:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sat, 15 Dec 2018 16:36:10 +0100
From: =?UTF-8?Q?Sini=C5=A1a_Bandin?= <sinisa@4net.rs>
Subject: Re: XFS and RAID10 with o2 layout
In-Reply-To: <23572.5681.810087.381496@quad.stoffel.home>
References: <d9fc0327-eef3-63bd-82a3-98545251bfe5@4net.rs>
 <20181213220533.GH6311@dastard>
 <3e0e8def-2bb4-5e8a-56c1-d010ede059d4@4net.rs>
 <5C13694A.8070303@youngman.org.uk>
 <23572.5681.810087.381496@quad.stoffel.home>
Message-ID: <1a5643d5f68d3dfe1aaa472aac6bd398@4net.rs>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org, linux-raid-owner@vger.kernel.org



On 14.12.2018 21:44, John Stoffel wrote:
>>>>>> "Wols" == Wols Lists <antlists@youngman.org.uk> writes:
> 
> Wols> On 14/12/18 07:03, Sinisa wrote:
>>>> And another MD flush thread waiting on a MD sync barrier.
>>>> 
>>>> Basically, this looks and smells like a MD sync barrier race
>>>> condition, not an XFs problem.
>>>> 
>>>> Cheers,
>>>> 
>>>> Dave.
>>> 
>>> But why don't we see the same issue with other filesystems?
> 
> Wols> Possibly because, iirc, xfs is aware of the underlying raid?
> 
> I don't think it's that in touch with the raid.  It can/does query for
> settings so it can optimize stuff, but I don't think it actually uses
> it other than as a block device.
> 
> Wols> I don't know, but I seem to remember that from earlier 
> discussions about
> Wols> "xfs over mdraid".
> 
> Have you tried doing this with the absolute latest kernel?

Well, not "absolute" but relative :)

Absolute latest being 4.20-rc6, I have tried with 4.20-rc2 or -rc3


-- 
Srdačan pozdrav/Best regards,
Siniša Bandin
