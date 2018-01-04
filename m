Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr013msb.fastweb.it ([85.18.95.104]:55230 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbeADBiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 20:38:07 -0500
Subject: Re: Block size and read-modify-write
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Jan 2018 02:38:04 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180103225954.GP5858@dastard>
References: <021d36d95a9de952ddd38cc56d18df4f@assyoma.it>
 <20180102102539.5kh2tjo5gmlewiek@odin.usersys.redhat.com>
 <20180103011926.GJ5858@dastard>
 <b58a3a90-0e7b-abca-91ce-8b2d8819a75b@assyoma.it>
 <20180103214741.GO5858@dastard>
 <fa54fea7ec0d836f2c037f7b71a17365@assyoma.it>
 <20180103225954.GP5858@dastard>
Message-ID: <cbb5ecb1dac9d6c26ce9bede5424cedc@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 03-01-2018 23:59 Dave Chinner ha scritto:
> Yes. But I'm talking about the initial page cache writes in your
> tests, and they were all into unwritten extents. These are the
> writes that had different behaviour in exach test case.

I have some difficulties grasping that. Please note that each test is a 
*while loop* of the "dd" command. So, on the first test (dd with cached 
writes), only the first iteration on the loop should write to an 
unwritten extent; the second, third an so on should overwrite real data 
(as "dd" was issued with "oflag=dsync", which immediately flushes data).

So, why you noted that "they were all into unwritten extents"? Again, I 
am missing something?

> That's an application problem, not a filesystem problem. All the
> filesystem can do is align/size the data extents to match what is
> optimal for the underlying storage (as we do for RAID) and hope
> the application is smart enough to do large, well formed IOs to
> the filesystem.

You are right, I am surely approaching the issue from the wrong end...

> I think you've jumped to entirely the wrong conclusion. We do care
> about it because if you can't convey/control data alignment at the
> filesystem level, then you can't fully optimise IO at the
> application level.

Uhm no, it is my (bad) english which failed...
I fully understand XFS does a wonderful job with regard to data 
alignment.
What I inteded to say is that I understand it is not an XFS problem if 
an application does very small writes rather than a large one.

> The reality is that we've been doing these sorts of data alignment
> optimisations for the last 20 years with XFS and applications using
> direct IO. We care an awful lot about alignment of the filesystem
> structure to the underlying device characteristics because if we
> don't then IO performance is extremely difficult to maximise and/or
> make deterministic.
> 
> However, this is such a complex domain that very, very few people
> have the knowledge and expertise to understand how to take advantage
> of it fully. It's hard even to convey just how complex it is to
> people without a solid knowledge base of filesysystem and storage
> knowledge, as this conversion shows...

True. I really thank you for the time spent on explaining the issue.
Apart that studing the source code, there are any resources I can read 
about these advanced topic?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
