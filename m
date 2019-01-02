Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44248 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfABKeN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 05:34:13 -0500
Received: by mail-ed1-f68.google.com with SMTP id y56so25712032edd.11
        for <linux-xfs@vger.kernel.org>; Wed, 02 Jan 2019 02:34:12 -0800 (PST)
Received: from amb.local ([194.99.105.107])
        by smtp.gmail.com with ESMTPSA id v12-v6sm12167693ejk.58.2019.01.02.02.34.10
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Jan 2019 02:34:10 -0800 (PST)
From: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard>
 <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard>
 <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
 <20181130064908.GX6311@dastard> <20181130074547.GY6311@dastard>
 <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
Message-ID: <2a57d498-bf0f-bf48-ff4f-89748660d28e@gmail.com>
Date: Wed, 2 Jan 2019 11:34:09 +0100
MIME-Version: 1.0
In-Reply-To: <CABWYdi28ifToh-yWRAv4MSdJ9g6t-Rxyz2GAFXGFraCwf9BBDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org

On 19/12/2018 23:15, Ivan Babrou wrote:
> We're sticking with the following patch that allows runtime switching
> between XFS memory reclaim strategies:
> 
> * https://github.com/bobrik/linux/pull/2
> 
> There are some tests and graphs describing the issue and how it can be solved.
> 
> Let me know if you think this can be incorporated upstream, I'm fine if not.

This hack and fs.xfs.memory_reclaim=0 solved my problem where backup
server (doing rsnapshot, so tons of rsync+hardlinks+rm+cp of milions
files) was barely usable. Things like ssh or other network services were
stuck for 10-30 minutes doing reclaim.

Hack but for now server behaves much better than with vanilla kernel on
this type of workload.

Thanks,

(resend)
-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
