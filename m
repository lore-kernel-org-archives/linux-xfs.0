Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37948 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdIGEdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 00:33:25 -0400
Date: Thu, 7 Sep 2017 05:33:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: iov_iter_pipe warning.
Message-ID: <20170907043321.GW5426@ZenIV.linux.org.uk>
References: <20170428152955.mafs3f22srmm34aw@codemonkey.org.uk>
 <20170428164313.GK29622@ZenIV.linux.org.uk>
 <20170428165024.ofyl2atpjwohekqa@codemonkey.org.uk>
 <20170428172024.GL29622@ZenIV.linux.org.uk>
 <20170807201818.kykqzexce6ap6aik@codemonkey.org.uk>
 <20170828203130.y6dq5fqovev6wmrv@codemonkey.org.uk>
 <20170829042542.GO4757@magnolia>
 <20170906200337.b5wj3gpfebliindw@codemonkey.org.uk>
 <20170906234617.GW17782@dastard>
 <20170907034835.arjbdpmujs6hs5n4@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907034835.arjbdpmujs6hs5n4@codemonkey.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jones <davej@codemonkey.org.uk>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Wed, Sep 06, 2017 at 11:48:35PM -0400, Dave Jones wrote:

>  > That doesn't seem like an XFS problem - it indicates the pipe we are
>  > filling in generic_file_splice_read() is not being emptied by
>  > whatever we are splicing the file data to....
> 
> The puzzling part is this runs for a day on ext4 or btrfs, whereas I can
> make xfs fall over pretty quickly.  As Darrick pointed out though, this
> could be due to xfs being the only user of iomap_dio_rw.
> 
> I'm juggling a few other things right now, so probably not going to
> have much time to dig further on this until after plumbers + 1 wk.

I'll look into that tomorrow...
