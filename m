Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35542 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751574AbdE0QRc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 27 May 2017 12:17:32 -0400
Subject: Re: RFC: removing non-linux platform support from xfsprogs
References: <7d962368-5376-0fca-dbc6-3d3f6fdf50e8@sandeen.net>
 <CACj3i71pW6JxNFzfPMwJW1qz9U54pO2i94_ihhcsb_FwOn_3PQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bd213985-c2b6-6b9f-3d43-88eb2cd73b48@sandeen.net>
Date: Sat, 27 May 2017 11:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i71pW6JxNFzfPMwJW1qz9U54pO2i94_ihhcsb_FwOn_3PQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 5/27/17 2:41 AM, Jan Tulak wrote:
> On Fri, May 26, 2017 at 11:47 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> There's a bunch of mucking about to try to build xfsprogs on non-linux
>> platforms.  Is anyone using that, or care about it?  If not, I propose
>> removing it all in a cruft-reducing effort.
>>
>> If I'm missing some good reason for it to be there, please educate me,
>> and I'll leave it alone.
>>
>> In particular, Jan - I know you did a lot of this work - do you still
>> use it?
>>
> 
> I used the macos stuff at the beginning to get into the code with
> little risk of breaking anything. Until it is possible to mount xfs in
> the other systems, xfsprogs is useless there... So, I'm ok with the
> removal of macos code. I don't know how it is with the other systems,
> though.

Ok, thanks - honestly if you still use it, that's fine.  But if you're
not ... and nobody else is ... let's nuke it.  ;)

-Eric
