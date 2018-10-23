Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39572 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbeJWUdj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 16:33:39 -0400
Subject: Re: xfsdump cleaning patchset
References: <CACj3i73FyABTkX1eCDvL+ccUhD1kWowS92=PFVyGiPvi6HWGFQ@mail.gmail.com>
 <20181022174316.GA28561@infradead.org>
 <90559dfb-5222-4faf-a9bb-a314cc645129@sandeen.net>
 <83eb725e-800d-b597-29d9-52d8a672c82c@sandeen.net>
 <CACj3i72hTgnkiM7Z99UVYYNJZaTQ2BM8hFYURDhxXbSX7enWgQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <392a4c28-9800-fe40-73b9-632370093d50@sandeen.net>
Date: Tue, 23 Oct 2018 07:10:25 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i72hTgnkiM7Z99UVYYNJZaTQ2BM8hFYURDhxXbSX7enWgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>



On 10/23/18 3:16 AM, Jan Tulak wrote:
>> I'm not a huge fan of "fix buffer overflows by making them arbitrarily
>> bigger" - can we use i.e. snprintf to make sure it won't happen again,
>> and maybe size them based on ... something, instead of "eh, [5000] is
>> hopefully enough?"
> I based the new size on gcc outputs, it said how much it can overflow.
> But I checked the numbers only once or twice and didn't verify it for
> other reports.

It's always possible that I'm wrong and I'm missing something.  :)
What did gcc say for the cases I pointed out?

> Sure. Well, back to the drawing board. 

Eh not entirely, just recheck some stuff.  Just make sure you keep
the big picture in mine when you're looking at coverity reports.

Thanks,
-Eric
