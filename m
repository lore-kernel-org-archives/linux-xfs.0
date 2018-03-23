Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35286 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbeCWJKb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 05:10:31 -0400
Received: by mail-wr0-f196.google.com with SMTP id 80so10254839wrb.2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 02:10:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180322195012.GC4818@magnolia>
References: <7d962368-5376-0fca-dbc6-3d3f6fdf50e8@sandeen.net>
 <CACj3i71pW6JxNFzfPMwJW1qz9U54pO2i94_ihhcsb_FwOn_3PQ@mail.gmail.com>
 <bd213985-c2b6-6b9f-3d43-88eb2cd73b48@sandeen.net> <20180322195012.GC4818@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 23 Mar 2018 10:10:09 +0100
Message-ID: <CACj3i71gctiwHzLsUFiX=N8g-dHaOKZPXUSA45NF=2EDcquVLA@mail.gmail.com>
Subject: Re: RFC: removing non-linux platform support from xfsprogs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 8:50 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sat, May 27, 2017 at 11:17:30AM -0500, Eric Sandeen wrote:
>>
>>
>> On 5/27/17 2:41 AM, Jan Tulak wrote:
>> > On Fri, May 26, 2017 at 11:47 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> >> There's a bunch of mucking about to try to build xfsprogs on non-linux
>> >> platforms.  Is anyone using that, or care about it?  If not, I propose
>> >> removing it all in a cruft-reducing effort.
>> >>
>> >> If I'm missing some good reason for it to be there, please educate me,
>> >> and I'll leave it alone.
>> >>
>> >> In particular, Jan - I know you did a lot of this work - do you still
>> >> use it?
>> >>
>> >
>> > I used the macos stuff at the beginning to get into the code with
>> > little risk of breaking anything. Until it is possible to mount xfs in
>> > the other systems, xfsprogs is useless there... So, I'm ok with the
>> > removal of macos code. I don't know how it is with the other systems,
>> > though.
>>
>> Ok, thanks - honestly if you still use it, that's fine.  But if you're
>> not ... and nobody else is ... let's nuke it.  ;)
>
> Ten months and nobody else has said anything, let's nuke non-linux
> support.
>

Sure. Are you working on it, or would you appreciate if someone took
care of it? :-)

Jan
