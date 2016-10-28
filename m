Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33543 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbcJ1FC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2016 01:02:29 -0400
Received: by mail-pf0-f177.google.com with SMTP id 197so30734029pfu.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2016 22:02:29 -0700 (PDT)
Date: Fri, 28 Oct 2016 16:02:18 +1100
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161028160218.1af40906@roar.ozlabs.ibm.com>
In-Reply-To: <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
        <20161027214244.GO14023@dastard>
        <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, 28 Oct 2016 13:12:34 +1100
Nicholas Piggin <npiggin@gmail.com> wrote:

> On Fri, 28 Oct 2016 08:42:44 +1100
> Dave Chinner <david@fromorbit.com> wrote:
> 

> > > I don't know if something like this would be acceptable? It's not pretty,
> > > but I didn't see an easier way.    
> > 
> > ISTR we made the choice not to do that to avoid potential problems
> > with potential race conditions and bugs (i.e. don't modify anything
> > in objects on read access) but I can't point you at anything
> > specific...  
> 
> Sounds pretty reasonable, especially for the verifiers. For the paths
> that create/update the checksums (including this log checksum), it seems
> like it should be less controversial.
> 
> But yes let me get more data first. Thanks for taking a look.

Okay, the XFS crc sizes indeed don't look too so bad, so it's more the
crc implementation I suppose. I was seeing a lot of small calls to crc,
but as a fraction of the total number of bytes, it's not as significant
as I thought. That said, there is some improvement you may be able to
get even from x86 implementation.

I took an ilog2 histogram of frequency and total bytes going to XFS
checksum, with total, head, and tail lengths. I'll give as percentages
of total for easier comparison (total calls were around 1 million and
500MB of data):

                frequency                   bytes
ilog2   total   | head | tail       total | head | tail
  3         0     1.51      0           0   0.01      0
  4         0        0      0           0      0      0
  5         0        0      0           0      0      0
  6         0    22.35      0           0   1.36      0
  7         0    76.10      0           0  14.40      0
  8         0     0.04     ~0           0   0.02     ~0
  9     22.25       ~0  98.39       13.81     ~0  71.07
 10     76.14        0      0       73.77      0      0
 11         0        0      0           0      0      0
 12         0        0   1.60           0      0  12.39
 13      1.60        0      0       12.42      0      0


Keep in mind you have to sum the number of bytes for head and tail to
get ~100%.

Now for x86-64, you need to be at 9-10 (depending on configuration) or
greater to exceed the breakeven point for their fastest implementation.
Split crc implementation will use the fast algorithm for about 85% of
bytes in the best case, 12% at worst. Combined gets there for 85% at
worst, and 100% at best. The slower x86 implementation still uses a
hardware instruction, so it doesn't do too badly.

For powerpc, the breakeven is at 512 + 16 bytes (9ish), but it falls
back to generic implementation for bytes below that.  I think we can
reduce the break even point on powerpc slightly and capture most of
the rest, so it's not so bad.

Anyway at least that's a data point to consider. Small improvement is
possible.

Thanks,
Nick

