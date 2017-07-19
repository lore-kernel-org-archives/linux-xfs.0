Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33443 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdGSH7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 03:59:04 -0400
Received: by mail-io0-f171.google.com with SMTP id 5so25806806iow.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2017 00:59:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170717234814.GK17762@dastard>
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com> <20170717234814.GK17762@dastard>
From: Stefan Ring <stefanrin@gmail.com>
Date: Wed, 19 Jul 2017 09:59:03 +0200
Message-ID: <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
Subject: Re: Collecting aged XFS profiles
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2017 at 1:48 AM, Dave Chinner <david@fromorbit.com> wrote:
> To analyse such things, maybe consider gathering obfuscated metadump
> images rather asking people to run scripts that gather limited
> information.  That way you can develop scripts to extract the
> information your research requires from the filesystem images you
> received, rather than try to draw tenuous conclusions from a limited
> data set...

I have created a metadump that is 1GB in size, xz-compressed. However,
by running strings on it I find that there are many identifiable
remains inside, and I cannot legally pass this on. xfsprogs is
xfsprogs-3.1.1-10.el6, which is obviously really old. I'm reluctant to
just run a newer version on this production machine; after all I've
once almost brought it down by running xfs_bmap on a heavily
fragmented file.

The question is: can I import this metadata image in a VM and recreate
the metadata image from there, using modern xfsprogs? Will this
preserve most of the relevant information?
