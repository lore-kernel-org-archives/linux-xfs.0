Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbeAIJ1y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 04:27:54 -0500
MIME-Version: 1.0
In-Reply-To: <1515447593.3486.54.camel@kernel.org>
References: <20171222120556.7435-1-jlayton@kernel.org> <20171222120556.7435-20-jlayton@kernel.org>
 <CAJKOXPd8ojTjiGF3nKQKWtVrEsjWfjvg6rLL+RGnbu_SZMDu7g@mail.gmail.com>
 <1515416208.3486.14.camel@kernel.org> <CAJKOXPfv4eSERDiUuZuJ7KdpyGU0=Eqt_A+J6knp-FEW9BZoSw@mail.gmail.com>
 <1515418164.3486.18.camel@kernel.org> <20180108172928.aqndozcpljb73uj6@kozik-lap>
 <1515434419.3486.41.camel@kernel.org> <20180108183353.emiwsd4aic4gmytr@kozik-lap>
 <1515438929.3486.48.camel@kernel.org> <20180108201713.rdfjn7j65cuqmwuo@kozik-lap>
 <1515447593.3486.54.camel@kernel.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Tue, 9 Jan 2018 10:27:50 +0100
Message-ID: <CAJKOXPfW8h4U8RKY86Sz-5BVxRQAu-ACEJtZ0hCiLVSn7tEB0Q@mail.gmail.com>
Subject: Re: [PATCH v4 19/19] fs: handle inode->i_version more efficiently
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, linux-samsung-soc@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, =?UTF-8?B?QmFydMWCb21pZWogxbtvxYJuaWVya2lld2ljeg==?= <b.zolnierkie@samsung.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>

On Mon, Jan 8, 2018 at 10:39 PM, Jeff Layton <jlayton@kernel.org> wrote:
>>
>
> Got it, that's helpful. Does this patch help (on top of the others) ?
>
> ------------------------8<--------------------------
>
> SQUASH: nfs: compare raw iversion counter since that's what's
>  being stored
>

Did not apply cleanly (in include/linux/iversion.h) but it was easy to
adjust. However still no improvements. Applied on top of others.

Best regards,
Krzysztof
