Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44635 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970030AbeEYAyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 May 2018 20:54:10 -0400
Received: by mail-pg0-f67.google.com with SMTP id p21-v6so1520610pgd.11
        for <linux-xfs@vger.kernel.org>; Thu, 24 May 2018 17:54:10 -0700 (PDT)
Date: Thu, 24 May 2018 17:54:06 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180525005406.GD24593@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
 <20180518034600.GW23858@magnolia>
 <20180520001648.GN23861@dastard>
 <20180521153354.GH23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521153354.GH23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Mon, May 21, 2018 at 08:33:54AM -0700, Darrick J. Wong wrote:
> <shrug> openat() semantics are fine enough with me, I think.

I tried.

With openat() we'd have to go through a bit of hoops to figure out which
actual file we ended up using and it was not pretty.  And given the
other snowflake considerations folks wanted to support as that *is* what
typically users support, it turned out much easier to just use good 'ol
open().

New patch set coming.

  Luis
