Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55472 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbdHQP0v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 11:26:51 -0400
Subject: Re: [PATCH 6/6 v2] mkfs: extend opt_params with a value field
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-5-jtulak@redhat.com>
 <4a7d1fe9-8094-78e8-aca9-f7f0156f0aa7@sandeen.net>
 <20170816213812.GC4796@magnolia>
 <CACj3i72+wAWL0ZVBmC8Kk4_B7=du_J_yoDsyeT=G359u-nv+hw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4750c67f-b2e2-f62d-2865-c01f5d462ba9@sandeen.net>
Date: Thu, 17 Aug 2017 10:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i72+wAWL0ZVBmC8Kk4_B7=du_J_yoDsyeT=G359u-nv+hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 8/17/17 5:08 AM, Jan Tulak wrote:
>>> But also because the above is wrong; it is possible for the filesystem data
>>> portion and log portion to have different sector sizes, if the log is external. [1]
>>> The above would seem to break that, always setting data & log sizes together.

> But in the current for-next tree mkfs does set data and log sector
> size at the same time,
> this patch is not doing anything new

Yes, you are right about this - I lost my train of thought on that one, sorry.

-Eric
