Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:50742 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938108AbdDSQgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 12:36:04 -0400
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.111])
        by firestarter.dermichi.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim)
        (envelope-from <mw@dermichi.com>)
        id 1d0saH-0006AK-96
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 18:36:01 +0200
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
Date: Wed, 19 Apr 2017 18:36:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 19.04.2017 16:04, Carlos Maiolino wrote:
> If I am not blind, the task currently owning the cpu isn't listed there, which I
> suppose to be already running.
Correct, the only process utilizing the CPU is xfsaild. It is also the
only process doing I/O, and it looks like it's doing only reads. It
(xfsaild) never shows up in dmesg as blocked.

> Next time you hit it, could you please paste the stack trace of the task owning
> the cpu? Which I suppose to be xfsaild according to your report.
> 
> A simple `cat /proc/<pid>/stack` is probably enough
Sure, will do.

