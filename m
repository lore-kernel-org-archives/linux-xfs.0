Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53684 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1433255AbdDYVpW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 17:45:22 -0400
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f106f9ca-54c7-dcaa-08f4-75b3b086138c@sandeen.net>
Date: Tue, 25 Apr 2017 16:45:20 -0500
MIME-Version: 1.0
In-Reply-To: <20170423185503.31415-5-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/23/17 1:54 PM, Jan Tulak wrote:
> Merge separate instances of opt_params into one indexable table. Git
> makes this patch looks a bit more complicated, but it does not change
> values or structure of anything else. It only moves all the "struct
> opt_params dopts = {...}", changes indentation for these substructures
> and replaces their usage (dopts -> opts[OPT_D]).

This looks correct.  Can you remind me why it helps?  :)
(the commit log says what you did but not why you did it)


One thing I wondered about to idiot-proof the code a bit (in some
other patch, not this one, but while I'm looking at it):

What about instead of:

    switch (getsubopt(&p, subopts, &value)) {
    case OPT1:
            opt1 = getnum(value, &opts, OPT1);
    case OPT2:
            opt2 = getnum(value, &opts, OPT2);
				...

and making sure there's never a mismatch between the case value and the
value passed to getnum, you could do something like:

    int so = getsubopt(&p, subopts, &value);

    switch (so) {
    case OPT1:
            opt1 = getnum(value, &opts, so);
    case OPT2:
            opt2 = getnum(value, &opts, so);
				...

so that you can never mismatch & pass in the wrong subopt for option
checking; it will always be the subopt matched by the case statement.

I just considered that as I reviewed it and found myself mentally
checking that each case matched.

Thanks,
-Eric
