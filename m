Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:50786 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966469AbdDSQkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 12:40:13 -0400
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.111])
        by firestarter.dermichi.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim)
        (envelope-from <mw@dermichi.com>)
        id 1d0seJ-0006Le-Bi
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 18:40:11 +0200
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <20170419142038.n5qj5cxb67dvmifu@eorzea.usersys.redhat.com>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <4980d00b-1cc4-8e2e-d4bc-7dd7cabc2a7d@dermichi.com>
Date: Wed, 19 Apr 2017 18:40:10 +0200
MIME-Version: 1.0
In-Reply-To: <20170419142038.n5qj5cxb67dvmifu@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

> 
> Btw, I'm not very good at xfs journaling code, but I wonder by the stack traces
> you provided, if you don't have a too small journal, which, with your workload,
> it might be getting to flush the logs too many times, making the disk too busy
> and slowing down the rest of the IO.
> 
A good hint. Unfortunately, I don't think there is an option to increase
the log size of an internal log post-mkfs?
