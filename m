Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:19212 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729225AbeJ2P6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 11:58:04 -0400
Date: Mon, 29 Oct 2018 18:10:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Hang and dmesg flood on mounting invalid FS image
Message-ID: <20181029071038.GL19305@dastard>
References: <CAE5jQCc3hrq6E-Ff1oiYUOSDA08PMrqnu80XQtaD5adcUQvV8w@mail.gmail.com>
 <20181029012058.GK19305@dastard>
 <CAE5jQCeT4hONkK8cmkMoReoW-HqVLqnYN6c3YrxDjwNAf=nfEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE5jQCeT4hONkK8cmkMoReoW-HqVLqnYN6c3YrxDjwNAf=nfEA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 29, 2018 at 09:57:20AM +0300, Anatoly Trosinenko wrote:
> > How did the corruption occur?
> 
> It is a fuzzed image. Most probably, it was artificially "patched" by
> fuzzer. Or do you mean "what particular bytes were changed"?

I wondered how this specific corruption occurred in the real world.
If i was a real world problem, it would have been indicative of a
code bug if it did occur (i.e. whatever wrote the log record would
have been broken) but seeing as it's a fuzzer problem, I don't need
to look for any code bugs other than "we didn't validate the input
properly".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
