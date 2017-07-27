Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41436 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbdG0Nfl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 09:35:41 -0400
Subject: Re: [PATCH 3/7] mkfs: remove intermediate getstr followed by getnum
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-4-jtulak@redhat.com> <20170720155404.GS4224@magnolia>
 <5b66fcad-4cd4-d1d2-611e-56bcb8004dd4@sandeen.net>
 <CACj3i73cMx9GvY=VQzVZyr5nvU-wiT-n4jweX=ccDUzOTzwY8w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <db690569-1804-9816-516f-f77ca0bb7e35@sandeen.net>
Date: Thu, 27 Jul 2017 08:35:39 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i73cMx9GvY=VQzVZyr5nvU-wiT-n4jweX=ccDUzOTzwY8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 7/27/17 2:50 AM, Jan Tulak wrote:
> On Wed, Jul 26, 2017 at 10:49 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 7/20/17 10:54 AM, Darrick J. Wong wrote:

...

>>> Why has dbytes been demoted from uint64_t to int?  This eliminates the
>>> ability to -d size=8G, right?
>>
>> That wasn't a problem in the version I reviewed.... pls don't keep reviewed-by's
>> on patches that change from the reviewed version.  Further, best to indicate
>> explicitly what has changed since the last version, under the "---"
>>
> 
> Yes, I'm sorry about that. :( I forgot to remove the Reviewed-by after
> rebasing it without the uint64 change. :(

No problem, just a friendly reminder.  :)

-Eric
